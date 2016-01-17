//
//  PostsViewController.h
//  Zen Habits Reader
//
//  Created by Keegan on 10/26/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PostHeader.h"
#import "PersistenceManager.h"
#import "ZenHabitsTableViewController.h"

@interface PostsViewController : ZenHabitsTableViewController
@property (nonatomic) PostHeader *selectedPostHeader;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (NSFetchedResultsController*) createFetchedResultsController;

extern NSString *const ToIndividualPostSegue;

@end
