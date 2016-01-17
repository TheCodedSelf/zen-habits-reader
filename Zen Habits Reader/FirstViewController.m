//
//  FirstViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 9/20/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "FirstViewController.h"
#import "PersistenceManager.h"
@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UILabel *checks;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{//TODO: remove
    _checks.text = [NSString stringWithFormat:@"%d", [[PersistenceManager sharedInstance] backgroundChecks]];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
