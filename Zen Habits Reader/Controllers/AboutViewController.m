//
//  AboutViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 12/9/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "AboutViewController.h"
#import "InAppPurchasesManager.h"
#import "KGNUtilities.h"

@interface AboutViewController ()

@end

typedef NS_ENUM(NSInteger, AboutTableRows) {
  Upgrade = 0,
  Restore = 1,
  Feedback = 0,
  Rate = 1,
  Licenses = 0
};

typedef NS_ENUM(NSInteger, AboutTableSections) { Purchases, ContactUs, Other };

@implementation AboutViewController

NSString *const ToLicensesSegueIdentifier = @"AboutToLicensesSegue";

- (void)viewDidLoad {
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
  self.navigationController.navigationBar.barTintColor =
      [KGNUtilities primaryColor];
  (self.navigationController.navigationBar).titleTextAttributes = @{
    NSForegroundColorAttributeName : [UIColor whiteColor]
  };

  [[NSBundle mainBundle] loadNibNamed:@"AboutHeaderView"
                                owner:self
                              options:nil];
  [[NSBundle mainBundle] loadNibNamed:@"AboutFooterView"
                                owner:self
                              options:nil];
  self.tableView.tableHeaderView = self.headerView;
  self.tableView.tableFooterView = self.footerView;

  CGFloat width = self.tableView.tableFooterView.bounds.size.width;
  CGFloat height = self.tableView.contentSize.height;
  height =
      height + [UIApplication sharedApplication].statusBarFrame.size.height;

  height = height + self.tabBarController.tabBar.bounds.size.height;
  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
  self.tableView.tableFooterView.bounds =
      CGRectMake(0, 0, width, screenHeight - height);
  CGRect frame = self.tableView.tableFooterView.frame;
  CGRect bounds = self.tableView.tableFooterView.bounds;
  self.tableView.tableFooterView.frame = CGRectMake(
      frame.origin.x, frame.origin.y, bounds.size.width, bounds.size.height);
  [AnalyticsManager reportNavigationToScreen:@"About"];
}

#pragma mark - table view row selection

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  // TODO analytics
  switch (indexPath.section) {
  case Purchases: {
    switch (indexPath.row) {
    case Upgrade:
      [self promptToUpgrade];
      break;
    case Restore:
      [self promptToRestore];
      break;
    }
  } break;
  case ContactUs: {
    switch (indexPath.row) {
    case Feedback:
      [self prepareFeedbackMail];
      break;
    case Rate:
      [self rateInStore];
      break;
    default:
      break;
    }
  }
  case Other: {
    switch (indexPath.row) {
    case Licenses:
      [self presentLicensing];
      break;
    default:
      break;
    }
  } break;
  default:
    break;
  }
}

#pragma mark - Licensing

- (void)promptToUpgrade {
  [[InAppPurchasesManager sharedInstance]
      presentPurchaseDialogInViewController:self];
}

- (void)promptToRestore {
  [[InAppPurchasesManager sharedInstance] restoreCompletedTransactions];
}

#pragma mark - Contact Us

- (void)prepareFeedbackMail {
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailCont =
        [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;

    [mailCont setSubject:[NSString stringWithFormat:@"Zen Breath Feedback %@",
                                                    [NSDate date]]];
    [mailCont
        setToRecipients:@[@"galaxyplansoftware@gmail.com"]];
    [mailCont setMessageBody:@"" isHTML:NO];

    [self presentViewController:mailCont animated:YES completion:nil];
  }
}

- (void)rateInStore {
  [AnalyticsManager reportRateInAppStoreClicked];
}

#pragma mark - Other

- (void)presentLicensing {
  [self performSegueWithIdentifier:ToLicensesSegueIdentifier sender:self];
}

#pragma mark - Delegates

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
