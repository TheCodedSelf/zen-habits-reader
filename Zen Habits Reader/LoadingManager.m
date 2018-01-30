//
//  LoadingManager.m
//  Zen Habits Reader
//
//  Created by Keegan on 10/21/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "LoadingManager.h"
#import "KGNLoadingView.h"
@interface LoadingManager () {
  __strong KGNLoadingView *_loadingView;
  __weak UIView *_currentView;
}
@end

@implementation LoadingManager

+ (LoadingManager *)sharedInstance {
  static LoadingManager *sharedInstance;
  if (sharedInstance == nil) {
    sharedInstance = [[LoadingManager alloc] init];
  }

  return sharedInstance;
}

- (void)displayLoadingScreenInView:(UIView *)view {
  if (_currentView) {
    [self removeCurrentLoadingScreen];
  }
  _loadingView = [KGNLoadingView createLoadingViewInView:view];
  _currentView = view;
}

- (void)removeCurrentLoadingScreen {
  if (_loadingView) {
    [_loadingView remove];
    _loadingView = nil;
  }
  _currentView = nil;
}
@end
