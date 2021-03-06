//
//  BestPostsViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 11/9/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "BestPostsViewController.h"
#import "BestPostsLists.h"

@interface BestPostsViewController ()

@end

@implementation BestPostsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  NSError *error;

  if (![self.fetchedResultsController performFetch:&error]) {
    
    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    exit(-1);
  }

  self.tableView.tableFooterView = [UIView new];
  self.navigationItem.title = _currentYearString;
  [AnalyticsManager reportNavigationToScreen:@"Best Posts"];
}

- (NSFetchedResultsController *)createFetchedResultsController {
  NSManagedObjectContext *context =
      [PersistenceManager sharedInstance].managedObjectContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  NSEntityDescription *entity = [NSEntityDescription entityForName:@"PostHeader"
                                            inManagedObjectContext:context];
  fetchRequest.entity = entity;

  NSSortDescriptor *sort =
      [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
  fetchRequest.sortDescriptors = @[sort];

  fetchRequest.fetchBatchSize = 20;

  NSPredicate *predicate = [NSPredicate
      predicateWithFormat:[BestPostsLists predicateForYear:_currentYearString.integerValue]];
  fetchRequest.predicate = predicate;

  NSFetchedResultsController *theFetchedResultsController =
      [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                          managedObjectContext:context
                                            sectionNameKeyPath:nil
                                                     cacheName:nil];
  self.fetchedResultsController = theFetchedResultsController;
  theFetchedResultsController.delegate =
      (id<NSFetchedResultsControllerDelegate>)
          self;

  return theFetchedResultsController;
}

@end
