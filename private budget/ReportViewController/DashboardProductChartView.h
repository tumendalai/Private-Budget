//
//  DashboardProductChartView.h
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 6/13/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardProductChartView : UIView

@property (nonatomic, strong) NSArray *categoryArray;

- (void)reloadData;

@end
