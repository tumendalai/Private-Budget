//
//  ConstViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainAbstractViewController.h"
#import "AddPlannedTransactionViewController.h"
#import <CoreData/CoreData.h>

@interface PlannedTransactionViewController : MainAbstractViewController

@property (nonatomic, strong) NSArray *plannedTransactionArray;
@property (nonatomic, strong) UITableView *plannedTransactionsTableView;
@property (nonatomic, strong) AddPlannedTransactionViewController *addPlannedTransactionViewController;
@property (nonatomic, copy) void (^backClicked)();
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)getPlannedTransactions;
-(void)reload;
@end
