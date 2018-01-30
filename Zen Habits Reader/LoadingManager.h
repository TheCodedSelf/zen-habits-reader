//
//  LoadingManager.h
//  Zen Habits Reader
//
//  Created by Keegan on 10/21/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoadingManager : NSObject
@property(nonatomic) BOOL isBusyLoading;
- (void)displayLoadingScreenInView:(UIView *)view;
+ (LoadingManager *)sharedInstance;
- (void)removeCurrentLoadingScreen;
@end
