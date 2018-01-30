//
//  PersistenceManager.m
//  Zen Habits Reader
//
//  Created by Keegan on 9/20/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PersistenceManager.h"
#import "KGNUtilities.h"
#import "Month.h"
#import "Year.h"

@implementation PersistenceManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize backgroundManagedObjectContext = _backgroundManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (PersistenceManager *)sharedInstance {
  static PersistenceManager *sharedInstance;
  if (sharedInstance == nil) {
    sharedInstance = [[PersistenceManager alloc] init];
  }

  return sharedInstance;
}

- (void)contextHasChanged:(NSNotification *)notification {
  if (notification.object == self.managedObjectContext)
    return;

  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(contextHasChanged:)
                           withObject:notification
                        waitUntilDone:YES];
    return;
  }

  [self.managedObjectContext
      mergeChangesFromContextDidSaveNotification:notification];
  [self saveContext];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the
// persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }

  NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc]
        initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = coordinator;
  }
  return _managedObjectContext;
}

- (NSManagedObjectContext *)backgroundManagedObjectContext {
  if (_backgroundManagedObjectContext != nil) {
    return _backgroundManagedObjectContext;
  }

  _backgroundManagedObjectContext = [[NSManagedObjectContext alloc]
      initWithConcurrencyType:NSPrivateQueueConcurrencyType];
  _backgroundManagedObjectContext.parentContext = self.managedObjectContext;
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(contextHasChanged:)
             name:NSManagedObjectContextDidSaveNotification
           object:nil];
  return _backgroundManagedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's
// model.
- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }

  NSURL *modelURL =
      [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
  _managedObjectModel =
      [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's
// store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }

  NSURL *storeURL = [[self applicationDocumentsDirectory]
      URLByAppendingPathComponent:@"ZenHabitsReader.sqlite"];

  // Pre-load DB
  if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
    NSURL *preloadURL =
        [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                   pathForResource:@"ZenHabitsReader"
                                            ofType:@"sqlite"]];
    NSError *err = nil;

    if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL
                                                 toURL:storeURL
                                                 error:&err]) {
      NSLog(@"Oops, could copy preloaded data");
    }
  }

  NSError *error = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
      initWithManagedObjectModel:self.managedObjectModel];
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeURL
                                                       options:nil
                                                         error:&error]) {
    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    abort();
  }

  return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
  return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                 inDomains:NSUserDomainMask].lastObject;
}

#pragma mark - Saving and Loading Methods

- (void)saveContext {
  BOOL isBackground;
  isBackground = ![NSThread isMainThread];
  // dispatch_async(dispatch_get_main_queue(), ^{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext =
      isBackground ? self.backgroundManagedObjectContext
                   : self.managedObjectContext;
  if (managedObjectContext != nil) {
    if (managedObjectContext.hasChanges &&
        ![managedObjectContext save:&error]) {
      // TODO: Replace this implementation with code to handle the error
      // appropriately.
      // abort() causes the application to generate a crash log and terminate.
      // You should not use this function in a shipping application, although it
      // may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, error.userInfo);

#ifdef DEBUG
      abort();
#endif
    }
    [[NSNotificationCenter defaultCenter]
        postNotificationName:NSManagedObjectContextDidSaveNotification
                      object:managedObjectContext];
  }
}

#pragma mark - Unique Creators

- (Year *)getOrCreateUniqueYear:(NSString *)yearString {
  Year *uniqueYear = nil;
  NSManagedObjectContext *context = self.managedObjectContext;

  uniqueYear = [self getYear:yearString];

  if (!uniqueYear) {
    uniqueYear = [NSEntityDescription insertNewObjectForEntityForName:@"Year"
                                               inManagedObjectContext:context];
    uniqueYear.theYear = yearString;
  }

  return uniqueYear;
}

- (Month *)getOrCreateUniqueMonth:(NSString *)monthString
                     yearForMonth:(Year *)year {
  NSError *executeFetchError = nil;
  static NSFetchRequest *request;
  NSManagedObjectContext *context = self.managedObjectContext;
  Month *uniqueMonth;

  if (!request) {
    request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Month"
                                 inManagedObjectContext:context];
  }

  request.predicate = [NSPredicate
      predicateWithFormat:@"(year.theYear = %@) AND (monthOfYear = %@)",
                          year.theYear, monthString];

  uniqueMonth = [context executeFetchRequest:request error:&executeFetchError].lastObject;

  if (executeFetchError) {
    NSLog(@"[%@, %@] error looking up month with month string: %@ and year "
          @"string: %@ with error: %@",
          NSStringFromClass([self class]), NSStringFromSelector(_cmd),
          monthString, year.theYear, executeFetchError.localizedDescription);
  } else if (!uniqueMonth) {
    uniqueMonth = [NSEntityDescription insertNewObjectForEntityForName:@"Month"
                                                inManagedObjectContext:context];
    uniqueMonth.monthOfYear = monthString;
    uniqueMonth.year = year;
    uniqueMonth.date = [KGNUtilities
        dateFromFriendlyString:[NSString stringWithFormat:@"1 %@ %@",
                                                          monthString,
                                                          year.theYear]];
    [year addMonthsObject:uniqueMonth];
  }

  return uniqueMonth;
}

#pragma mark - Collections

- (NSArray *)allPostHeadersWithSortDescriptor:(NSSortDescriptor *)sortDescriptor
                                 andPredicate:(NSPredicate *)predicate {
  NSError *error;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity =
      [NSEntityDescription entityForName:@"PostHeader"
                  inManagedObjectContext:self.managedObjectContext];
  fetchRequest.entity = entity;

  if (sortDescriptor) {
    fetchRequest.sortDescriptors = @[sortDescriptor];
  }

  if (predicate) {
    fetchRequest.predicate = predicate;
  }

  NSArray *fetchedObjects =
      [self.managedObjectContext executeFetchRequest:fetchRequest
                                                 error:&error];

  if (error) {
    NSLog(@"%@", error);
    return nil;
  }

  return fetchedObjects;
}

- (NSArray *)allPostHeaders {
  return [self allPostHeadersWithSortDescriptor:nil andPredicate:nil];
}

- (NSArray *)allMonths {
  NSError *error;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity =
      [NSEntityDescription entityForName:@"Month"
                  inManagedObjectContext:self.managedObjectContext];
  fetchRequest.entity = entity;
  NSArray *fetchedObjects =
      [self.managedObjectContext executeFetchRequest:fetchRequest
                                                 error:&error];

  if (error) {
    NSLog(@"%@", error);
    return nil;
  }

#ifdef DEBUG
  for (Month *month in fetchedObjects) {
    if ([month.monthOfYear isEqualToString:@"January"] &&
        [month.year.theYear isEqualToString:@"2015"]) {
      NSLog(@"\n*****************Month*****************\n");
      NSLog(@"Month: %@", month.monthOfYear);
      NSLog(@"Year: %@", month.year.theYear);
      for (PostHeader *post in month.posts) {
        NSLog(@"  %@", post.title);
      }
    }
  }
#endif
  return fetchedObjects;
}

- (NSArray *)allNewPostHeaders {
  NSDate *checkDate = (NSDate *)[[NSUserDefaults standardUserDefaults]
      objectForKey:@"firstCheckDate"];
  if (!checkDate) {
    NSLog(@"No firstCheckDate!!");
    checkDate = [NSDate date]; // firstCheckDate is not set yet. Set it to now,
                               // so we fetch nothing.
  }

  NSPredicate *predicate = [NSPredicate
      predicateWithFormat:@"(isRead = NO) AND (date > %@) AND (isNew = YES)",
                          checkDate];
  return [self allPostHeadersWithSortDescriptor:nil andPredicate:predicate];
}

- (NSArray *)allYears {
  NSError *error;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity =
      [NSEntityDescription entityForName:@"Year"
                  inManagedObjectContext:self.managedObjectContext];
  fetchRequest.entity = entity;
  NSArray *fetchedObjects =
      [self.managedObjectContext executeFetchRequest:fetchRequest
                                                 error:&error];

  if (error) {
    NSLog(@"%@", error);
    return nil;
  }

#ifdef DEBUG
  for (Year *year in fetchedObjects) {
    NSLog(@"\n*****************Year*****************\n");
    NSLog(@"Year: %@", year.theYear);
    for (Month *month in year.months) {
      NSLog(@"   %@", month.monthOfYear);
    }
  }
#endif
  return fetchedObjects;
}

- (Year *)getYear:(NSString *)yearString {
  Year *uniqueYear = nil;
  NSError *executeFetchError = nil;
  static NSFetchRequest *request;
  NSManagedObjectContext *context = self.managedObjectContext;

  if (!request) {
    request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Year"
                                 inManagedObjectContext:context];
  }

  request.predicate =
      [NSPredicate predicateWithFormat:@"theYear = %@", yearString];

  uniqueYear = [context executeFetchRequest:request error:&executeFetchError].lastObject;

  if (executeFetchError) {
    NSLog(@"[%@, %@] error looking up year with year string: %@ with error: %@",
          NSStringFromClass([self class]), NSStringFromSelector(_cmd),
          yearString, executeFetchError.localizedDescription);
  }

  return uniqueYear;
}

#pragma mark - Functional methods

- (PostHeader *)getMostRecentPost {
  PostHeader *postHeader;
  NSArray *postCollection;
  NSSortDescriptor *sortDescriptor;

  sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
  postCollection =
      [self allPostHeadersWithSortDescriptor:sortDescriptor andPredicate:nil];
  postHeader = postCollection ? postCollection[0] : nil;
  return postHeader;
}

- (void)createPostHeaderWithTitle:(NSString *)title
                           andUrl:(NSString *)url
                           andDay:(NSString *)day
                         andMonth:(NSString *)month
                          andYear:(NSString *)year
                         andIsNew:(BOOL)isNew
                        andIsRead:(BOOL)isRead
                        andPostID:(NSString *)postID {
  NSError *executeFetchError = nil;
  static NSFetchRequest *request;
  Year *postYear;
  Month *postMonth;
  PostHeader *postHeader;

  NSManagedObjectContext *context = self.managedObjectContext;

  if (!request) {
    request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"PostHeader"
                                 inManagedObjectContext:context];
  }

  request.predicate = [NSPredicate predicateWithFormat:@"postID = %@", postID];

  postHeader = [context executeFetchRequest:request error:&executeFetchError].lastObject;

  if (executeFetchError) {
    NSLog(
        @"[%@, %@] error looking up year with postID string: %@ with error: %@",
        NSStringFromClass([self class]), NSStringFromSelector(_cmd), postID,
        executeFetchError.localizedDescription);
  } else if (!postHeader) {
    postYear = [self getOrCreateUniqueYear:year];
    postMonth = [self getOrCreateUniqueMonth:month yearForMonth:postYear];

    postHeader =
        [NSEntityDescription insertNewObjectForEntityForName:@"PostHeader"
                                      inManagedObjectContext:context];

    postHeader.title =
        [title stringByReplacingOccurrencesOfString:@"\r\n\t\t\t\t\t"
                                         withString:@""];
                                                          
    postHeader.date = [KGNUtilities
        dateFromFriendlyString:[NSString stringWithFormat:@"%@ %@ %@", day,
                                                          month, year]];
    postHeader.isNew = @(isNew);
    postHeader.isRead = @(isRead);
    postHeader.url = url;
    postHeader.postID = postID;
    postHeader.month = postMonth;

    [postMonth addPostsObject:postHeader];
    [self saveContext];
  } else {
    NSLog(@"Trying to create a post with an existing ID! Existing title: %@. "
          @"New title: %@",
          postHeader.title, title);
  }
}

- (PostHeader *)getPostHeaderWithPostID:(NSString *)postID {
  PostHeader *postHeader;
  NSPredicate *predicate;

  predicate = [NSPredicate predicateWithFormat:@"postID = %@", postID];
  postHeader = [self getPostHeaderWithPredicate:predicate];
  NSAssert(postHeader, @"Could not fetch a post with postID %@", postID);
  return postHeader;
}

- (PostHeader *)getPostHeaderWithTitle:(NSString *)title {
  PostHeader *postHeader;
  NSPredicate *predicate;

  predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
  postHeader = [self getPostHeaderWithPredicate:predicate];
  NSAssert(postHeader, @"Could not fetch a post with title %@", title);
  return postHeader;
}

- (PostHeader *)getPostHeaderWithPredicate:(NSPredicate *)predicate {
  static NSFetchRequest *request;
  NSError *executeFetchError = nil;
  PostHeader *postHeader;
  NSManagedObjectContext *context = self.managedObjectContext;

  if (!request) {
    request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"PostHeader"
                                 inManagedObjectContext:context];
  }

  request.predicate = predicate;

  postHeader = [context executeFetchRequest:request error:&executeFetchError].lastObject;

  if (executeFetchError) {
    NSLog(@"%s:Could not execute fetch request. Error: %@", __PRETTY_FUNCTION__,
          executeFetchError.description);
  }

  return postHeader;
}

@end
