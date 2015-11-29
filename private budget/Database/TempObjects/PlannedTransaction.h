//
//  Transaction.h
//  private budget
//
//  Created by Enkhdulguun on 11/22/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlannedTransaction : NSObject

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *is_income;
@property (nonatomic, strong) NSString *category_id;
@property (nonatomic, strong) NSString *currency_id;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *itemid;
@property (nonatomic, strong) NSString *transaction_description;
@property (nonatomic, strong) NSString *reciever;
@property (nonatomic, strong) NSString *startDate;

@end
