//
//  DBPlannedTransaction+CoreDataProperties.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "DBPlannedTransaction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBPlannedTransaction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSNumber *day;
@property (nullable, nonatomic, retain) NSDate *end_date;
@property (nullable, nonatomic, retain) NSNumber *is_income;
@property (nullable, nonatomic, retain) NSString *receiver;
@property (nullable, nonatomic, retain) NSDate *start_date;
@property (nullable, nonatomic, retain) NSString *transaction_description;
@property (nullable, nonatomic, retain) DBCategory *ptran_category;
@property (nullable, nonatomic, retain) DBCurrency *ptran_currency;

@end

NS_ASSUME_NONNULL_END
