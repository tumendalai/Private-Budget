//
//  ReportViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 08.11.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "ReportViewController.h"
#import "CategoryObject.h"
#import "Transaction.h"

@interface ReportViewController ()
@property (nonatomic, strong) UILabel *thisMonthLabel;
@property (nonatomic, strong) NSArray *categoryTrArray;

@end

@implementation ReportViewController
@synthesize thisMonthLabel;
@synthesize productChartView;
@synthesize categoryTrArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.productChartView.categoryArray = self.categoryTrArray;
    [self.productChartView reloadData];
}

-(void)configureView{
    [super configureView];
    [self.view addSubview:self.thisMonthLabel];
    [self.view addSubview:self.productChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)categoryTrArray{
    
    if (categoryTrArray == nil) {
        CategoryObject *category = [[CategoryObject alloc] init];
        category.image = @"";
        category.type = @"1";
        category.name = @"Боловролын";
        
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
        
        category.transactionArray = @[transaction,transaction1,transaction,transaction1,transaction,transaction,transaction1,transaction,transaction1,transaction,transaction,transaction1,transaction,transaction1,transaction];
        
        CategoryObject *category1 = [[CategoryObject alloc] init];
        category1.image = @"";
        category1.type = @"1";
        category1.name = @"Боловролын";
        CategoryObject *category2 = [[CategoryObject alloc] init];
        category2.image = @"";
        category2.type = @"1";
        category2.name = @"Боловролын";
        CategoryObject *category3 = [[CategoryObject alloc] init];
        category3.image = @"";
        category3.type = @"1";
        category3.name = @"Унаа";
        
        
        
        category3.transactionArray = @[transaction,transaction1,transaction,transaction1,transaction,transaction,transaction1,transaction,transaction1,transaction,transaction,transaction1,transaction,transaction1,transaction];
        
        CategoryObject *category4 = [[CategoryObject alloc] init];
        category4.image = @"";
        category4.type = @"1";
        category4.name = @"Аялал";
        
        Transaction *transaction2 = [[Transaction alloc] init];
        transaction2.amount = @"800000";
        transaction2.category_id = @"1";
        transaction2.currency_id = @"1";
        transaction2.date = @"2015-12-31 00:00:00";
        transaction2.itemid = @"1";
        transaction2.reciever = @"Төгөлдөр";
        transaction2.transaction_description = @"Сарын цалин";
        transaction2.is_income = @"1";
        
        Transaction *transaction3 = [[Transaction alloc] init];
        transaction3.amount = @"1800000";
        transaction3.category_id = @"1";
        transaction3.currency_id = @"1";
        transaction3.date = @"2015-12-31 00:00:00";
        transaction3.itemid = @"1";
        transaction3.reciever = @"Төгөлдөр";
        transaction3.transaction_description = @"Сургалтын төлбөр";
        transaction3.is_income = @"0";
        category4.transactionArray = @[transaction2,transaction1,transaction,transaction2,transaction,transaction2,transaction1,transaction,transaction1,transaction,transaction,transaction1,transaction,transaction2,transaction,transaction3,transaction3,transaction3];
        
        categoryTrArray = @[category3,category2,category1,category4,category];
    }
    return categoryTrArray;
}

- (UILabel *)thisMonthLabel {
    if (thisMonthLabel == nil) {
        thisMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 64, SCREEN_WIDTH-60, 25)];
        thisMonthLabel.textAlignment = NSTextAlignmentCenter;
        thisMonthLabel.text = @"2015 оны 11 сар";
    }
    return thisMonthLabel;
}

- (DashboardProductChartView *)productChartView {
    if (productChartView == nil) {
        productChartView = [[DashboardProductChartView alloc] initWithFrame:CGRectMake(20, 90, 280, 440)];
        productChartView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        productChartView.clipsToBounds = YES;
    }
    return productChartView;
}

@end
