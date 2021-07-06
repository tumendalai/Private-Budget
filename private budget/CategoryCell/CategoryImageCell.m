//
//  ProductCell.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "CategoryImageCell.h"

@interface CategoryImageCell()

@end

@implementation CategoryImageCell
@synthesize smallImageView;
@synthesize oneTapped;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = CLEAR_COLOR;
        [self addSubview:self.smallImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.image) {
        if (self.image.length > 0)
            self.smallImageView.image = [UIImage imageNamed:self.image];
    }
}

#pragma mark -
#pragma mark UIActions

#pragma mark -
#pragma mark Getters
- (UIImageView *)smallImageView {
    if (smallImageView == nil) {
        smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        smallImageView.backgroundColor = CLEAR_COLOR;
    }
    return smallImageView;
}

@end
