//
//  PostLoader.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PersistenceManager.h"
#import "TFHpple.h"
#import <Foundation/Foundation.h>

@interface PostLoader : NSObject

+ (void)loadPosts;
+ (NSString *)getPostBodyHTMLFromPostUrl:(NSString *)postURL
                                andTitle:(NSString *)postTitle;
+ (BOOL)downloadAllPostsAfterDate:(NSDate *)dateToCheck;

@end
