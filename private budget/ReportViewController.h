//
//  ReportViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 08.11.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainAbstractViewController.h"
#import "DashboardProductChartView.h"
#import <CoreData/CoreData.h>

@interface ReportViewController : MainAbstractViewController

@property (nonatomic, strong) DashboardProductChartView *productChartView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
