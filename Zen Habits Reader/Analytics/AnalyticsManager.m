//
//  AnalyticsManager.m
//  Zen Habits Reader
//
//  Created by Keegan on 1/8/16.
//  Copyright © 2016 Keegan. All rights reserved.
//

#import "AnalyticsManager.h"
#import <Google/Analytics.h>
@implementation AnalyticsManager

static NSString* const IAPCategory = @"InAppPurchases";
static NSString* const IAPAction = @"In App Purchase";

static NSString* const PostsCategory = @"Posts";
static NSString* const PostsReadAction = @"Post Read";

static NSString* const OtherCategory = @"Other";
static NSString* const ClickedAction = @"Other";

+ (void)performInitialSetup
    {
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    }

+ (void)reportNavigationToScreen:(NSString*)name
    {
#if DEBUG
    return;
#endif
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }

+ (void)reportIAPPurchased
    {
    [self sendEventWithCategory:IAPCategory action:IAPAction label:@"IAP Purchased"];
    }

+ (void)reportIAPRestored
    {
    [self sendEventWithCategory:IAPCategory action:IAPAction label:@"IAP Restored"];
    }

+ (void)reportIAPDeferred
    {
    [self sendEventWithCategory:IAPCategory action:IAPAction label:@"IAP Deferred"];
    }

+ (void)reportIAPPurchasing
    {
    [self sendEventWithCategory:IAPCategory action:IAPAction label:@"IAP Purchasing"];
    }

+ (void)reportIAPFailed
    {
    [self sendEventWithCategory:IAPCategory action:IAPAction label:@"IAP Failed"];
    }

+ (void)reportIAPUnavailable
    {
    [self sendEventWithCategory:IAPCategory action:IAPAction label:@"IAP Unavailable"];
    }

+ (void)reportIAPMaybeLater
    {
    [self sendEventWithCategory:IAPCategory action:IAPAction label:@"IAP Maybe Later"];
    }

+ (void)reportPostReadWithTitle: (NSString*)title
    {
    [self sendEventWithCategory:PostsCategory action:PostsReadAction label:title];
    }

+ (void)reportRateInAppStoreClicked
    {
    [self sendEventWithCategory:OtherCategory action:ClickedAction label:@"Rate In App Store Clicked"];
    }

+ (void)sendEventWithCategory:(NSString*)category action:(NSString*)action label:(NSString*)label
    {
#if DEBUG
    return;
#endif
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:@1] build]];
    }

@end
