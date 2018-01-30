//
//  KGNUtilities.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KGNUtilities : NSObject

+ (UIColor *)primaryColor;

+ (NSDate *)dateFromFriendlyString:(NSString *)friendlyString;

+ (BOOL)isDateBeforeToday:(NSDate *)date;

+ (NSString *)monthOfYearAsString:(NSInteger)monthOfYear;

@end
