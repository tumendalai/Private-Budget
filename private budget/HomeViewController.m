//
//  HomeViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "HomeViewController.h"
#import "Transaction.h"
#import "Currency.h"
#import "TransactionTableViewCell.h"
#import "CategoryObject.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *thisMonthTransactionArray;
@property (nonatomic, strong) UITableView *thisMonthTableView;

@end

@implementation HomeViewController

@synthesize thisMonthTableView;
@synthesize thisMonthTransactionArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self getThisMonthTransactions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - user
-(void)configureView{
    [super configureView];
    [self.view addSubview:self.thisMonthTableView];
}

-(void)getThisMonthTransactions{
    Transaction *transaction = [[Transaction alloc] init];
    transaction.amount = @"800000";
    transaction.category_id = @"1";
    transaction.currency_id = @"1";
    transaction.date = @"2015-12-31 00:00:00";
    transaction.itemid = @"1";
    transaction.reciever = @"Төгөлдөр";
    transaction.transaction_description = @"Сарын цалин";
    transaction.is_income = @"1";
    
    Transaction *transaction1 = [[Transaction alloc] init];
    transaction1.amount = @"1800000";
    transaction1.category_id = @"1";
    transaction1.currency_id = @"1";
    transaction1.date = @"2015-12-31 00:00:00";
    transaction1.itemid = @"1";
    transaction1.reciever = @"Төгөлдөр";
    transaction1.transaction_description = @"Сургалтын төлбөр";
    transaction1.is_income = @"0";
    
    thisMonthTransactionArray = @[transaction,transaction1,transaction,transaction1,transaction,transaction,transaction1,transaction,transaction1,transaction,transaction,transaction1,transaction,transaction1,transaction];
    
    [self.thisMonthTableView reloadData];
//
//    [DATABASE_MANAGER writeToDatabase:@[transaction] toClass:[DBTransactions class] fetchedResultsController:nil];
//    
//    NSArray *dbActiveArray = [DATABASE_MANAGER searchObjectsForEntity:@"DBTransactions" withPredicate:nil andSortKey:@"itemid" andSortAscending:NO];
//    
//    thisMonthTransactionArray = [DATABASE_MANAGER readFromDatabase:dbActiveArray toClass:[DBTransactions class]];
//    
//    CategoryObject *currency1 = [[CategoryObject alloc] init];
//    currency1.category_image = @"mnt_currency";
//    currency1.category_name = @"MNT";
//    currency1.itemid = [NSNumber numberWithInt:1];
//    CategoryObject *currency2 = [[CategoryObject alloc] init];
//    currency2.category_image = @"mnt_currency";
//    currency2.category_name = @"MNT";
//    currency2.itemid = [NSNumber numberWithInt:1];
//    CategoryObject *currency3 = [[CategoryObject alloc] init];
//    currency3.category_image = @"mnt_currency";
//    currency3.category_name = @"MNT";
//    currency3.itemid = [NSNumber numberWithInt:1];
//    
//    [DATABASE_MANAGER writeToDatabase:@[currency1] toClass:[DBCategory class] fetchedResultsController:nil];
//    
//    NSArray *activeArray = [DATABASE_MANAGER searchObjectsForEntity:@"DBCategory" withPredicate:nil andSortKey:nil andSortAscending:NO];
//    
//    NSArray *array = [DATABASE_MANAGER readFromDatabase:activeArray toClass:[DBCategory class]];
    
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (self.thisMonthTransactionArray.count > 0)
        return self.thisMonthTransactionArray.count;
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.thisMonthTransactionArray.count == 0 && indexPath.row == 0) {
        
        return nil;
        
    } else {
        
        static NSString *CellIdentifier = @"TransactionTableViewCell";
        
        TransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TransactionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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

- (void)configureCell:(TransactionTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.transaction = [self.thisMonthTransactionArray objectAtIndex:indexPath.row];
    
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

- (UITableView *)thisMonthTableView {
    if (thisMonthTableView == nil) {
        thisMonthTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-60) style:UITableViewStylePlain];
        
        thisMonthTableView.backgroundColor = CLEAR_COLOR;
        thisMonthTableView.delegate = self;
        thisMonthTableView.dataSource = self;
    }
    return thisMonthTableView;
}

@end
