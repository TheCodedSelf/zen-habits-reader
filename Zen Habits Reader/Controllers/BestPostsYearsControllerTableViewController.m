//
//  BestPostsYearsControllerTableViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 11/10/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "BestPostsYearsControllerTableViewController.h"
#import "BestPostsLists.h"
#import "BestPostsViewController.h"
#import "LoadingManager.h"
#import "ZenTableViewCell.h"
#import "ZenTableViewHeader.h"

@interface BestPostsYearsControllerTableViewController ()

@end

@implementation BestPostsYearsControllerTableViewController {
  __strong NSString *_selectedYearString;
}

NSString *const ToBestPostsSegue = @"ToBestPostsSegue";
NSString *const ZenTableViewCellIdentifier = @"ZenTableViewCell";

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.view.backgroundColor = [UIColor whiteColor];
  [self.tableView registerNib:[UINib nibWithNibName:ZenTableViewCellIdentifier
                                             bundle:nil]
       forCellReuseIdentifier:ZenTableViewCellIdentifier];
  self.tableView.tableFooterView = [UIView new];
  [self prepareTableHeaderWithText:@"A curated list of the best posts to help "
                                   @"you reach your Zen potential"];
  [AnalyticsManager reportNavigationToScreen:@"Best Posts Years"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
  if (ip != nil) {
    [self.tableView deselectRowAtIndexPath:ip animated:animated];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  int yearBeforeFirstPostYear = 2006;
  return [BestPostsLists mostRecentPostYear] - yearBeforeFirstPostYear;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ZenTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:ZenTableViewCellIdentifier];
  cell.titleLabel.text =
      [NSString stringWithFormat:@"%ld", [BestPostsLists mostRecentPostYear] -
                                             indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([[LoadingManager sharedInstance] isBusyLoading]) {
    return;
  }
  ZenTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  _selectedYearString = cell.titleLabel.text;
  [self performSegueWithIdentifier:ToBestPostsSegue sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height = self.tableView.bounds.size.height -
                   [UIApplication sharedApplication].statusBarFrame.size.height;
  height = height - self.navigationController.navigationBar.frame.size.height;
  height = height - self.tabBarController.tabBar.bounds.size.height;
  height = height - self.tableView.tableHeaderView.frame.size.height;
  NSInteger count =
      [self tableView:tableView numberOfRowsInSection:indexPath.section];
  return height / count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:ToBestPostsSegue]) {
    BestPostsViewController *bestPostsViewController =
        segue.destinationViewController;
    bestPostsViewController.currentYearString = _selectedYearString;
    bestPostsViewController.hidesBottomBarWhenPushed = YES;
  } else {
    NSLog(@"prepareForSegue: %@ unknown segue", segue.identifier);
  }
}

@end
