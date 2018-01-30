//
//  PostHeader+CoreDataProperties.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PostHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostHeader (CoreDataProperties)

@property(nullable, nonatomic, retain) NSDate *date;
@property(nullable, nonatomic, retain) NSNumber *isNew;
@property(nullable, nonatomic, retain) NSNumber *isRead;
@property(nullable, nonatomic, retain) NSString *postID;
@property(nullable, nonatomic, retain) NSString *title;
@property(nullable, nonatomic, retain) NSString *url;
@property(nullable, nonatomic, retain) Month *month;

@end

NS_ASSUME_NONNULL_END
