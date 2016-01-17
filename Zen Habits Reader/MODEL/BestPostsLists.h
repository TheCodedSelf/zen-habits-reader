//
//  BestPostsLists.h
//  Zen Habits Reader
//
//  Created by Keegan on 11/9/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BestPostsLists : NSObject
+ (int) mostRecentPostYear;
+ (NSString*) predicateForYear: (NSInteger) year;
@end
