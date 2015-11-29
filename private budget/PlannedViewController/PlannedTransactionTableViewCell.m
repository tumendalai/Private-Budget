//
//  TransactionTableViewCell.m
//  private budget
//
//  Created by Enkhdulguun on 11/22/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "PlannedTransactionTableViewCell.h"

@interface PlannedTransactionTableViewCell()

@end

@implementation PlannedTransactionTableViewCell


@synthesize dateLabel;
@synthesize amountLabel;
@synthesize receiverLabel;
@synthesize descriptionLabel;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize indexPath;
@synthesize transaction;

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
        [self.contentView addSubview:self.endDateLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    if (indexPath.row % 2 != 0) {
//        self.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.7f];
//    } else {
//        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
//    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"Сар бүрийн %@",self.transaction.date];
    self.receiverLabel.text = self.transaction.reciever;
    self.amountLabel.text = [NSString stringWithFormat:@"%@%@",self.transaction.is_income.boolValue ? @"+":@"-",self.transaction.amount];
    self.descriptionLabel.text = self.transaction.transaction_description;
    self.startDateLabel.text = self.transaction.startDate;
    self.endDateLabel.text = self.transaction.endDate;
    
}

#pragma mark -
#pragma mark Getters
- (UILabel *)descriptionLabel {
    if (descriptionLabel == nil) {
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.contentView.bounds.size.width/2, 15)];
        descriptionLabel.backgroundColor = CLEAR_COLOR;
        descriptionLabel.textColor = BLACK_COLOR;
        descriptionLabel.font = FONT_NORMAL_SMALL;
        descriptionLabel.numberOfLines = 2;
    }
    return descriptionLabel;
}
- (UILabel *)dateLabel {
    if (dateLabel == nil) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 + self.contentView.bounds.size.width/2, 0, self.contentView.bounds.size.width/2, 15)];
        dateLabel.backgroundColor = CLEAR_COLOR;
        dateLabel.textColor = BLACK_COLOR;
        dateLabel.font = FONT_NORMAL_SMALL;
    }
    return dateLabel;
}
- (UILabel *)amountLabel {
    if (amountLabel == nil) {
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, self.contentView.bounds.size.width/2, 15)];
        amountLabel.backgroundColor = CLEAR_COLOR;
        amountLabel.textColor = BLACK_COLOR;
        amountLabel.font = FONT_NORMAL_SMALL;
    }
    return amountLabel;
}


- (UILabel *)startDateLabel {
    if (startDateLabel == nil) {
        startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.contentView.bounds.size.width/2, 15)];
        startDateLabel.backgroundColor = CLEAR_COLOR;
        startDateLabel.textColor = BLACK_COLOR;
        startDateLabel.font = FONT_NORMAL_SMALL;
    }
    return startDateLabel;
}

- (UILabel *)endDateLabel {
    if (endDateLabel == nil) {
        endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 + self.contentView.bounds.size.width/2, 30, self.contentView.bounds.size.width/2, 15)];
        endDateLabel.backgroundColor = CLEAR_COLOR;
        endDateLabel.textColor = BLACK_COLOR;
        endDateLabel.font = FONT_NORMAL_SMALL;
    }
    return endDateLabel;
}

- (UILabel *)receiverLabel {
    if (receiverLabel == nil) {
        receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, self.contentView.bounds.size.width/2, 15)];
        receiverLabel.backgroundColor = CLEAR_COLOR;
        receiverLabel.textColor = BLACK_COLOR;
        receiverLabel.font = FONT_NORMAL_SMALL;
    }
    return receiverLabel;
}




@end
