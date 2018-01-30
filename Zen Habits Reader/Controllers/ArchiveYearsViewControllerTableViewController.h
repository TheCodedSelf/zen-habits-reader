//
//  ArchiveYearsViewControllerTableViewController.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PersistenceManager.h"
#import "Year.h"
#import "ZenHabitsTableViewController.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface ArchiveYearsViewControllerTableViewController
    : ZenHabitsTableViewController

@property(nonatomic, retain)
    NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSString *selectedYearString;
@end
