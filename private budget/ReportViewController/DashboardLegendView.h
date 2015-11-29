//
//  DashboardLegendScrollView.h
//  iRestaurantRepo
//
//  Created by Sodtseren Enkhee on 6/13/14.
//  Copyright (c) 2014 Sodtseren Enkhee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardLegendView : UIView

@property (nonatomic, strong) NSArray   *legendArray;

@property (nonatomic, assign) CGFloat   legendHeight;
@property (nonatomic, strong) UIFont    *nameFont;
@property (nonatomic, strong) UIFont    *valueFont;

@property (nonatomic, assign) CGFloat   nameOffset;

- (void)reloadData;

@end
