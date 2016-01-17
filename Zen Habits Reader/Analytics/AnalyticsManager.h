//
//  AnalyticsManager.h
//  Zen Habits Reader
//
//  Created by Keegan on 1/8/16.
//  Copyright © 2016 Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsManager : NSObject
+ (void)performInitialSetup;
+ (void)reportNavigationToScreen:(NSString*)name;
+ (void)reportIAPPurchased;
+ (void)reportIAPRestored;
+ (void)reportIAPDeferred;
+ (void)reportIAPFailed;
+ (void)reportIAPPurchasing;
+ (void)reportIAPMaybeLater;
+ (void)reportPostReadWithTitle: (NSString*)title;
+ (void)reportRateInAppStoreClicked;
+ (void)reportIAPUnavailable;
@end
