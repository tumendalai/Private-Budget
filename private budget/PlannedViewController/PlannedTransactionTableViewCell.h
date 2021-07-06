//
//  TransactionTableViewCell.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBPlannedTransaction.h"

@interface PlannedTransactionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *receiverLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *startDateLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) DBPlannedTransaction *transaction;

@end
