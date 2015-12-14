//
//  DBCurrency+CoreDataProperties.h
//  private budget
//
//  Created by enkhdulguun on 12/13/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBCurrency.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBCurrency (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *symbol;
@property (nullable, nonatomic, retain) NSSet<DBPlannedTransaction *> *planned_transaction;
@property (nullable, nonatomic, retain) NSSet<DBTransaction *> *transaction;

@end

@interface DBCurrency (CoreDataGeneratedAccessors)

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
