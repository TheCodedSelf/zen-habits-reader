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
    
    if (![[self fetchedResultsController] performFetch:&error]) {
        // TODO: Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.title = _currentYearString;
    [AnalyticsManager reportNavigationToScreen:@"Best Posts"];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSFetchedResultsController*) createFetchedResultsController
{
    NSManagedObjectContext *context = [[PersistenceManager sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PostHeader" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[BestPostsLists predicateForYear: [_currentYearString integerValue]]];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    theFetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>)self; //TODO: What's with the warning? Also in ArchiveYears
    
    return theFetchedResultsController;
}

@end
