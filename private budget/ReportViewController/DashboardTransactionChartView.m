//
//  DashboardProductChartView.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "DashboardTransactionChartView.h"
#import "DBCategory.h"
#import "XYPieChart.h"
#import "DashboardLegendView.h"
#import "LegendObject.h"
#import "DBTransaction.h"

@interface DashboardTransactionChartView()<XYPieChartDelegate, XYPieChartDataSource>

@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) XYPieChart    *pieChart;
@property (nonatomic, strong) UIView        *centerView;
@property (nonatomic, strong) UILabel       *payLabel1;
@property (nonatomic, strong) UILabel       *payLabel2;
@property (nonatomic, strong) UILabel       *employeeLabel1;
@property (nonatomic, strong) UILabel       *employeeLabel2;

@property (nonatomic, strong) DashboardLegendView   *legendView;


@end

@implementation DashboardTransactionChartView
@synthesize categoryArray;
@synthesize titleLabel;
@synthesize pieChart;
@synthesize centerView;
@synthesize payLabel1;
@synthesize payLabel2;
@synthesize employeeLabel1;
@synthesize employeeLabel2;
@synthesize legendView;
@synthesize symbol;
@synthesize legendArray;
@synthesize is_income;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.pieChart];
    [self.pieChart addSubview:self.centerView];
    [self.centerView addSubview:self.payLabel1];
    [self.centerView addSubview:self.payLabel2];
    [self.centerView addSubview:self.employeeLabel1];
    [self.centerView addSubview:self.employeeLabel2];
    [self addSubview:self.legendView];
}

- (void)reloadData {
    
    //Legend
    self.legendArray = [NSMutableArray array];
    
    double total_price = 0;
    NSMutableDictionary *categoryDictionary = [NSMutableDictionary dictionary];
    {
        
        for (DBCategory *category in categoryArray) {
            for (DBTransaction *transaction in category.transaction) {
                double total = 0;
                if (!(is_income == transaction.is_income.boolValue))
                    continue;
                total = transaction.amount.doubleValue;
                total_price +=total;
                NSNumber *number = [categoryDictionary valueForKey:category.name];
                if (number == nil) {
                    number = [NSNumber numberWithDouble:total + number.doubleValue];
                } else {
                    number = [NSNumber numberWithDouble:total + number.doubleValue];
                }
                [categoryDictionary setValue:number forKey:category.name];
            }
        }
    }
    
    for (NSString *key in categoryDictionary.allKeys) {
        LegendObject *legendObject = [[LegendObject alloc] init];
        legendObject.name = key;
        legendObject.myvalue = [NSString stringWithFormat:@"%.f", [[categoryDictionary valueForKey:key] doubleValue]];
        legendObject.symbol = self.symbol;
        [self.legendArray addObject:legendObject];
    }

    NSArray *sortedLegendArray = [self.legendArray sortedArrayUsingComparator:^NSComparisonResult(LegendObject *obj1, LegendObject *obj2) {
        
        double total1 = obj1.myvalue.doubleValue;
        double total2 = obj2.myvalue.doubleValue;
        
        if (total1 < total2)
            return NSOrderedAscending;
        else if (total1 > total2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
//
    NSArray *colors = @[CHART_COLOR_1,
                        CHART_COLOR_2,
                        CHART_COLOR_3,
                        CHART_COLOR_4,
                        CHART_COLOR_5,
                        CHART_COLOR_6,
                        CHART_COLOR_7,
                        CHART_COLOR_8,
                        CHART_COLOR_9,
                        CHART_COLOR_10];
    self.legendArray = [NSMutableArray arrayWithArray:[[sortedLegendArray reverseObjectEnumerator] allObjects]];
    int k = 0;
    for (LegendObject *legend in self.legendArray) {
        legend.color = [colors objectAtIndex:k];
        k++;
        if (k >= 10)
            k = 0;
    }
    
    self.payLabel2.text = [NSString stringWithFormat:@"%.f%@",total_price,self.symbol];
    self.legendView.is_pie_chart = YES;
    self.legendView.legendArray = self.legendArray;
    [self.legendView reloadData];
    [self.pieChart reloadData];
}

- (double)getTotal {
    double total = 0;
    for (LegendObject *legend in self.legendArray) {
        total += (legend.myvalue).doubleValue;
    }
    return total;
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.legendArray.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    LegendObject *legend = [self.legendArray objectAtIndex:index];
    return (legend.myvalue).doubleValue;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    LegendObject *legend = [self.legendArray objectAtIndex:index];
    return legend.color;
}
- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    LegendObject *legend = [self.legendArray objectAtIndex:index];
    return [NSString stringWithFormat:@"%.0f%%", (legend.myvalue).doubleValue * 100.0f / [self getTotal]];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    //    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}


#pragma mark -
#pragma mark Getters
- (UILabel *)titleLabel {
    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.bounds.size.width-10, 60)];
        titleLabel.backgroundColor = CLEAR_COLOR;
        titleLabel.textColor = BLACK_COLOR;
        titleLabel.font = FONT_NORMAL_SMALL;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 2;
    }
    return titleLabel;
}
- (XYPieChart *)pieChart {
    if (pieChart == nil) {
        
        float width = self.bounds.size.width-40;
        
        pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(10, 40, width, width)
                                              Center:CGPointMake((self.bounds.size.width-width)/2+width/2-10, width/2)
                                              Radius:width/2];
        [pieChart setDelegate:self];
        [pieChart setDataSource:self];
        [pieChart setAnimationSpeed:1.0];
        [pieChart setUserInteractionEnabled:NO];
        [pieChart setBackgroundColor:CLEAR_COLOR];
        [pieChart setShowPercentage:NO];
        [pieChart setShowLabel:YES];
        
        [pieChart setLabelFont:[UIFont fontWithName:@"Digiface" size:20.0f]];
        [pieChart setLabelRadius:90];
    }
    
    return pieChart;
}
- (UIView *)centerView {
    if (centerView == nil) {
        centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pieChart.bounds.size.width-100, pieChart.bounds.size.height-100)];
        centerView.backgroundColor = [UIColor whiteColor];
        centerView.layer.cornerRadius = centerView.bounds.size.width/2;
        centerView.center = CGPointMake(pieChart.bounds.size.width/2+10, pieChart.bounds.size.height/2);
    }
    return centerView;
}

- (UILabel *)payLabel1 {
    if (payLabel1 == nil) {
        payLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, centerView.bounds.size.width-40, 20)];
        payLabel1.backgroundColor = CLEAR_COLOR;
        payLabel1.textColor = BLACK_COLOR;
        payLabel1.textAlignment = NSTextAlignmentCenter;
        payLabel1.text = @"Нийт:";
        payLabel1.font = FONT_NORMAL_SMALL;
    }
    return payLabel1;
}
- (UILabel *)payLabel2 {
    if (payLabel2 == nil) {
        payLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, centerView.bounds.size.width-10, 20)];
        payLabel2.backgroundColor = CLEAR_COLOR;
        payLabel2.textColor = BLACK_COLOR;
        payLabel2.textAlignment = NSTextAlignmentCenter;
        payLabel2.font = [UIFont fontWithName:@"Digiface" size:21.0f];
    }
    return payLabel2;
}

- (UILabel *)employeeLabel1 {
    if (employeeLabel1 == nil) {
        employeeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, centerView.bounds.size.width-40, 30)];
        employeeLabel1.backgroundColor = CLEAR_COLOR;
        employeeLabel1.textColor = BLACK_COLOR;
        employeeLabel1.textAlignment = NSTextAlignmentCenter;
        employeeLabel1.font = FONT_NORMAL_SMALL;
        employeeLabel1.numberOfLines = 2;
    }
    return employeeLabel1;
}
- (UILabel *)employeeLabel2 {
    if (employeeLabel2 == nil) {
        employeeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, centerView.bounds.size.width-10, 20)];
        employeeLabel2.backgroundColor = CLEAR_COLOR;
        employeeLabel2.textColor = BLACK_COLOR;
        employeeLabel2.textAlignment = NSTextAlignmentCenter;
        employeeLabel2.font = [UIFont fontWithName:@"Digiface" size:21.0f];
    }
    return employeeLabel2;
}

- (DashboardLegendView *)legendView {
    if (legendView == nil) {
        legendView = [[DashboardLegendView alloc] initWithFrame:CGRectMake(10, pieChart.frame.origin.y+pieChart.bounds.size.height+10, self.bounds.size.width-20, self.bounds.size.height-10-(pieChart.frame.origin.y+pieChart.bounds.size.height+10))];
        legendView.nameTextAlignment = NSTextAlignmentRight;
        legendView.backgroundColor = CLEAR_COLOR;
        legendView.nameFont = FONT_NORMAL_SMALLER;
        legendView.valueFont = [UIFont fontWithName:@"Digiface" size:14.0f];
        legendView.legendHeight = 25;
        legendView.nameOffset = 0;
        legendView.is_numbered = NO;
    }
    return legendView;
}
@end
