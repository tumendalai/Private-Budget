//
//  ProductCell.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//
#import "CategoryCell.h"

#define MY_SIZE     CGSizeMake(90, 80)

@interface CategoryCell()

@end

@implementation CategoryCell
@synthesize category;
@synthesize nameLabel;
@synthesize smallImageView;
@synthesize oneTapped;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = CLEAR_COLOR;
        [self addSubview:self.nameLabel];
        [self addSubview:self.smallImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.category) {
        if (self.category.image.length > 0)
            self.smallImageView.image = [UIImage imageNamed:self.category.image];
        self.nameLabel.text = self.category.name;
    }
}

#pragma mark -
#pragma mark UIActions

#pragma mark -
#pragma mark Getters
- (UILabel *)nameLabel {
    if (nameLabel == nil) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, MY_SIZE.width-20, 15)];
        nameLabel.backgroundColor = CLEAR_COLOR;
        nameLabel.textColor = BLACK_COLOR;
        nameLabel.font = FONT_NORMAL_SMALL;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumScaleFactor = 12.0f/[UIFont labelFontSize];
    }
    return nameLabel;
}
- (UIImageView *)smallImageView {
    if (smallImageView == nil) {
        smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, 50)];
        smallImageView.backgroundColor = CLEAR_COLOR;
    }
    return smallImageView;
}

@end
