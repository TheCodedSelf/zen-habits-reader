//
//  PostListCollectionViewCell.m
//  Zen Habits Reader
//
//  Created by Keegan on 11/23/15.
//  Copyright © 2015 Keegan. All rights reserved.
//

#import "PostListCollectionViewCell.h"

@implementation PostListCollectionViewCell

- (void)awakeFromNib {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)layoutSubviews
    {
        self.contentView.frame = self.bounds;
        [super layoutSubviews];
    }

@end
