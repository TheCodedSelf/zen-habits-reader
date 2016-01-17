//
//  PersistenceManager.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/20/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PostHeader.h"
#import "Year.h"

@interface PersistenceManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) int backgroundChecks;

- (NSArray *)allPostHeaders;
- (NSArray *)allMonths;
- (NSArray *)allYears;
- (NSArray *) allNewPostHeaders;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (PostHeader *)getPostHeaderWithTitle: (NSString*) title;
- (PostHeader *)getPostHeaderWithPostID: (NSString*) postID;
- (PostHeader*) getMostRecentPost;
- (Year *) getYear:(NSString *)yearString;

- (void)createPostHeaderWithTitle: (NSString*)title andUrl: (NSString*)url andDay: (NSString*)day andMonth:(NSString*)month andYear:(NSString*)year andIsNew: (BOOL)isNew andIsRead: (BOOL)isRead andPostID: (NSString*)postID;

+ (PersistenceManager *) sharedInstance;

@end
