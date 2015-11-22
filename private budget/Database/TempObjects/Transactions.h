//
//  Transaction.h
//  private budget
//
//  Created by Enkhdulguun on 11/22/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transactions : NSObject

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *category_id;
@property (nonatomic, strong) NSNumber *currency_id;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *itemid;
@property (nonatomic, strong) NSString *reciever;
@property (nonatomic, strong) NSString *transaction_description;
@property (nonatomic, strong) NSNumber *is_income;

@end
