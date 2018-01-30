//
//  AppDelegate.m
//  Zen Habits Reader
//
//  Created by Keegan on 9/20/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "AppDelegate.h"
#import "KGNUtilities.h"
#import "PostLoader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)
                  application:(UIApplication *)application
didFinishLaunchingWithOptions:
    (NSDictionary *)
        launchOptions { // date here that comes from core data (last check time)
  self.window.tintColor = [UIColor whiteColor];

  // set color of unselected text to grey
  [[UITabBarItem appearance]
      setTitleTextAttributes:
          [NSDictionary
              dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:0.8 alpha:1],
                                           NSForegroundColorAttributeName, nil]
                    forState:UIControlStateNormal];

  // set color of selected text to white
  [[UITabBarItem appearance]
      setTitleTextAttributes:
          [NSDictionary
              dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                                           NSForegroundColorAttributeName, nil]
                    forState:UIControlStateSelected];

  // if date older than today, check
  [PostLoader loadPosts];
  [application setMinimumBackgroundFetchInterval:
                   UIApplicationBackgroundFetchIntervalMinimum];

  UIUserNotificationType types =
      UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;

  UIUserNotificationSettings *mySettings =
      [UIUserNotificationSettings settingsForTypes:types categories:nil];

  [[UIApplication sharedApplication]
      registerUserNotificationSettings:mySettings];

  // Set the unselected tab bar items to specified image. This is because the
  // default grey does not correspond with the unselected text grey i am setting
  // above
  UITabBarController *t = (UITabBarController *)self.window.rootViewController;
  t.tabBar.items[0].image = [[UIImage imageNamed:@"book_grey"]
      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  t.tabBar.items[1].image = [[UIImage imageNamed:@"idea_grey"]
      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

  return YES;
}

- (void)application:(UIApplication *)application
    performFetchWithCompletionHandler:
        (void (^)(UIBackgroundFetchResult))completionHandler {
  NSDate *mostRecentPostDate;
  PostHeader *mostRecentPost;

  [[PersistenceManager sharedInstance]
      setBackgroundChecks:[[PersistenceManager sharedInstance]
                              backgroundChecks] +
                          1];
  mostRecentPost = [[PersistenceManager sharedInstance] getMostRecentPost];
  mostRecentPostDate = mostRecentPost
                           ? mostRecentPost.date
                           : [NSDate dateWithTimeIntervalSince1970:0];

  if (!mostRecentPost) {
    NSLog(@"*** No most recent post! ***");
  }

  BOOL didFindNewPosts =
      [PostLoader downloadAllPostsAfterDate:mostRecentPostDate];

  if (didFindNewPosts) {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNotification.alertBody = @"New content is available";
    localNotification.alertTitle = @"Zen Breath";
    // TODO: for all new posts, increment the badge number
    // localNotification.applicationIconBadgeNumber = [[PersistenceManager
    // newPosts] count];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication]
        scheduleLocalNotification:localNotification];
  }

  completionHandler(didFindNewPosts ? UIBackgroundFetchResultNewData
                                    : UIBackgroundFetchResultNoData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
  [[PersistenceManager sharedInstance] saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[PersistenceManager sharedInstance] saveContext];
}

@end
