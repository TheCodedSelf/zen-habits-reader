//
//  PostListCollectionViewCell.h
//  Zen Habits Reader
//
//  Created by Keegan on 11/23/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
