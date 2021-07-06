//
//  TransactionTableViewCell.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "TransactionTableViewCell.h"
#import "DBCategory.h"
#import "DBCurrency.h"

@interface TransactionTableViewCell()

@property (nonatomic, strong) UIView *zuraasView;
@property (nonatomic, strong) UIImageView *smallImageView;
@property (nonatomic, strong) UIImageView *plusMinusImageView;
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
@synthesize smallImageView;
@synthesize plusMinusImageView;

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
        [self.containerView addSubview:self.smallImageView];
        [self.containerView addSubview:self.plusMinusImageView];
        [self.contentView addSubview:self.zuraasView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (indexPath.row % 2 != 0) {
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    } else {
        self.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.01f];
    }
    if (self.transaction){
        if (self.transaction.is_income.boolValue) {
            self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, self.contentView.bounds.size.height);
            [self.plusMinusImageView setImage:[UIImage imageNamed:@"plus"]];
        } else {
            self.containerView.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, self.contentView.bounds.size.height);
            [self.plusMinusImageView setImage:[UIImage imageNamed:@"minus"]];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLocale *enUSLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale:enUSLocale];
        
        self.dateLabel.text = [formatter stringFromDate:self.transaction.date];
        self.receiverLabel.text = self.transaction.receiver;
        self.amountLabel.text =[NSString stringWithFormat:@"%@%@%@",self.transaction.is_income.boolValue ? @"+":@"-",self.transaction.amount,self.transaction.tran_currency.symbol];
        self.descriptionLabel.text = self.transaction.transaction_description;
        [self.smallImageView setImage:[UIImage imageNamed:self.transaction.tran_category.image]];
    }
}

#pragma mark -
#pragma mark Getters

- (UIImageView *)smallImageView {
    if (smallImageView == nil) {
        smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 40, 40)];
        smallImageView.backgroundColor = CLEAR_COLOR;
    }
    return smallImageView;
}

- (UIImageView *)plusMinusImageView {
    if (plusMinusImageView == nil) {
        plusMinusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 10, 10)];
        plusMinusImageView.backgroundColor = CLEAR_COLOR;
    }
    return plusMinusImageView;
}

- (UILabel *)dateLabel {
    if (dateLabel == nil) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 120, 15)];
        dateLabel.backgroundColor = CLEAR_COLOR;
        dateLabel.textColor = BLACK_COLOR;
        dateLabel.font = FONT_NORMAL_SMALLER;
    }
    return dateLabel;
}
- (UILabel *)receiverLabel {
    if (receiverLabel == nil) {
        receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 45, SCREEN_WIDTH/2, 15)];
        receiverLabel.backgroundColor = CLEAR_COLOR;
        receiverLabel.textColor = BLACK_COLOR;
        receiverLabel.font = FONT_NORMAL_SMALLER;
    }
    return receiverLabel;
}
- (UILabel *)amountLabel {
    if (amountLabel == nil) {
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 30, SCREEN_WIDTH/2, 15)];
        amountLabel.backgroundColor = CLEAR_COLOR;
        amountLabel.textColor = BLACK_COLOR;
        amountLabel.font = FONT_NORMAL_SMALLER;
        amountLabel.numberOfLines = 2;
    }
    return amountLabel;
}
- (UILabel *)descriptionLabel {
    if (descriptionLabel == nil) {
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 15, SCREEN_WIDTH/2, 15)];
        descriptionLabel.backgroundColor = CLEAR_COLOR;
        descriptionLabel.textColor = BLACK_COLOR;
        descriptionLabel.font = FONT_NORMAL_SMALLER;
        descriptionLabel.numberOfLines = 2;
    }
    return descriptionLabel;
}

-(UIView*)zuraasView{
    if (zuraasView == nil) {
        zuraasView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 1, 60)];
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
