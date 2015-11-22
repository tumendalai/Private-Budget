//
//  TransactionTableViewCell.m
//  private budget
//
//  Created by Enkhdulguun on 11/22/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "TransactionTableViewCell.h"

@interface TransactionTableViewCell()

@property (nonatomic, strong) UIView *zuraasView;

@end

@implementation TransactionTableViewCell


@synthesize dateLabel;
@synthesize amountLabel;
@synthesize nameLabel;
@synthesize descriptionLabel;
@synthesize indexPath;
@synthesize transaction;
@synthesize zuraasView;
@synthesize containerView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.dateLabel];
        [self.containerView addSubview:self.nameLabel];
        [self.containerView addSubview:self.amountLabel];
        [self.containerView addSubview:self.descriptionLabel];
        [self.containerView addSubview:self.zuraasView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (indexPath.row % 2 != 0) {
        self.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.7f];
    } else {
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    }
    
    if (self.transaction.is_income) {
        self.containerView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width/2, self.contentView.bounds.size.height);
    } else {
        self.containerView.frame = CGRectMake(self.contentView.bounds.size.width/2, 0, self.contentView.bounds.size.width/2, self.contentView.bounds.size.height);
    }
    
}

#pragma mark -
#pragma mark Getters
- (UILabel *)dateLabel {
    if (dateLabel == nil) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.containerView.bounds.size.width/2, 20)];
        dateLabel.backgroundColor = CLEAR_COLOR;
        dateLabel.textColor = BLACK_COLOR;
        dateLabel.font = FONT_NORMAL_SMALL;
        dateLabel.lineBreakMode = NSLineBreakByClipping;
    }
    return dateLabel;
}
- (UILabel *)nameLabel {
    if (nameLabel == nil) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, self.containerView.bounds.size.width/2, 20)];
        nameLabel.backgroundColor = CLEAR_COLOR;
        nameLabel.textColor = BLACK_COLOR;
        nameLabel.font = FONT_NORMAL_SMALL;
    }
    return nameLabel;
}
- (UILabel *)amountLabel {
    if (amountLabel == nil) {
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, self.containerView.bounds.size.width/2, 20)];
        amountLabel.backgroundColor = CLEAR_COLOR;
        amountLabel.textColor = BLACK_COLOR;
        amountLabel.font = FONT_NORMAL_SMALL;
        amountLabel.numberOfLines = 2;
    }
    return amountLabel;
}
- (UILabel *)descriptionLabel {
    if (descriptionLabel == nil) {
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, self.containerView.bounds.size.width/2, 20)];
        descriptionLabel.backgroundColor = CLEAR_COLOR;
        descriptionLabel.textColor = BLACK_COLOR;
        descriptionLabel.font = FONT_NORMAL_SMALL;
        descriptionLabel.numberOfLines = 2;
    }
    return descriptionLabel;
}

-(UIView*)zuraasView{
    if (zuraasView == nil) {
        zuraasView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width/2-1, 0, 2, self.contentView.bounds.size.height)];
        zuraasView.backgroundColor = BLACK_COLOR;
    }
    return zuraasView;
}

-(UIView*)containerView{
    if (containerView == nil) {
        containerView = [[UIView alloc] initWithFrame:CGRectZero];
        containerView.backgroundColor = CLEAR_COLOR;
    }
    return containerView;
}


@end
