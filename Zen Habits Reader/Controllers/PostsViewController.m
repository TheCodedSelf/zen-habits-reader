//
//  PostsViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 10/26/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PostsViewController.h"
#import "LoadingManager.h"
#import "PostTableViewCell.h"
#import "PostWebViewController.h"

@interface PostsViewController ()

@end

@implementation PostsViewController {
  __strong NSMutableArray *_postsToMarkAsNotNew;
}
NSString *const CellIdentifier = @"PostTableViewCell";
NSString *const ToIndividualPostSegue = @"fromArchivePostsToIndividualPost";

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil]
       forCellReuseIdentifier:CellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if ([[LoadingManager sharedInstance] isBusyLoading]) {
    [[LoadingManager sharedInstance] displayLoadingScreenInView:self.view];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  if (_postsToMarkAsNotNew) {
    for (PostHeader *postHeader in _postsToMarkAsNotNew) {
      postHeader.isNew = [NSNumber numberWithBool:NO];
    }
    _postsToMarkAsNotNew = nil;
  }

  [[PersistenceManager sharedInstance] saveContext];
  [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:ToIndividualPostSegue]) {
    PostWebViewController *destinationPostWebViewController =
        segue.destinationViewController;
    destinationPostWebViewController.currentPostHeader =
        self.selectedPostHeader;
  } else {
    NSLog(@"prepareForSegue: %@ unknown segue", segue.identifier);
  }
}

#pragma mark - Table view data source

- (void)viewDidUnload {
  self.fetchedResultsController = nil;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (void)configureCell:(PostTableViewCell *)postCell
          atIndexPath:(NSIndexPath *)indexPath {
  PostHeader *postHeader =
      [_fetchedResultsController objectAtIndexPath:indexPath];
  postCell.postTitle.text = postHeader.title;
  postCell.postTitle.lineBreakMode = NSLineBreakByWordWrapping;
  postCell.postTitle.numberOfLines = 0;
  postCell.postStatusImage.hidden = YES;
  postCell.postTitle.enabled = YES;
  if ([postHeader.isRead boolValue] == YES) {
    postCell.postTitle.enabled = NO;
    postCell.postStatusImage.image = [UIImage imageNamed:@"green_tick"];
    postCell.postStatusImage.hidden = NO;
  } else if ([postHeader.isNew boolValue] == YES) {
    postCell.postStatusImage.image = [UIImage imageNamed:@"star"];
    postCell.postStatusImage.hidden = NO;

    if (!_postsToMarkAsNotNew) {
      _postsToMarkAsNotNew = [[NSMutableArray alloc] init];
    }
    [_postsToMarkAsNotNew addObject:postHeader];
  }
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PostTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  // Set up the cell...
  [self configureCell:cell atIndexPath:indexPath];

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ([[LoadingManager sharedInstance] isBusyLoading]) {
    return;
  }

  PostTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  self.selectedPostHeader = [[PersistenceManager sharedInstance]
      getPostHeaderWithTitle:cell.postTitle.text];
  [self performSegueWithIdentifier:ToIndividualPostSegue sender:self];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC),
                 dispatch_get_main_queue(), ^{
                   self.selectedPostHeader.isRead =
                       [NSNumber numberWithBool:YES];
                   self.selectedPostHeader.isNew = [NSNumber numberWithBool:NO];
                   [[PersistenceManager sharedInstance] saveContext];
                 });
}

- (NSFetchedResultsController *)createFetchedResultsController {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (NSFetchedResultsController *)fetchedResultsController {
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }

  return [self createFetchedResultsController];
}

#pragma mark - FetchedResultsController delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
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
  [self.tableView endUpdates];
}

@end
