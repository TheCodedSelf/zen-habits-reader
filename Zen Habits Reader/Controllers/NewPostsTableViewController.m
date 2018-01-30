//
//  NewPostsTableViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 10/26/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "NewPostsTableViewController.h"
#import "PostWebViewController.h"
#import "ProblemViewController.h"

@interface NewPostsTableViewController ()

@end

@implementation NewPostsTableViewController {
  IBOutlet UIView *_footerView;
  __strong UIView *_blankView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  NSError *error;

  if (![[self fetchedResultsController] performFetch:&error]) {
    // TODO: Update to handle the error appropriately.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    exit(-1);
  }

  if (self.fetchedResultsController.fetchedObjects.count < 1) {
    CGFloat height =
        self.tableView.bounds.size.height -
        [UIApplication sharedApplication].statusBarFrame.size.height;
    height = height - self.navigationController.navigationBar.frame.size.height;
    height = height - self.tabBarController.tabBar.bounds.size.height;

    ProblemViewController *pvc = [[ProblemViewController alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"ProblemViewController"
                                  owner:pvc
                                options:nil];
    pvc.view.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, height);

    self.tableView.tableFooterView = pvc.view;
    self.tableView.scrollEnabled = NO;
  } else {
    if (!_blankView) {
      _blankView = [UIView new];
    }
    self.tableView.tableFooterView = _blankView;
    self.tableView.scrollEnabled = YES;
  }

  [AnalyticsManager reportNavigationToScreen:@"New Posts"];
}

- (NSFetchedResultsController *)createFetchedResultsController {
  [[NSUserDefaults standardUserDefaults] synchronize];
  NSManagedObjectContext *context =
      [[PersistenceManager sharedInstance] managedObjectContext];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  NSEntityDescription *entity = [NSEntityDescription entityForName:@"PostHeader"
                                            inManagedObjectContext:context];
  [fetchRequest setEntity:entity];

  NSSortDescriptor *sort =
      [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

  // Fetch only twenty new posts
  [fetchRequest setFetchLimit:10];

  NSDate *checkDate = (NSDate *)[[NSUserDefaults standardUserDefaults]
      objectForKey:@"firstCheckDate"];
  if (!checkDate) {
    NSLog(@"No firstCheckDate!!");
    checkDate = [NSDate date]; // firstCheckDate is not set yet. Set it to now,
                               // so we fetch nothing.
  }

  NSPredicate *predicate = [NSPredicate
      predicateWithFormat:@"(isRead = NO) AND (date > %@)", checkDate];
  [fetchRequest setPredicate:predicate];

  NSFetchedResultsController *theFetchedResultsController =
      [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                          managedObjectContext:context
                                            sectionNameKeyPath:nil
                                                     cacheName:nil];
  self.fetchedResultsController = theFetchedResultsController;
  theFetchedResultsController.delegate =
      (id<NSFetchedResultsControllerDelegate>)self;

  return theFetchedResultsController;
}

@end
