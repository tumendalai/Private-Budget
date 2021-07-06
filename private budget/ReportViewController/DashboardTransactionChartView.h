//
//  DashboardProductChartView.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardTransactionChartView : UIView

@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSString *symbol;

@property (nonatomic, strong) NSMutableArray        *legendArray;
@property (nonatomic, assign) BOOL is_income;

- (void)reloadData;

@end
