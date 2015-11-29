//
//  ConstViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"
#import "MainAbstractViewController.h"
#import "AddPlannedTransactionViewController.h"

@interface PlannedTransactionViewController : MainAbstractViewController

@property (nonatomic, strong) NSArray *plannedTransactionArray;
@property (nonatomic, strong) UITableView *plannedTransactionsTableView;
@property (nonatomic, strong) CenterViewController *centerController;
@property (nonatomic, strong) AddPlannedTransactionViewController *addPlannedTransactionViewController;
@property (nonatomic, copy) void (^backClicked)();

@end
