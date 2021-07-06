//
//  TransactionTableViewCell.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "PlannedTransactionTableViewCell.h"
#import "DBCategory.h"
#import "DBCurrency.h"

@interface PlannedTransactionTableViewCell()
@property (nonatomic, strong) UIImageView *smallImageView;
@property (nonatomic, strong) UIImageView *plusMinusImageView;

@end

@implementation PlannedTransactionTableViewCell

@synthesize dateLabel;
@synthesize amountLabel;
@synthesize receiverLabel;
@synthesize descriptionLabel;
@synthesize startDateLabel;
@synthesize indexPath;
@synthesize transaction;
@synthesize smallImageView;
@synthesize plusMinusImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.receiverLabel];
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.descriptionLabel];
        [self.contentView addSubview:self.startDateLabel];
        [self.contentView addSubview:self.smallImageView];
        [self.contentView addSubview:self.plusMinusImageView];
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
        self.dateLabel.text = [NSString stringWithFormat:@"Сар бүрийн %@",self.transaction.day];
        self.receiverLabel.text = self.transaction.receiver;
        self.amountLabel.text = [NSString stringWithFormat:@"%@%@%@",self.transaction.is_income.boolValue ? @"+":@"-",self.transaction.amount, self.transaction.ptran_currency.symbol];
        
        if (self.transaction.is_income.boolValue) {
            [self.plusMinusImageView setImage:[UIImage imageNamed:@"plus"]];
        } else {
            [self.plusMinusImageView setImage:[UIImage imageNamed:@"minus"]];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy:MM:dd"];
        NSLocale *enUSLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale:enUSLocale];
        
        self.descriptionLabel.text = self.transaction.transaction_description;
        self.startDateLabel.text = [NSString stringWithFormat:@"%@ - %@",[formatter stringFromDate:self.transaction.start_date],[formatter stringFromDate:self.transaction.end_date]];
        [self.smallImageView setImage:[UIImage imageNamed:self.transaction.ptran_category.image]];
    }
}

#pragma mark -
#pragma mark Getters
- (UILabel *)descriptionLabel {
    if (descriptionLabel == nil) {
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, self.contentView.bounds.size.width/2, 15)];
        descriptionLabel.backgroundColor = CLEAR_COLOR;
        descriptionLabel.textColor = BLACK_COLOR;
        descriptionLabel.font = FONT_NORMAL_SMALLER;
        descriptionLabel.numberOfLines = 2;
    }
    return descriptionLabel;
}
- (UILabel *)dateLabel {
    if (dateLabel == nil) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 15, self.contentView.bounds.size.width/2, 15)];
        dateLabel.backgroundColor = CLEAR_COLOR;
        dateLabel.textColor = BLACK_COLOR;
        dateLabel.font = FONT_NORMAL_SMALLER;
    }
    return dateLabel;
}
- (UILabel *)amountLabel {
    if (amountLabel == nil) {
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, self.contentView.bounds.size.width/2, 15)];
        amountLabel.backgroundColor = CLEAR_COLOR;
        amountLabel.textColor = BLACK_COLOR;
        amountLabel.font = FONT_NORMAL_SMALLER;
    }
    return amountLabel;
}

- (UIImageView *)smallImageView {
    if (smallImageView == nil) {
        smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 40, 40)];
        smallImageView.backgroundColor = CLEAR_COLOR;
    }
    return smallImageView;
}

- (UIImageView *)plusMinusImageView {
    if (plusMinusImageView == nil) {
        plusMinusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 10, 10)];
        plusMinusImageView.backgroundColor = CLEAR_COLOR;
    }
    return plusMinusImageView;
}


- (UILabel *)startDateLabel {
    if (startDateLabel == nil) {
        startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, self.contentView.bounds.size.width/2, 15)];
        startDateLabel.backgroundColor = CLEAR_COLOR;
        startDateLabel.textColor = BLACK_COLOR;
        startDateLabel.font = FONT_NORMAL_SMALLER;
    }
    return startDateLabel;
}

- (UILabel *)receiverLabel {
    if (receiverLabel == nil) {
        receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 45, self.contentView.bounds.size.width/2, 15)];
        receiverLabel.backgroundColor = CLEAR_COLOR;
        receiverLabel.textColor = BLACK_COLOR;
        receiverLabel.font = FONT_NORMAL_SMALLER;
    }
    return receiverLabel;
}




@end
