//
//  DBCurrency+CoreDataProperties.h
//  private budget
//
//  Created by Enkhdulguun on 11/22/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBCurrency.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBCurrency (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *currency_image;
@property (nullable, nonatomic, retain) NSString *currency_name;
@property (nullable, nonatomic, retain) NSNumber *itemid;

@end

NS_ASSUME_NONNULL_END
