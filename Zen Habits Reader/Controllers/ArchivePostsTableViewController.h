//
//  ArchivePostsTableViewController.h
//  Zen Habits Reader
//
//  Created by Keegan on 9/24/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PostsViewController.h"
#import <UIKit/UIKit.h>

@interface ArchivePostsTableViewController : PostsViewController

@property(nonatomic, strong) NSString *currentYearString;
@property(nonatomic, strong) NSString *currentMonthString;

@end
