//
//  DashboardProductChartView.m
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 6/13/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import "DashboardProductChartView.h"
#import "CategoryObject.h"
#import "XYPieChart.h"
#import "DashboardLegendView.h"
#import "LegendObject.h"
#import "Transaction.h"

@interface DashboardProductChartView()<XYPieChartDelegate, XYPieChartDataSource>

@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) XYPieChart    *pieChart;
@property (nonatomic, strong) UIView        *centerView;
@property (nonatomic, strong) UILabel       *payLabel1;
@property (nonatomic, strong) UILabel       *payLabel2;
@property (nonatomic, strong) UILabel       *employeeLabel1;
@property (nonatomic, strong) UILabel       *employeeLabel2;

@property (nonatomic, strong) DashboardLegendView   *legendView;

@property (nonatomic, strong) NSMutableArray        *legendArray;

@end

@implementation DashboardProductChartView
@synthesize categoryArray;
@synthesize titleLabel;
@synthesize pieChart;
@synthesize centerView;
@synthesize payLabel1;
@synthesize payLabel2;
@synthesize employeeLabel1;
@synthesize employeeLabel2;
@synthesize legendView;
@synthesize legendArray;

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
    
    NSMutableDictionary *categoryDictionary = [NSMutableDictionary dictionary];
    {
        
        for (CategoryObject *category in categoryArray) {
            for (Transaction *transaction in category.transactionArray) {
                double total = 0;
                total = transaction.amount.doubleValue;
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
        legendObject.myvalue = [NSString stringWithFormat:@"%.2f", [[categoryDictionary valueForKey:key] doubleValue]];
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
//
//    
    if (self.legendArray.count > 20)
        self.legendArray = [NSMutableArray arrayWithArray:[self.legendArray subarrayWithRange:NSMakeRange(0, 20)]];
//
//    
    self.legendView.legendArray = self.legendArray;
    [self.legendView reloadData];
//
//    self.titleLabel.text = NSLocalizedString(@"Хамгийн их зарагдсан 20 бүтээгдэхүүн", nil).uppercaseString;
//    self.payLabel1.text = NSLocalizedString(@"Нийт", nil);
//    self.payLabel2.text = CURRENCY_FORMAT_WITH_SYMBOL([self getTotal]);
//    self.employeeLabel1.text = NSLocalizedString(@"Бүтээгдэхүүний тоо", nil);
//    self.employeeLabel2.text = [NSString stringWithFormat:@"%d", self.legendArray.count];
//    
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
    NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
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
        
        pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(10, 25, width, width)
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
        [pieChart setLabelRadius:85];
        
        /*[pieChartLeft setStartPieAngle:M_PI_2];	//optional
         [pieChartLeft setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];	//optional
         [pieChartLeft setLabelColor:BLACK_TEXT_COLOR];	//optional, defaults to white
         [pieChartLeft setLabelShadowColor:BLACK_TEXT_COLOR];	//optional, defaults to none (nil)
         [pieChartLeft setLabelRadius:160];	//optional
         [pieChartLeft setShowPercentage:NO];	//optional
         [pieChartLeft setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];	//optional
         [pieChartLeft setPieCenter:CGPointMake(240, 240)];	//optional*/
    }
    
    return pieChart;
}
- (UIView *)centerView {
    if (centerView == nil) {
//        centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pieChart.bounds.size.width-100, pieChart.bounds.size.height-100)];
//        centerView.backgroundColor = RANDOM_COLOR;
//        centerView.layer.cornerRadius = centerView.bounds.size.width/2;
//        centerView.center = CGPointMake(pieChart.bounds.size.width/2, pieChart.bounds.size.height/2);
    }
    return centerView;
}

- (UILabel *)payLabel1 {
    if (payLabel1 == nil) {
        payLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, centerView.bounds.size.width-40, 20)];
        payLabel1.backgroundColor = CLEAR_COLOR;
        payLabel1.textColor = BLACK_COLOR;
        payLabel1.textAlignment = NSTextAlignmentCenter;
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
        legendView.backgroundColor = CLEAR_COLOR;
        legendView.nameFont = FONT_NORMAL_SMALL;
        legendView.valueFont = [UIFont fontWithName:@"Digiface" size:14.0f];
        legendView.legendHeight = 30;
        legendView.nameOffset = 40;
    }
    return legendView;
}
@end
