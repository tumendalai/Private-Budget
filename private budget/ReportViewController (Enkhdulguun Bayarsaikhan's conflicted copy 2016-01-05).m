//
//  ReportViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 08.11.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "ReportViewController.h"
#import "WYPopoverController.h"
#import <CoreData/CoreData.h>
#import "ChooseIntervalController.h"
#import "NSDate+CupertinoYankee.h"
#import "DBCurrency.h"
#import "DashboardLegendView.h"
#import "PNChart.h"
#import "DBCategory.h"
#import "DBTransaction.h"
#import "LegendObject.h"

@interface ReportViewController ()<WYPopoverControllerDelegate>{
    WYPopoverController* popoverController;
    BOOL is_bar_chart;
}

@property (nonatomic, strong) UIScrollView *tScrollView;
@property (nonatomic, strong) UIScrollView *barScrollView;
@property (nonatomic, strong) UIButton *intervalLabelButton;
@property (nonatomic, strong) UIButton *changeGraphicButton;
@property (nonatomic, strong) NSArray *categoryTrArray;
@property (nonatomic, strong) NSArray *categoryTrArrayPre;
@property (nonatomic, strong) NSMutableArray *barChartArray;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *expenseLabel;
@property (nonatomic, strong) UILabel *totalIncomLabel;
@property (nonatomic, strong) UILabel *totalExpenseLabel;
@property (nonatomic, strong) UIButton *intervalButton;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSDate *todayDate;
@property (nonatomic, strong) DashboardLegendView   *legendView;
@property (nonatomic, strong) PNBarChart   *barChart;

@end

@implementation ReportViewController
@synthesize intervalLabelButton;
@synthesize inTransactionChartView;
@synthesize outTransactionChartView;
@synthesize categoryTrArray;
@synthesize intervalButton;
@synthesize todayDate;
@synthesize selectedIndex;
@synthesize legendView;
@synthesize tScrollView;
@synthesize incomeLabel;
@synthesize totalExpenseLabel;
@synthesize expenseLabel;
@synthesize totalIncomLabel;
@synthesize barChart;
@synthesize changeGraphicButton;
@synthesize categoryTrArrayPre;
@synthesize barChartArray;
@synthesize barScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.menuItems = [NSArray arrayWithObjects:@"Өдөр",@"7 хоног",@"Сар", @"Жил", nil];
    selectedIndex = 0;
    [self makePieChart];
    [self.backButton setHidden:YES];
    [self syncChangeButton];
}

-(void)configureView{
    [super configureView];
    [self.view addSubview:self.tScrollView];
    [self.headerView addSubview:self.intervalLabelButton];
    [self.headerView addSubview:self.intervalButton];
    [self.headerView addSubview:self.changeGraphicButton];
    [self.tScrollView addSubview:self.inTransactionChartView];
    [self.tScrollView addSubview:self.outTransactionChartView];
    [self.tScrollView addSubview:self.incomeLabel];
    [self.tScrollView addSubview:self.totalIncomLabel];
    [self.tScrollView addSubview:self.expenseLabel];
    [self.tScrollView addSubview:self.totalExpenseLabel];
    
    self.tScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 920);
    
    [self.view addSubview:self.barScrollView];
    [self.barScrollView addSubview:self.barChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark User

-(void)syncIntervalButton:(NSInteger)index{
    [self.intervalButton setTitle:[self.menuItems objectAtIndex:index] forState:UIControlStateNormal];
}

-(void)getCategoryTransactions:(NSInteger)index{
    
    todayDate = [NSDate date];
    NSDate *dateBefore = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.month = 0;
    comps.day = 0;
    comps.year = 0;
    
    NSPredicate *predicate = nil;
    NSPredicate *predicatePre = nil;
    NSLocale *enUSLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc]init];
    [formatter3 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter3 setLocale:enUSLocale];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    [formatter setLocale:enUSLocale];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"MM"];
    [formatter1 setLocale:enUSLocale];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"d"];
    [formatter2 setLocale:enUSLocale];
    
    NSDate *beginDatePrev = nil;
    NSDate *endDatePrev = nil;
    NSDate *beginDateCurrent = nil;
    NSDate *endDateCurrent = nil;
    
    switch (index) {
        case 0:{
            comps.day = -1;
            NSDate *date = [calendar dateByAddingComponents:comps toDate:todayDate options:0];
            NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear fromDate:date];
            dateBefore = [calendar dateFromComponents:components];
            
            beginDatePrev = [dateBefore beginningOfDay];
            endDatePrev = [dateBefore endOfDay];
//            predicatePre = [NSPredicate predicateWithFormat:@"(ANY transaction.date >= %@) AND (ANY transaction.date <= %@)", bOfDay, eOfDay];
            
            beginDateCurrent = [todayDate beginningOfDay];
            endDateCurrent = [todayDate endOfDay];
            predicate = [NSPredicate predicateWithFormat:@"(ANY transaction.date >= %@) AND (ANY transaction.date <= %@)", beginDateCurrent, endDateCurrent];
            [self.intervalLabelButton setTitle:[NSString stringWithFormat:@"%@ сарын %@",[formatter1 stringFromDate:todayDate],[formatter2 stringFromDate:todayDate]] forState:UIControlStateNormal];
            
//            NSLog(@"dateBefore %@ - bOfDay %@ - eOfDay %@",[formatter3 stringFromDate:dateBefore],[formatter3 stringFromDate:bOfDay],[formatter3 stringFromDate:eOfDay]);
            
//            NSLog(@"todayDate %@ - beginningOfDay %@ - endOfDay %@",[formatter3 stringFromDate:todayDate],[formatter3 stringFromDate:beginningOfDay],[formatter3 stringFromDate:endOfDay]);
        }
            break;
        case 1:{
            dateBefore = [NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:todayDate];
            
            beginDatePrev = [dateBefore beginningOfWeek];
            endDatePrev = [dateBefore endOfWeek];
            
//            predicatePre = [NSPredicate predicateWithFormat:@"(ANY transaction.date >= %@) AND (ANY transaction.date <= %@)", bOfWeek,  eOfWeek];
            
            beginDateCurrent = [todayDate beginningOfWeek];
            endDateCurrent = [todayDate endOfWeek];
            
            predicate = [NSPredicate predicateWithFormat:@"(ANY transaction.date >= %@) AND (ANY transaction.date <= %@)", beginDateCurrent,  endDateCurrent];
            [self.intervalLabelButton setTitle:@"Энэ долоо хоног" forState:UIControlStateNormal];
//            NSLog(@"dateBefore %@ - bOfWeek %@ - eOfWeek %@",[formatter3 stringFromDate:dateBefore],[formatter3 stringFromDate:bOfWeek],[formatter3 stringFromDate:eOfWeek]);
            
//            NSLog(@"todayDate %@ beginningOfWeek %@ - endOfWeek %@",[formatter3 stringFromDate:todayDate],[formatter3 stringFromDate:beginningOfWeek],[formatter3 stringFromDate:endOfWeek]);
        }
            break;
        case 2:{
            comps.month = -1;
            NSDate *date = [calendar dateByAddingComponents:comps toDate:todayDate options:0];
            NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear fromDate:date];
            dateBefore = [calendar dateFromComponents:components];
            beginDatePrev = [dateBefore beginningOfMonth];
            endDatePrev = [dateBefore endOfMonth];
//            predicatePre = [NSPredicate predicateWithFormat:@"(ANY transaction.date >= %@) AND (ANY transaction.date <= %@)", bOfMonth, eOfMonth];
            
            beginDateCurrent = [todayDate beginningOfMonth];
            endDateCurrent = [todayDate endOfMonth];
            predicate = [NSPredicate predicateWithFormat:@"(ANY transaction.date >= %@) AND (ANY transaction.date <= %@)", beginDateCurrent, endDateCurrent];
            
            [self.intervalLabelButton setTitle:[NSString stringWithFormat:@"%@ сар",[formatter1 stringFromDate:todayDate]] forState:UIControlStateNormal];
//            NSLog(@"dateBefore %@ - bOfMonth %@ - eOfMonth %@",[formatter3 stringFromDate:dateBefore],[formatter3 stringFromDate:bOfMonth],[formatter3 stringFromDate:eOfMonth]);
//            NSLog(@"todayDate %@ beginningOfMonth %@ - endOfMonth %@",[formatter3 stringFromDate:todayDate],[formatter3 stringFromDate:beginningOfMonth],[formatter3 stringFromDate:endOfMonth]);
        }
            break;
        case 3:{
            comps.year = -1;
            NSDate *date = [calendar dateByAddingComponents:comps toDate:todayDate options:0];
            NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear fromDate:date];
            dateBefore = [calendar dateFromComponents:components];
            beginDatePrev = [dateBefore beginningOfYear];
            endDatePrev = [dateBefore endOfYear];
            
//            predicatePre = [NSPredicate predicateWithFormat:@"(ANY transaction.date >= %@) AND (ANY transaction.date <= %@)", bOfYear, eOfYear];
            
            beginDateCurrent = [todayDate beginningOfYear];
            endDateCurrent = [todayDate endOfYear];
            predicate = [NSPredicate predicateWithFormat:@"(ANY transaction.date >= %@) AND (ANY transaction.date <= %@)", beginDateCurrent, endDateCurrent];
            [self.intervalLabelButton setTitle:[NSString stringWithFormat:@"%@ он",[formatter stringFromDate:todayDate]] forState:UIControlStateNormal];
//            NSLog(@"dateBefore %@ - bOfMonth %@ - eOfMonth %@",[formatter3 stringFromDate:dateBefore],[formatter3 stringFromDate:bOfYear],[formatter3 stringFromDate:eOfYear]);
//            NSLog(@"todayDate %@ beginningOfYear %@ - endOfYear %@",[formatter3 stringFromDate:todayDate],[formatter3 stringFromDate:beginningOfYear],[formatter3 stringFromDate:endOfYear]);
        }
            break;
        default:
            break;
    }
    
    DBCurrency *currency = nil;
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBCurrency"];
        
        // Create Predicate
        NSPredicate *currencyPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [USERDEF stringForKey:kSelectedCurrency]];
        [fetchRequest setPredicate:currencyPredicate];
        
        // Execute Fetch Request
        NSError *fetchError = nil;
        NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
        
        if (!fetchError) {
            currency = [result firstObject];
        }
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBCategory"];
    [fetchRequest setPredicate:predicate];
    
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];

    if (!fetchError) {
        self.categoryTrArray = result;
        
        self.inTransactionChartView.symbol = currency.symbol;
        self.inTransactionChartView.categoryArray = self.categoryTrArray;
        [self.inTransactionChartView reloadData];
        
        self.outTransactionChartView.symbol = currency.symbol;
        self.outTransactionChartView.categoryArray = self.categoryTrArray;
        [self.outTransactionChartView reloadData];
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
    barChartArray = [NSMutableArray array];
    NSMutableDictionary *categoryDictionaryPrev = [NSMutableDictionary dictionary];
    NSMutableDictionary *categoryDictionaryCurrent = [NSMutableDictionary dictionary];
    NSMutableArray *combinedArray = [NSMutableArray array];
    
    NSError *fetchErrorAll = nil;
    NSFetchRequest *fetchRequestAll = [[NSFetchRequest alloc] initWithEntityName:@"DBCategory"];
    NSArray *resultAll = [self.managedObjectContext executeFetchRequest:fetchRequestAll error:&fetchErrorAll];
    
    if (!fetchErrorAll) {
        
        for (DBCategory *category in resultAll) {
            for (DBTransaction *transaction in category.transaction) {
                NSLog(@"beginDatePrev %@ < transaction.date %@ < endDatePrev %@",[formatter3 stringFromDate:beginDatePrev],[formatter3 stringFromDate:transaction.date],[formatter3 stringFromDate:endDatePrev]);
                double total = 0;
                if ([transaction.date compare:beginDatePrev] == NSOrderedDescending && [transaction.date compare:endDatePrev] == NSOrderedAscending) {
                    
                    total = transaction.amount.doubleValue;
                    NSNumber *number = [categoryDictionaryPrev valueForKey:category.name];
                    if (number == nil) {
                        number = [NSNumber numberWithDouble:total + number.doubleValue];
                    } else {
                        number = [NSNumber numberWithDouble:total + number.doubleValue];
                    }
                    [categoryDictionaryPrev setValue:number forKey:category.name];
                }
                if ([transaction.date compare:beginDateCurrent] == NSOrderedDescending && [transaction.date compare:endDateCurrent] == NSOrderedAscending) {
                    total = transaction.amount.doubleValue;
                    NSNumber *number = [categoryDictionaryCurrent valueForKey:category.name];
                    if (number == nil) {
                        number = [NSNumber numberWithDouble:total + number.doubleValue];
                    } else {
                        number = [NSNumber numberWithDouble:total + number.doubleValue];
                    }
                    [categoryDictionaryCurrent setValue:number forKey:category.name];
                }
            }
        }
        
        NSMutableArray *prevArray = [NSMutableArray array];
        for (NSString *key in categoryDictionaryPrev.allKeys) {
            LegendObject *legendObject = [[LegendObject alloc] init];
            legendObject.name = key;
            legendObject.myvalue = [NSString stringWithFormat:@"%.f", [[categoryDictionaryPrev valueForKey:key] doubleValue]];
            legendObject.symbol = currency.symbol;
            [prevArray addObject:legendObject];
        }
        
        NSMutableArray *currentArray = [NSMutableArray array];
        for (NSString *key in categoryDictionaryCurrent.allKeys) {
            LegendObject *legendObject = [[LegendObject alloc] init];
            legendObject.name = key;
            legendObject.myvalue = [NSString stringWithFormat:@"%.f", [[categoryDictionaryCurrent valueForKey:key] doubleValue]];
            legendObject.symbol = currency.symbol;
            [currentArray addObject:legendObject];
        }
        
        for (DBCategory *category in resultAll) {
            
            LegendObject *preLegend = [[LegendObject alloc] init];
            LegendObject *legend = [[LegendObject alloc] init];
            
            for (LegendObject *preObject in prevArray) {
                if ([category.name isEqualToString:preObject.name]) {
                    preLegend = preObject;
                    break;
                }
            }
            
            for (LegendObject *object in currentArray) {
                if ([category.name isEqualToString:object.name]) {
                    legend = object;
                    break;
                }
            }
            if (preLegend.name && legend.name) {
                legend.name = @"";
                [combinedArray addObjectsFromArray:@[preLegend,legend]];
            } else if (preLegend.name){
                legend.symbol = preLegend.symbol;
                legend.name = @"";
                [combinedArray addObjectsFromArray:@[preLegend,legend]];
            } else if (legend.name){
                preLegend.name = legend.name;
                preLegend.myvalue = @"0";
                preLegend.symbol =legend.symbol;
                legend.name = @"";
                [combinedArray addObjectsFromArray:@[preLegend,legend]];
            }
        }
        
        barChartArray = combinedArray;
        
        [self makeBarChart];
    }
    
}

-(void)makePieChart{
    [self syncIntervalButton:selectedIndex];
    [self getCategoryTransactions:selectedIndex];
}

-(void)makeBarChart{
    
    NSMutableArray *xlabels = [NSMutableArray array];
    NSMutableArray *ylabels = [NSMutableArray array];
    
    NSString *yLabelsuffix = @"";
    for (LegendObject *object in barChartArray) {
        [xlabels addObject:object.name];
        [ylabels addObject:[NSNumber numberWithInt:object.myvalue.intValue]];
        yLabelsuffix = object.symbol;
    }
    
    if (barChartArray.count > 6){
        self.barChart.frame = CGRectMake(5, 0, SCREEN_WIDTH + 50 * (barChartArray.count - 6) + 5, SCREEN_HEIGHT-64-60);
        self.barScrollView.contentSize = CGSizeMake(SCREEN_WIDTH + 50 * (barChartArray.count - 6), SCREEN_HEIGHT-64-60);
    } else {
        self.barChart.frame = CGRectMake(5, 0, SCREEN_WIDTH-5, SCREEN_HEIGHT-64-60);
        self.barScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-60);
    }
    
    barChart.yLabelSuffix = yLabelsuffix;
    
    [barChart setXLabels:xlabels];
    [barChart setYValues:ylabels];
    [barChart strokeChart];
}

#pragma mark -
#pragma mark UIAction
-(void)intervalButtonClicked:(UIButton *)button{
    ChooseIntervalController *chooseIntervalController = [[ChooseIntervalController alloc] init];
    chooseIntervalController.preferredContentSize = CGSizeMake(100, 100);
    chooseIntervalController.stringArray = self.menuItems;
    chooseIntervalController.intervalSelected = ^(NSInteger index){
        [popoverController dismissPopoverAnimated:YES];
        [self syncIntervalButton:index];
        [self getCategoryTransactions:index];
        selectedIndex = index;
    };
    popoverController = [[WYPopoverController alloc] initWithContentViewController:chooseIntervalController];
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

-(void)intervalLabelButtonClicked:(UIButton*)button{
}

-(void)changeButtonClicked:(UIButton*)button{
    is_bar_chart = !is_bar_chart;
    self.barChart.hidden = !is_bar_chart;
    [self syncChangeButton];
    
    self.tScrollView.hidden = is_bar_chart;
    self.barScrollView.hidden = !is_bar_chart;
}

-(void)syncChangeButton{
    if(is_bar_chart)
        [self.changeGraphicButton setImage:[UIImage imageNamed:@"bar"] forState:UIControlStateNormal];
    else
        [self.changeGraphicButton setImage:[UIImage imageNamed:@"pie"] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark WYPopoverController delegate
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
- (UIButton *)intervalLabelButton {
    if (intervalLabelButton == nil) {
        intervalLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 32, 155, 25)];
        intervalLabelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        intervalLabelButton.backgroundColor = CLEAR_COLOR;
        intervalLabelButton.titleLabel.font = FONT_NORMAL;
        [intervalLabelButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [intervalLabelButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [intervalLabelButton addTarget:self action:@selector(intervalLabelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return intervalLabelButton;
}

- (UIButton *)intervalButton {
    if (intervalButton == nil) {
        intervalButton = [[MyButton alloc] initWithFrame:CGRectMake(235, 29,80, 34)];
        intervalButton.layer.borderWidth = 1;
        intervalButton.layer.cornerRadius = 4;
        intervalButton.titleLabel.font = FONT_NORMAL_SMALL;
        intervalButton.backgroundColor = CLEAR_COLOR;
        [intervalButton addTarget:self action:@selector(intervalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return intervalButton;
}

- (UIButton *)changeGraphicButton {
    if (changeGraphicButton == nil) {
        changeGraphicButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 29,80, 34)];
        changeGraphicButton.titleLabel.font = FONT_NORMAL_SMALL;
        changeGraphicButton.backgroundColor = CLEAR_COLOR;
        [changeGraphicButton addTarget:self action:@selector(changeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        changeGraphicButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return changeGraphicButton;
}

- (UIScrollView *)tScrollView {
    if (tScrollView == nil) {
        tScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-60)];
        tScrollView.backgroundColor = CLEAR_COLOR;
        tScrollView.showsVerticalScrollIndicator = NO;
        tScrollView.showsHorizontalScrollIndicator = NO;
        tScrollView.decelerationRate = 0.1f;
        tScrollView.pagingEnabled = NO;
        tScrollView.alwaysBounceVertical = YES;
    }
    return tScrollView;
}

- (UIScrollView *)barScrollView {
    if (barScrollView == nil) {
        barScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-60)];
        barScrollView.backgroundColor = CLEAR_COLOR;
        barScrollView.showsVerticalScrollIndicator = NO;
        barScrollView.showsHorizontalScrollIndicator = NO;
        barScrollView.decelerationRate = 0.1f;
        barScrollView.pagingEnabled = NO;
        barScrollView.alwaysBounceHorizontal = YES;
        barScrollView.hidden = YES;
    }
    return barScrollView;
}

- (UILabel *)incomeLabel {
    if (incomeLabel == nil) {
        incomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 25)];
        incomeLabel.backgroundColor = CLEAR_COLOR;
        incomeLabel.textColor = BLACK_COLOR;
        incomeLabel.textAlignment = NSTextAlignmentCenter;
        incomeLabel.font = FONT_NORMAL;
        incomeLabel.text = @"Орлого";
    }
    return incomeLabel;
}

- (DashboardTransactionChartView *)inTransactionChartView {
    if (inTransactionChartView == nil) {
        inTransactionChartView = [[DashboardTransactionChartView alloc] initWithFrame:CGRectMake(20, 10, 280, 440)];
        inTransactionChartView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.05f];
        inTransactionChartView.clipsToBounds = YES;
        inTransactionChartView.is_income = YES;
    }
    return inTransactionChartView;
}

- (UILabel *)expenseLabel {
    if (expenseLabel == nil) {
        expenseLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 475, SCREEN_WIDTH/2, 25)];
        expenseLabel.backgroundColor = CLEAR_COLOR;
        expenseLabel.textColor = BLACK_COLOR;
        expenseLabel.textAlignment = NSTextAlignmentCenter;
        expenseLabel.font = FONT_NORMAL;
        expenseLabel.text = @"Зарлага";
    }
    return expenseLabel;
}

- (DashboardTransactionChartView *)outTransactionChartView {
    if (outTransactionChartView == nil) {
        outTransactionChartView = [[DashboardTransactionChartView alloc] initWithFrame:CGRectMake(20, 470, 280, 440)];
        outTransactionChartView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.05f];
        outTransactionChartView.clipsToBounds = YES;
        outTransactionChartView.is_income = NO;
    }
    return outTransactionChartView;
}

-(PNBarChart*)barChart{
    if (barChart == nil) {
        barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-5, SCREEN_HEIGHT-64-60)];
        barChart.hidden = YES;
        barChart.labelFont = FONT_NORMAL_SMALLER;
        barChart.labelTextColor = [UIColor blueColor];
        [barChart setYLabelSum:2];
    }
    return barChart;
}

@end
