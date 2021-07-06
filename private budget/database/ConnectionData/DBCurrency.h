//
//  DBCurrency.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBPlannedTransaction, DBTransaction;

NS_ASSUME_NONNULL_BEGIN

@interface DBCurrency : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "DBCurrency+CoreDataProperties.h"
