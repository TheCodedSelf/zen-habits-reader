//
//  ZenHabitsTableViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 12/20/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "ZenHabitsTableViewController.h"

@interface ZenHabitsTableViewController ()

@end

@implementation ZenHabitsTableViewController

- (void)prepareTableHeaderWithText:(NSString *)headerText {
  [[NSBundle mainBundle] loadNibNamed:@"ZenTableViewHeader"
                                owner:self
                              options:nil];
  self.headerView.title.text = headerText;
  self.tableView.tableHeaderView = self.headerView;
}
@end
