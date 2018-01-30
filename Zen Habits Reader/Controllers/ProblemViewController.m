//
//  ProblemViewController.m
//  Zen Habits Reader
//
//  Created by Keegan on 10/1/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "ProblemViewController.h"

@interface ProblemViewController ()
@property(weak, nonatomic) IBOutlet UILabel *problemHeaderLabel;
@property(weak, nonatomic) IBOutlet UILabel *problemSubheaderLabel;

@end

@implementation ProblemViewController {
  __strong NSString *_headerText;
  __strong NSString *_subText;
}
- (void)configureWithHeader:(NSString *)header
               andSubheader:(NSString *)subheader {
  _headerText = header;
  _subText = subheader;
}

- (void)viewDidLoad {
  NSMutableArray *navigationArray = [[NSMutableArray alloc]
      initWithArray:self.navigationController.viewControllers];

  [navigationArray removeObjectAtIndex:[navigationArray count] - 2];
  self.navigationController.viewControllers = navigationArray;
  self.problemHeaderLabel.text = _headerText;
  self.problemSubheaderLabel.text = _subText;

  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [AnalyticsManager reportNavigationToScreen:@"Problem"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
