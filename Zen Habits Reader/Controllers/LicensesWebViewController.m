//
//  LicensesWebViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 12/28/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "LicensesWebViewController.h"

@interface LicensesWebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation LicensesWebViewController

- (void)viewDidLoad
    {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSURL* licenseUrl = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"OpenSource" ofType:@"rtf"]];
     NSURLRequest *request = [NSURLRequest requestWithURL:licenseUrl];
     [self.webView loadRequest:request];
     [AnalyticsManager reportNavigationToScreen:@"Licenses Web View"];
    }


@end
