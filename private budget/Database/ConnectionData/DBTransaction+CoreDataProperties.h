//
//  DBTransaction+CoreDataProperties.h
//  private budget
//
//  Created by enkhdulguun on 12/13/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBTransaction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBTransaction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *is_income;
@property (nullable, nonatomic, retain) NSString *receiver;
@property (nullable, nonatomic, retain) NSString *transaction_description;
@property (nullable, nonatomic, retain) DBCategory *tran_category;
@property (nullable, nonatomic, retain) DBCurrency *tran_currency;

@end

NS_ASSUME_NONNULL_END
