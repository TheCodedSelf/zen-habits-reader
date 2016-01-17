//
//  AboutViewController.h
//  Zen Habits Reader
//
//  Created by Keegan on 12/9/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController : UITableViewController <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@end
