//
//  DashboardLegendScrollView.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardLegendView : UIView

@property (nonatomic, strong) NSArray   *legendArray;

@property (nonatomic, assign) CGFloat   legendHeight;
@property (nonatomic, strong) UIFont    *nameFont;
@property (nonatomic, strong) UIFont    *valueFont;

@property (nonatomic, assign) CGFloat   nameOffset;
@property (nonatomic, strong) UIScrollView *myScrollView;

@property (nonatomic, assign) BOOL is_pie_chart;
@property (nonatomic, assign) BOOL is_numbered;
@property (nonatomic, assign) NSTextAlignment nameTextAlignment;

- (void)reloadData;

@end
