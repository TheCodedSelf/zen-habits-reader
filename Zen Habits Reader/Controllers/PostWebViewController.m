//
//  PostWebViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 9/27/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PostWebViewController.h"
#import "PostLoader.h"
#import "KGNConcurrencyManager.h"
#import "Month+CoreDataProperties.h"
#import "Year+CoreDataProperties.h"
#import "LoadingManager.h"
#import "ProblemViewController.h"

@interface PostWebViewController ()

@property (strong, nonatomic) WKWebView *postWebView;

@end

@implementation PostWebViewController
NSString* const PostToProblemSegue = @"PostToProblemSegue";

- (void)loadView {
//UIView* masterView = [[UIView alloc] initWithFrame:[[App]]]
    self.postWebView = [[WKWebView alloc]init];
    self.view = self.postWebView;
    [self addToolbar];
    self.postWebView.navigationDelegate = self;
    
}

-(void)addToolbar
{
return;
//    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]
//                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                  target:nil action:nil];
//    UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc]
//                                    initWithTitle:@"Tool1" style:UIBarButtonItemStylePlain
//                                    target:self action:@selector(toolBarItem1:)];
//    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]
//                                    initWithTitle:@"Tool2" style:UIBarButtonItemStylePlain
//                                    target:self action:@selector(toolBarItem2:)];
//    NSArray *toolbarItems = [NSArray arrayWithObjects:
//                             customItem1,spaceItem, customItem2, nil];
//    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:
//                          CGRectMake(0, 366+54, 320, 50)];
//    
//    //[toolbar setBarStyle:UIBarStyleBlackOpaque];
//    [self.view addSubview:toolbar];
//    [toolbar setItems:toolbarItems];
//    
//    [toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view addSubview:toolbar];
//    
//    NSDictionary *viewArranging = NSDictionaryOfVariableBindings(toolbar);
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolbar(0)]-0-|"
//                                                                 options:0
//                                                                 metrics:0
//                                                                   views:viewArranging]];
//
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-149-[toolbar(0)]-149-|"
//                                                                 options:0
//                                                                 metrics:0
//                                                                 views:viewArranging]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

        self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", self.currentPostHeader.month.monthOfYear, self.currentPostHeader.month.year.theYear]
                                         style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];
    
    [[LoadingManager sharedInstance] displayLoadingScreenInView:self.view];
    NSInvocationOperation* loadOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadPost) object:nil];

    [[[KGNConcurrencyManager sharedInstance] backgroundOperationQueue] addOperation:loadOperation];
    [AnalyticsManager reportNavigationToScreen:@"Post Web"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPost
    {
    NSString *htmlString = [PostLoader getPostBodyHTMLFromPostUrl:self.currentPostHeader.url andTitle: self.currentPostHeader.title];
    [AnalyticsManager reportPostReadWithTitle:self.currentPostHeader.title];
    
    if (htmlString)
        {
        [self.postWebView loadHTMLString:htmlString baseURL:nil];
        }
    else
        {
        dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:PostToProblemSegue sender:self];});
        }
    }

#pragma mark - WKWebView delegate methods

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
    {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated)
        {
        [[UIApplication sharedApplication] openURL:[navigationAction.request URL]];
        decisionHandler(WKNavigationActionPolicyCancel);
        }
    else
        {
        decisionHandler(WKNavigationActionPolicyAllow);
        }
    }

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
    {
    [[LoadingManager sharedInstance] removeCurrentLoadingScreen];
    }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
    if ([segue.identifier isEqualToString:PostToProblemSegue])
        {
        ProblemViewController* pvc = segue.destinationViewController;
        [pvc configureWithHeader:@"Problem Loading Post" andSubheader:@"Are you connected to the internet?"];
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                self.currentPostHeader.isRead = [NSNumber numberWithBool:NO];
                [[PersistenceManager sharedInstance] saveContext];
            });
        [[PersistenceManager sharedInstance] saveContext];
        }
    }

@end
