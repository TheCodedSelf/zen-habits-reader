//
//  PersistenceManager.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/20/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PostHeader.h"
#import "Year.h"
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface PersistenceManager : NSObject
@property(readonly, strong, nonatomic)
    NSManagedObjectContext *managedObjectContext;
@property(readonly, strong, nonatomic)
    NSManagedObjectContext *backgroundManagedObjectContext;
@property(readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(readonly, strong, nonatomic)
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic) int backgroundChecks;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *allPostHeaders;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *allMonths;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *allYears;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *allNewPostHeaders;

- (void)saveContext;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSURL *applicationDocumentsDirectory;

- (PostHeader *)getPostHeaderWithTitle:(NSString *)title;
- (PostHeader *)getPostHeaderWithPostID:(NSString *)postID;
@property (NS_NONATOMIC_IOSONLY, getter=getMostRecentPost, readonly, strong) PostHeader *mostRecentPost;
- (Year *)getYear:(NSString *)yearString;

- (void)createPostHeaderWithTitle:(NSString *)title
                           andUrl:(NSString *)url
                           andDay:(NSString *)day
                         andMonth:(NSString *)month
                          andYear:(NSString *)year
                         andIsNew:(BOOL)isNew
                        andIsRead:(BOOL)isRead
                        andPostID:(NSString *)postID;

+ (PersistenceManager *)sharedInstance;

@end
