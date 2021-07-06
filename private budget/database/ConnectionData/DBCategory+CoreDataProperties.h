//
//  DBCategory+CoreDataProperties.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//
#import "DBCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSNumber *income;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<DBPlannedTransaction *> *planned_transaction;
@property (nullable, nonatomic, retain) NSSet<DBTransaction *> *transaction;

@end

@interface DBCategory (CoreDataGeneratedAccessors)

- (void)addPlanned_transactionObject:(DBPlannedTransaction *)value;
- (void)removePlanned_transactionObject:(DBPlannedTransaction *)value;
- (void)addPlanned_transaction:(NSSet<DBPlannedTransaction *> *)values;
- (void)removePlanned_transaction:(NSSet<DBPlannedTransaction *> *)values;

- (void)addTransactionObject:(DBTransaction *)value;
- (void)removeTransactionObject:(DBTransaction *)value;
- (void)addTransaction:(NSSet<DBTransaction *> *)values;
- (void)removeTransaction:(NSSet<DBTransaction *> *)values;

@end

NS_ASSUME_NONNULL_END
