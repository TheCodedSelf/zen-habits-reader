//
//  PostTypeTableViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 12/7/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PostTypeTableViewController.h"
#import "CustomBadge.h"
#import "InAppPurchasesManager.h"
#import "KGNUtilities.h"
#import "PersistenceManager.h"
#import "ZenTableViewCell.h"

@interface PostTypeTableViewController ()

@end

@implementation PostTypeTableViewController
NSString *const NewPosts = @"New Posts";
NSString *const StartersGuide = @"Starter's Guide";
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self allCellsArray].count;
}

- (void)viewDidLoad {
  // To set the status bar color. See Tyson's answer at
  // http://stackoverflow.com/questions/19022210/preferredstatusbarstyle-isnt-called/19513714#19513714
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

  self.navigationItem.title = @"Zen Breath";
  UIBarButtonItem *backButton =
      [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                       style:UIBarButtonItemStylePlain
                                      target:nil
                                      action:nil];

  (self.navigationItem).backBarButtonItem = backButton;
  [self.tableView setScrollEnabled:NO];
  self.navigationController.navigationBar.barTintColor =
      [KGNUtilities primaryColor];
  (self.navigationController.navigationBar).titleTextAttributes = @{
    NSForegroundColorAttributeName : [UIColor whiteColor]
  };

  self.tabBarController.tabBar.barTintColor = [KGNUtilities primaryColor];

  [self.tableView registerNib:[UINib nibWithNibName:@"ZenTableViewCell"
                                             bundle:nil]
       forCellReuseIdentifier:@"ZenTableViewCell"];

  [[InAppPurchasesManager sharedInstance] initialiseInViewController:self];
  [AnalyticsManager performInitialSetup];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height = self.tableView.bounds.size.height -
                   [UIApplication sharedApplication].statusBarFrame.size.height;
  height = height - self.navigationController.navigationBar.frame.size.height;
  height = height - self.tabBarController.tabBar.bounds.size.height;
  return height / [self allCellsDictionary].count;
}

- (NSDictionary *)allCellsDictionary {
  static NSDictionary *cells;
  if (!cells) {
    cells = @{@"Best Posts": @"PostTypesToBestPosts", NewPosts: @"PostTypesToNewPosts", StartersGuide: @"PostTypesToStartersGuide", @"Archives": @"PostTypesToArchivePosts"};
  }
  return cells;
}

- (NSArray *)allCellsArray {
  static NSArray *cells;
  if (!cells) {
    cells = @[ StartersGuide, NewPosts, @"Best Posts", @"Archives" ];
  }
  return cells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static CustomBadge *newPostsBadge;
  ZenTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"ZenTableViewCell"
                                      forIndexPath:indexPath];
  NSString *theText = [self allCellsArray][indexPath.row];
  cell.titleLabel.text = theText;
  [cell.titleLabel sizeToFit];
  if ([theText isEqualToString:NewPosts]) {

    NSArray *newPosts = [[PersistenceManager sharedInstance] allNewPostHeaders];
    if (newPosts.count > 0) {
      // There are new posts
      if (newPostsBadge == nil) {
        newPostsBadge = [CustomBadge
            customBadgeWithString:[NSString
                                      stringWithFormat:@"%lu",
                                                       (unsigned long)
                                                           newPosts.count]];

        CGRect rect = cell.titleLabel.frame;
        CGPoint topLeftPoint =
            CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
        CGSize buttonSize = CGSizeMake(newPostsBadge.frame.size.width,
                                       newPostsBadge.frame.size.height);
        CGRect badgeRect = CGRectMake(topLeftPoint.x, topLeftPoint.y,
                                      buttonSize.width, buttonSize.height);
        newPostsBadge.frame = badgeRect;
        [cell addSubview:newPostsBadge];
      } else {
        newPostsBadge.badgeText =
            [NSString stringWithFormat:@"%lu", (unsigned long)newPosts.count];
      }
    } else {
      if (newPostsBadge != nil) {
        newPostsBadge.hidden = YES;
      }
    }
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  ZenTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

  if ([cell.titleLabel.text isEqualToString:StartersGuide] == false) {
    if ([[InAppPurchasesManager sharedInstance] allPostsAreAvailable] ==
        false) {
      //            [[InAppPurchasesManager sharedInstance]
      //            presentPurchaseDialogInViewController:self];
      //            return;
    }
  }
  [self
      performSegueWithIdentifier:[self allCellsDictionary][cell.titleLabel.text]
                          sender:self];
}

@end
