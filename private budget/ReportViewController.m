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
#import "WYPopoverController.h"
#import <CoreData/CoreData.h>
#import "ChooseIntervalController.h"
#import "NSDate+CupertinoYankee.h"

@interface ReportViewController ()<WYPopoverControllerDelegate>{
    WYPopoverController* popoverController;
}

@property (nonatomic, strong) UILabel *intervalLabel;
@property (nonatomic, strong) NSArray *categoryTrArray;
@property (nonatomic, strong) UIButton *intervalButton;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSDate *todayDate;

@end

@implementation ReportViewController
@synthesize intervalLabel;
@synthesize productChartView;
@synthesize categoryTrArray;
@synthesize intervalButton;
@synthesize todayDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.productChartView.categoryArray = self.categoryTrArray;
    self.menuItems = [NSArray arrayWithObjects:@"Өдөр",@"7 хоног",@"Сар", @"Жил", nil];
    [self syncIntervalButton:0];
    [self.productChartView reloadData];
}

-(void)configureView{
    [super configureView];
    [self.view addSubview:self.intervalLabel];
    [self.view addSubview:self.intervalButton];
    [self.view addSubview:self.productChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)syncIntervalButton:(NSInteger)selectedIndex{
    [self.intervalButton setTitle:[self.menuItems objectAtIndex:selectedIndex] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark User
-(void)getCategoryTransactions:(NSInteger)index{
    
    todayDate = [NSDate date];
    
    NSPredicate *predicate = nil;
    
    switch (index) {
        case 0:{
            NSDate *beginningOfDay = [todayDate beginningOfDay];
            NSDate *endOfDay = [todayDate endOfDay];
            predicate = [NSPredicate predicateWithFormat:@"%K > %@ AND %K < %@", @"date", beginningOfDay, @"date", endOfDay];
        }
            break;
        case 1:{
            NSDate *beginningOfWeek = [todayDate beginningOfWeek];
            NSDate *endOfWeek = [todayDate endOfWeek];
            predicate = [NSPredicate predicateWithFormat:@"%K > %@ AND %K < %@", @"date", beginningOfWeek, @"date", endOfWeek];
        }
            break;
        case 2:{
            NSDate *beginningOfMonth = [todayDate beginningOfMonth];
            NSDate *endOfMonth = [todayDate endOfMonth];
            predicate = [NSPredicate predicateWithFormat:@"%K > %@ AND %K < %@", @"date", beginningOfMonth, @"date", endOfMonth];
        }
            break;
        case 3:{
            NSDate *beginningOfYear = [todayDate beginningOfYear];
            NSDate *endOfYear = [todayDate endOfYear];
            predicate = [NSPredicate predicateWithFormat:@"%K > %@ AND %K < %@", @"date", beginningOfYear, @"date", endOfYear];
        }
            break;
        default:
            break;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBCategory"];

    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"DBCategory.transaction" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor1, sortDescriptor2]];
    
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        self.categoryTrArray = result;
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
}

#pragma mark -
#pragma mark UIAction
-(void)intervalButtonClicked:(UIButton *)button{
    ChooseIntervalController *chooseIntervalController = [[ChooseIntervalController alloc] init];
    chooseIntervalController.preferredContentSize = CGSizeMake(200, 200);
    chooseIntervalController.stringArray = self.menuItems;
    chooseIntervalController.intervalSelected = ^(NSInteger index){
        [popoverController dismissPopoverAnimated:YES];
        [self syncIntervalButton:index];
        [self getCategoryTransactions:index];
    };
    popoverController = [[WYPopoverController alloc] initWithContentViewController:chooseIntervalController];
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}


#pragma mark -
#pragma mark Getter
- (UILabel *)intervalLabel {
    if (intervalLabel == nil) {
        intervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 64, 170, 25)];
        intervalLabel.textAlignment = NSTextAlignmentCenter;
        intervalLabel.text = @"2015 оны 11 сар";
        intervalLabel.backgroundColor = CLEAR_COLOR;
    }
    return intervalLabel;
}

- (UIButton *)intervalButton {
    if (intervalButton == nil) {
        intervalButton = [[UIButton alloc] initWithFrame:CGRectMake(235, 64,80, 25)];
        intervalButton.layer.borderWidth = 0.5f;
        intervalButton.layer.cornerRadius = 4;
        intervalButton.titleLabel.font = FONT_NORMAL_SMALL;
        intervalButton.backgroundColor = CLEAR_COLOR;
        [intervalButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [intervalButton addTarget:self action:@selector(intervalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return intervalButton;
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
