//
//  ArchiveYearsViewControllerTableViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "ArchiveYearsViewControllerTableViewController.h"
#import "ArchivePostsTableViewController.h"
#import "LoadingManager.h"
#import "ZenTableViewCell.h"

@interface ArchiveYearsViewControllerTableViewController ()

@end

@implementation ArchiveYearsViewControllerTableViewController

NSString *const ToArchivePostsSegue = @"fromArchiveYearsToArchivePosts";

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.view.backgroundColor = [UIColor whiteColor];
  NSError *error;
  [NSFetchedResultsController
      deleteCacheWithName:[[self fetchedResultsController] cacheName]];
  if (![[self fetchedResultsController] performFetch:&error]) {
    // TODO: Update to handle the error appropriately.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    exit(-1); // Fail
  }

  self.title = @"Archives";
  [self.tableView registerNib:[UINib nibWithNibName:@"ZenTableViewCell"
                                             bundle:nil]
       forCellReuseIdentifier:@"ZenTableViewCell"];
  self.tableView.tableFooterView = [UIView new];
  [self prepareTableHeaderWithText:@"All Zen Breath posts"];
  [AnalyticsManager reportNavigationToScreen:@"Archive Posts Years"];
}

- (void)viewWillAppear:(BOOL)animated {
  NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
  if (ip != nil) {
    [self.tableView deselectRowAtIndexPath:ip animated:animated];
  }
}

- (void)viewDidUnload {
  self.fetchedResultsController = nil;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:ToArchivePostsSegue]) {
    ArchivePostsTableViewController *postsViewController =
        segue.destinationViewController;
    postsViewController.currentYearString = self.selectedYearString;
    postsViewController.hidesBottomBarWhenPushed = YES;
  } else {
    NSLog(@"prepareForSegue: %@ unknown segue", segue.identifier);
  }
}

- (NSFetchedResultsController *)fetchedResultsController {

  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }

  NSManagedObjectContext *context =
      [[PersistenceManager sharedInstance] managedObjectContext];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Year"
                                            inManagedObjectContext:context];

  [fetchRequest setEntity:entity];

  NSSortDescriptor *sort =
      [[NSSortDescriptor alloc] initWithKey:@"theYear" ascending:NO];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

  [fetchRequest setFetchBatchSize:20];

  NSFetchedResultsController *theFetchedResultsController =
      [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                          managedObjectContext:context
                                            sectionNameKeyPath:nil
                                                     cacheName:@"Root"];
  self.fetchedResultsController = theFetchedResultsController;
  _fetchedResultsController.delegate =
      (id<NSFetchedResultsControllerDelegate>)self;

  return _fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (void)configureCell:(ZenTableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
  Year *year = [_fetchedResultsController objectAtIndexPath:indexPath];
  cell.titleLabel.text = year.theYear;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ZenTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"ZenTableViewCell"];

  [self configureCell:cell atIndexPath:indexPath];

  return cell;
}

#pragma mark - Other table view delegate methods

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if ([[LoadingManager sharedInstance] isBusyLoading]) {
    [[LoadingManager sharedInstance] displayLoadingScreenInView:self.view];
  }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([[LoadingManager sharedInstance] isBusyLoading]) {
    return;
  }
  ZenTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  self.selectedYearString = cell.titleLabel.text;
  [self performSegueWithIdentifier:ToArchivePostsSegue sender:self];
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

#pragma mark - FetchedResultsController delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  // The fetch controller is about to start sending change notifications, so
  // prepare the table view for updates.
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath {

  UITableView *tableView = self.tableView;

  switch (type) {

  case NSFetchedResultsChangeInsert:
    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    break;

  case NSFetchedResultsChangeDelete:
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    break;

  case NSFetchedResultsChangeUpdate:
    [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
            atIndexPath:indexPath];
    break;

  case NSFetchedResultsChangeMove:
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller
    didChangeSection:(id)sectionInfo
             atIndex:(NSUInteger)sectionIndex
       forChangeType:(NSFetchedResultsChangeType)type {

  switch (type) {

  case NSFetchedResultsChangeInsert:
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                  withRowAnimation:UITableViewRowAnimationFade];
    break;

  case NSFetchedResultsChangeDelete:
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                  withRowAnimation:UITableViewRowAnimationFade];
    break;

  default:
    break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  // The fetch controller has sent all current change notifications, so tell the
  // table view to process all updates.
  [self.tableView endUpdates];
}

@end
