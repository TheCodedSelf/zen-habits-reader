//
//  Month+CoreDataProperties.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Month.h"

NS_ASSUME_NONNULL_BEGIN

@interface Month (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *monthOfYear;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) Year *year;
@property (nullable, nonatomic, retain) NSSet<PostHeader *> *posts;

@end

@interface Month (CoreDataGeneratedAccessors)

- (void)addPostsObject:(PostHeader *)value;
- (void)removePostsObject:(PostHeader *)value;
- (void)addPosts:(NSSet<PostHeader *> *)values;
- (void)removePosts:(NSSet<PostHeader *> *)values;

@end

NS_ASSUME_NONNULL_END
