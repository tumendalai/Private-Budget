//
//  DBTransaction.h
//  private budget
//
//  Created by enkhdulguun on 12/13/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBCategory, DBCurrency;

NS_ASSUME_NONNULL_BEGIN

@interface DBTransaction : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "DBTransaction+CoreDataProperties.h"
