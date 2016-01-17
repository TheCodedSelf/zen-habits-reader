//
//  KGNLoadingView.m
//  Zen Habits Reader
//
//  Created by Keegan on 9/29/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "KGNLoadingView.h"
@interface KGNLoadingView()
@property (nonatomic, weak) UIView *parentView;
@end

@implementation KGNLoadingView

+ (KGNLoadingView*) createLoadingViewInView: (UIView *)view
    {
    UIActivityIndicatorView* activityView;
    UILabel* loadingLabel;
    KGNLoadingView* kgnLoadingView = [[KGNLoadingView alloc]init];
    
    kgnLoadingView = [[KGNLoadingView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    kgnLoadingView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin   |
                                        UIViewAutoresizingFlexibleRightMargin  |
                                        UIViewAutoresizingFlexibleTopMargin    |
                                        UIViewAutoresizingFlexibleBottomMargin);
    kgnLoadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    kgnLoadingView.clipsToBounds = YES;
    kgnLoadingView.layer.cornerRadius = 10.0;
    
    kgnLoadingView.center = [view convertPoint:view.center fromView:view.superview];
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(65, 40, activityView.bounds.size.width, activityView.bounds.size.height);
    [kgnLoadingView addSubview:activityView];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"Loading...";
    [kgnLoadingView addSubview:loadingLabel];
    [view addSubview:kgnLoadingView];
    
    [activityView startAnimating];
    return kgnLoadingView;
}

- (void) remove
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }

@end
