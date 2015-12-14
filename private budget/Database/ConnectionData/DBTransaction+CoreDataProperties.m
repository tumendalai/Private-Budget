//
//  DBTransaction+CoreDataProperties.m
//  private budget
//
//  Created by enkhdulguun on 12/13/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBTransaction+CoreDataProperties.h"

@implementation DBTransaction (CoreDataProperties)

@dynamic amount;
@dynamic date;
@dynamic is_income;
@dynamic receiver;
@dynamic transaction_description;
@dynamic tran_category;
@dynamic tran_currency;

@end
