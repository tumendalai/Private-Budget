//
//  DBPlannedTransactions+CoreDataProperties.h
//  private budget
//
//  Created by Enkhdulguun on 11/22/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBPlannedTransactions.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBPlannedTransactions (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSNumber *attribute;
@property (nullable, nonatomic, retain) NSNumber *category;
@property (nullable, nonatomic, retain) NSNumber *currency_id;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSDate *end_date;
@property (nullable, nonatomic, retain) NSNumber *itemid;
@property (nullable, nonatomic, retain) NSString *planned_transaction_description;
@property (nullable, nonatomic, retain) NSString *reciever;
@property (nullable, nonatomic, retain) NSDate *start_date;

@end

NS_ASSUME_NONNULL_END
