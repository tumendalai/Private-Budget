//
//  HomeViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "HomeViewController.h"
#import "DBTransactions.h"
#import "Transactions.h"
#import "Currency.h"
#import "DBCurrency.h"
#import "TransactionTableViewCell.h"
#import "CategoryObject.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *chooseCurrencyTypeView;
@property (nonatomic, strong) UISegmentedControl *currencySegmentedControl;
@property (nonatomic, strong) NSMutableArray *currencyArray;
@property (nonatomic, strong) NSArray *thisMonthTransactionArray;
@property (nonatomic, strong) UITableView *thisMonthTableView;

@end

@implementation HomeViewController

@synthesize chooseCurrencyTypeView;
@synthesize currencySegmentedControl;
@synthesize currencyArray;
@synthesize thisMonthTableView;
@synthesize thisMonthTransactionArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCurrencyTypes];
    [self configureView];
    [self getThisMonthTransactions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIAction
- (void)currencySegmentedControlChanged:(UISegmentedControl *)segmentedControl {
    self.chooseCurrencyTypeView.hidden = YES;
    [USERDEF setValue:[self.currencyArray objectAtIndex:segmentedControl.selectedSegmentIndex] forKey:kSelectedCurrency];
}

#pragma mark - user
-(void)configureView{
    [self.view addSubview:self.chooseCurrencyTypeView];
    [self.chooseCurrencyTypeView addSubview:self.currencySegmentedControl];
}

-(void)getThisMonthTransactions{
//    Transactions *transaction = [[Transactions alloc] init];
//    transaction.amount = [NSNumber numberWithInt:1];
//    transaction.category_id = [NSNumber numberWithInt:1];
//    transaction.currency_id = [NSNumber numberWithInt:1];
//    transaction.date = [NSDate date];
//    transaction.itemid = [NSNumber numberWithInt:1];
//    transaction.reciever = @"";
//    transaction.transaction_description = @"Сарын цалин";
//    transaction.is_income = [NSNumber numberWithBool:YES];
//    
//    [DATABASE_MANAGER writeToDatabase:@[transaction] toClass:[DBTransactions class] fetchedResultsController:nil];
//    
//    NSArray *dbActiveArray = [DATABASE_MANAGER searchObjectsForEntity:@"DBTransactions" withPredicate:nil andSortKey:@"itemid" andSortAscending:NO];
//    
//    thisMonthTransactionArray = [DATABASE_MANAGER readFromDatabase:dbActiveArray toClass:[DBTransactions class]];
    
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
    
//    [DATABASE_MANAGER writeToDatabase:@[currency1] toClass:[DBCategory class] fetchedResultsController:nil];
//    
//    NSArray *activeArray = [DATABASE_MANAGER searchObjectsForEntity:@"DBCategory" withPredicate:nil andSortKey:nil andSortAscending:NO];
//    
//    NSArray *array = [DATABASE_MANAGER readFromDatabase:activeArray toClass:[DBCategory class]];
    
}

-(void)createCurrencyTypes{
    Currency *currency1 = [[Currency alloc] init];
    currency1.currency_image = @"mnt_currency";
    currency1.currency_name = @"MNT";
    currency1.itemid = [NSNumber numberWithInt:1];
    Currency *currency2 = [[Currency alloc] init];
    currency2.currency_image = @"dollar_currency";
    currency2.currency_name = @"USD";
    currency2.itemid = [NSNumber numberWithInt:2];
    Currency *currency3 = [[Currency alloc] init];
    currency3.currency_image = @"currency_euro";
    currency3.currency_name = @"EUR";
    currency3.itemid = [NSNumber numberWithInt:3];
    
    [DATABASE_MANAGER writeToDatabase:@[currency1, currency2, currency3] toClass:[DBCurrency class] fetchedResultsController:nil];
    
    NSArray *dbActiveArray = [DATABASE_MANAGER searchObjectsForEntity:@"DBCurrency" withPredicate:nil andSortKey:@"itemid" andSortAscending:YES];
    
    NSArray *currArray = [DATABASE_MANAGER readFromDatabase:dbActiveArray toClass:[Currency class]];
    
    self.currencyArray = [NSMutableArray array];
    for (Currency *currency in currArray) {
        [self.currencyArray addObject:currency.currency_name];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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
    cell.transaction = nil;
    cell.transaction = [self.thisMonthTransactionArray objectAtIndex:indexPath.row];
    
    [cell layoutSubviews];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.billArray.count > 0) {
//        ReportBill *reportBill = [self.billArray objectAtIndex:indexPath.row];
//        reportBill.isSelected = !reportBill.isSelected;
//        
//        [self syncFooterView];
//        
//        [self.myTableView reloadData];
//    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 26)];
    view.backgroundColor = CLEAR_COLOR;
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 30, 26)];
        label.font = FONT_NORMAL_SMALL;
        label.backgroundColor = CLEAR_COLOR;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = NSLocalizedString(@"№", nil);
        [view addSubview:label];
    }
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 26)];
        label.font = FONT_NORMAL_SMALL;
        label.backgroundColor = CLEAR_COLOR;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = NSLocalizedString(@"Ширээ", nil);
        [view addSubview:label];
    }
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(95, 0, 100, 26)];
        label.font = FONT_NORMAL_SMALL;
        label.backgroundColor = CLEAR_COLOR;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = NSLocalizedString(@"Ажилтан", nil);
        [view addSubview:label];
    }
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 150, 26)];
        label.font = FONT_NORMAL_SMALL;
        label.backgroundColor = CLEAR_COLOR;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = NSLocalizedString(@"Огноо", nil);
        [view addSubview:label];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.billArray.count == 0) {
//        return 44;
//    } else {
//        
//        ReportBill *bill = [self.billArray objectAtIndex:indexPath.row];
//        
//        CGFloat height = 0;
//        for (Product *prod in bill.productsArray) {
//            
//            NSString *prodName = [NSString stringWithFormat:@"%@\n%@", [prod getNameWhenDiscounted], [prod getNameFromChoices]];
//            CGFloat realHeight = [MyUtils dynamicHeightForString:prodName
//                                                            font:FONT_NORMAL_SMALL
//                                                           width:250
//                                                       minHeight:20
//                                                       maxHeight:2000
//                                                           space:5];
//            
//            height += realHeight;
//        }
//        
//        if (height <= 100) {
//            return 5 + 100 + 5 + 54 + additionalHeightForRow;
//        } else {
//            return 5 + height + 5 + 54 + additionalHeightForRow;
//        }
//    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 26;
}

//- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (self.billArray.count > 0)
//        return self.footerView;
//    else
//        return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (self.billArray.count > 0)
//        return 100;
//    else
//        return 0;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Getter

- (UITableView *)thisMonthTableView {
    if (thisMonthTableView == nil) {
        thisMonthTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, SCREEN_HEIGHT-180) style:UITableViewStylePlain];
        
        thisMonthTableView.backgroundColor = CLEAR_COLOR;
        thisMonthTableView.delegate = self;
        thisMonthTableView.dataSource = self;
//        thisMonthTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        thisMonthTableView.hidden = YES;
    }
    return thisMonthTableView;
}

-(UIView *)chooseCurrencyTypeView{
    if (chooseCurrencyTypeView == nil){
        chooseCurrencyTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        chooseCurrencyTypeView.backgroundColor = [UIColor whiteColor];
        {
           UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 130, SCREEN_WIDTH - 60, 25)];
            label.text = @"Төлбөрийн нэгж";
            label.textAlignment = NSTextAlignmentLeft;
            [chooseCurrencyTypeView addSubview:label];
        }
    }
    return chooseCurrencyTypeView;
}

-(UISegmentedControl *)currencySegmentedControl{
    if (currencySegmentedControl == nil){
        currencySegmentedControl = [[UISegmentedControl alloc] initWithItems:self.currencyArray];
        currencySegmentedControl.frame = CGRectMake(40, 160, SCREEN_WIDTH - 80, 34);
        currencySegmentedControl.backgroundColor = [UIColor whiteColor];
        [currencySegmentedControl addTarget:self action:@selector(currencySegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
        currencySegmentedControl.selectedSegmentIndex = 0;
        currencySegmentedControl.tintColor = [UIColor blueColor];
    }
    return currencySegmentedControl;
}

@end
