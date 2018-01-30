//
//  PostTableViewCell.h
//  Zen Habits Reader
//
//  Created by Keegan on 10/27/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell
@property(strong, nonatomic) IBOutlet UILabel *postTitle;
@property(strong, nonatomic) IBOutlet UIImageView *postStatusImage;
@end
