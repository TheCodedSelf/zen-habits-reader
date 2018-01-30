//
//  PostsViewController.h
//  Zen Habits Reader
//
//  Created by Keegan on 10/26/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PersistenceManager.h"
#import "PostHeader.h"
#import "ZenHabitsTableViewController.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface PostsViewController : ZenHabitsTableViewController
@property(nonatomic) PostHeader *selectedPostHeader;
@property(nonatomic, retain)
    NSFetchedResultsController<PostHeader *> *fetchedResultsController;

- (NSFetchedResultsController<PostHeader *> *)createFetchedResultsController;

extern NSString *const ToIndividualPostSegue;

@end
