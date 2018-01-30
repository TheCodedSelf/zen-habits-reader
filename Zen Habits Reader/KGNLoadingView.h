//
//  KGNLoadingView.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/29/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGNLoadingView : UIView

+ (KGNLoadingView *)createLoadingViewInView:(UIView *)view;

- (void)remove;

@end
