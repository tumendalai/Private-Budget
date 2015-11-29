//
//  ConstViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "PlannedTransactionViewController.h"
#import "PlannedTransactionTableViewCell.h"
#import "AddPlannedTransactionViewController.h"
#import "PlannedTransaction.h"

@interface PlannedTransactionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *addButton;
@end

@implementation PlannedTransactionViewController

@synthesize plannedTransactionArray;
@synthesize plannedTransactionsTableView;
@synthesize addButton;
@synthesize addPlannedTransactionViewController;
@synthesize backClicked;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureView];
    [self testMethod];
    [self.plannedTransactionsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureView{
    [self.view addSubview:self.plannedTransactionsTableView];
    [self.view addSubview:self.addButton];
}

-(void)testMethod{
    
    PlannedTransaction *transaction = [[PlannedTransaction alloc] init];
    transaction.amount = @"800000";
    transaction.category_id = @"1";
    transaction.currency_id = @"1";
    transaction.date = @"27";
    transaction.itemid = @"1";
    transaction.reciever = @"Төгөлдөр";
    transaction.transaction_description = @"Сарын цалин";
    transaction.is_income = @"1";
    transaction.startDate = @"2015-11-12 12:00:00";
    transaction.endDate = @"2025-11-12 12:00:00";
    
    PlannedTransaction *transaction1 = [[PlannedTransaction alloc] init];
    transaction1.amount = @"800000";
    transaction1.category_id = @"1";
    transaction1.currency_id = @"1";
    transaction1.date = @"30";
    transaction1.itemid = @"1";
    transaction1.reciever = @"Төгөлдөр";
    transaction1.transaction_description = @"Байрны лизинг";
    transaction1.is_income = @"0";
    transaction1.startDate = @"2015-11-12 12:00:00";
    transaction1.endDate = @"2035-11-12 12:00:00";
    
    plannedTransactionArray = @[transaction,transaction1,transaction,transaction1,transaction1,transaction,transaction1,transaction];
}

#pragma mark -
#pragma mark UIAction

-(void)addButtonClicked:(UIButton *)button{
    addPlannedTransactionViewController = [[AddPlannedTransactionViewController alloc] initWithNibName:nil bundle:nil];
    addPlannedTransactionViewController.navController = self.navController;
    
    [self.navController  pushViewController:addPlannedTransactionViewController animated:YES];
}

-(void)backButtonClicked:(UIButton *)button {
    if (self.backClicked) {
        self.backClicked();
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (self.plannedTransactionArray.count > 0)
        return self.plannedTransactionArray.count;
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.plannedTransactionArray.count == 0 && indexPath.row == 0) {
        
        return nil;
        
    } else {
        
        static NSString *CellIdentifier = @"PlannedTransactionTableViewCell";
        
        PlannedTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PlannedTransactionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        cell.indexPath = indexPath;
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }
}

//- (EmptyTableViewCell *)getEmptyCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
//    static NSString *CellIdentifier = @"EmptyTableViewCell";
//
//    EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[EmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//
//    [cell layoutSubviews];
//
//    return cell;
//}

- (void)configureCell:(PlannedTransactionTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.transaction = nil;
    cell.transaction = [self.plannedTransactionArray objectAtIndex:indexPath.row];
    
    [cell layoutSubviews];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Getter

- (UITableView *)plannedTransactionsTableView {
    if (plannedTransactionsTableView == nil) {
        plannedTransactionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64-60) style:UITableViewStylePlain];
        
        plannedTransactionsTableView.delegate = self;
        plannedTransactionsTableView.dataSource = self;
    }
    return plannedTransactionsTableView;
}

- (UIButton *)addButton {
    if (addButton == nil) {
        addButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44, 20, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"button_add"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return addButton;
}

@end
