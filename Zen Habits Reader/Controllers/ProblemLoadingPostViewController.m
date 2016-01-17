//
//  ProblemLoadingPostViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 12/11/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "ProblemLoadingPostViewController.h"

@interface ProblemLoadingPostViewController ()

@end

@implementation ProblemLoadingPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AnalyticsManager reportNavigationToScreen:@"Problem Loading Post"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
