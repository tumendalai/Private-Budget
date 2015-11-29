//
//  ConstViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainAbstractViewController.h"

@interface AddPlannedTransactionViewController : MainAbstractViewController

@property (nonatomic, strong) NSArray *plannedTransactionArray;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) UITableView *plannedTransactionsTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *amountTextfield;
@property (nonatomic, strong) UILabel *dueDateLabel;
@property (nonatomic, strong) UIButton *dueDateButton;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *endButton;
@property (nonatomic, strong) UICollectionView *catCollectionView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UITextField *descriptionTextfield;
@property (nonatomic, strong) UITextField *receiverTextfield;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end
