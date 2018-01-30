//
//  ZenHabitsTableViewController.h
//  Zen Habits Reader
//
//  Created by Keegan on 12/20/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "ZenTableViewHeader.h"
#import <UIKit/UIKit.h>
@interface ZenHabitsTableViewController : UITableViewController
@property(strong, nonatomic) IBOutlet ZenTableViewHeader *headerView;
- (void)prepareTableHeaderWithText:(NSString *)headerText;
@end
