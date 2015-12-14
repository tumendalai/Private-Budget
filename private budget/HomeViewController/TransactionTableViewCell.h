//
//  TransactionTableViewCell.h
//  private budget
//
//  Created by Enkhdulguun on 11/22/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTransaction.h"

@interface TransactionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *receiverLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView  *containerView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) DBTransaction *transaction;

@end
