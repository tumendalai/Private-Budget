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
@synthesize receiverLabel;
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
        [self.containerView addSubview:self.receiverLabel];
        [self.containerView addSubview:self.amountLabel];
        [self.containerView addSubview:self.descriptionLabel];
        [self.contentView addSubview:self.zuraasView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (indexPath.row % 2 != 0) {
//        self.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.7f];
    } else {
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    }
    
    if (self.transaction.is_income.boolValue) {
        self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, self.contentView.bounds.size.height);
        
    } else {
        self.containerView.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, self.contentView.bounds.size.height);
    }
//    self.dateLabel.text = [self.transaction.date descriptionWithLocale:[NSLocale new]];
    self.receiverLabel.text = self.transaction.receiver;
    self.amountLabel.text =[NSString stringWithFormat:@"%@%@",self.transaction.is_income.boolValue ? @"+":@"-",self.transaction.amount];
    self.descriptionLabel.text = self.transaction.transaction_description;
}

#pragma mark -
#pragma mark Getters
- (UILabel *)dateLabel {
    if (dateLabel == nil) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/2, 15)];
        dateLabel.backgroundColor = CLEAR_COLOR;
        dateLabel.textColor = BLACK_COLOR;
        dateLabel.font = FONT_NORMAL_SMALL;
    }
    return dateLabel;
}
- (UILabel *)receiverLabel {
    if (receiverLabel == nil) {
        receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, SCREEN_WIDTH/2, 15)];
        receiverLabel.backgroundColor = CLEAR_COLOR;
        receiverLabel.textColor = BLACK_COLOR;
        receiverLabel.font = FONT_NORMAL_SMALL;
    }
    return receiverLabel;
}
- (UILabel *)amountLabel {
    if (amountLabel == nil) {
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH/2, 15)];
        amountLabel.backgroundColor = CLEAR_COLOR;
        amountLabel.textColor = BLACK_COLOR;
        amountLabel.font = FONT_NORMAL_SMALL;
        amountLabel.numberOfLines = 2;
    }
    return amountLabel;
}
- (UILabel *)descriptionLabel {
    if (descriptionLabel == nil) {
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH/2, 15)];
        descriptionLabel.backgroundColor = CLEAR_COLOR;
        descriptionLabel.textColor = BLACK_COLOR;
        descriptionLabel.font = FONT_NORMAL_SMALL;
        descriptionLabel.numberOfLines = 2;
    }
    return descriptionLabel;
}

-(UIView*)zuraasView{
    if (zuraasView == nil) {
        zuraasView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 0.5, 60)];
        zuraasView.backgroundColor = BLACK_COLOR;
    }
    return zuraasView;
}

-(UIView*)containerView{
    if (containerView == nil) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, self.contentView.bounds.size.height)];
        containerView.backgroundColor = CLEAR_COLOR;
    }
    return containerView;
}


@end
