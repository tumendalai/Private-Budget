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
#import <CoreData/CoreData.h>

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

-(void)getCategoryTransactions{
    
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
