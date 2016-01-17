//
//  ArchivePostsTableViewController.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsViewController.h"

@interface ArchivePostsTableViewController : PostsViewController


@property (nonatomic, strong) NSString *currentYearString;
@property (nonatomic, strong) NSString *currentMonthString;
//@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
