//
//  PostWebViewController.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/27/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PostHeader.h"
#import <UIKit/UIKit.h>
@import WebKit;

@interface PostWebViewController : UIViewController <WKNavigationDelegate>
@property(nonatomic) PostHeader *currentPostHeader;
@end
