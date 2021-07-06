//
//  HomeViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainAbstractViewController.h"

#import <CoreData/CoreData.h>

@interface HomeViewController : MainAbstractViewController

@property (strong, nonatomic) NSDate  *selected_start_date;
@property (strong, nonatomic) NSDate *selected_end_date;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)getTransactions:(NSDate *)beginDate end:(NSDate*)endDates;

-(void)reload;

@end
