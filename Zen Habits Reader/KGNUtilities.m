//
//  KGNUtilities.m
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "KGNUtilities.h"

@implementation KGNUtilities
static UIView *loadingView;

+ (UIColor*) primaryColor
    {
    return [UIColor colorWithRed:170.00/255.00 green:119.00/255.00 blue:0.00/255.00 alpha:1];
    }

+ (NSDate *) dateFromFriendlyString: (NSString *)friendlyString
    {
        static NSDateFormatter *mmddyyyy;
        
        if (!mmddyyyy)
        {
            mmddyyyy = [[NSDateFormatter alloc] init];
            mmddyyyy.timeStyle = NSDateFormatterNoStyle;
            mmddyyyy.dateFormat = @"d LLLL yyyy";
            [mmddyyyy setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        }
        
        return [mmddyyyy dateFromString:friendlyString];
    }

+ (BOOL) isDateBeforeToday: (NSDate*) date
{
    NSDateFormatter *dateFormatter;
    NSDate *today;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    today = [currentCalendar dateFromComponents:components];
    
    NSDate *earlierDate = [today earlierDate:date];
    
    if ([earlierDate isEqualToDate: date])
    {
        NSLog(@"This happened before today!");
        return true;
    }
    else
    {
        NSLog(@"This happened today!");
        return false;
    }
}

+ (NSString*)monthOfYearAsString: (NSInteger)monthOfYear
    {
    static NSArray* monthsArray;
    
    if (!monthsArray)
        {
        monthsArray = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
        }
        
    return (NSString*)monthsArray[monthOfYear];
    }

@end
