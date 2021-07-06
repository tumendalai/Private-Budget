//
//  ChooseIntervalController.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseDateController : UIViewController

@property (copy, nonatomic) void(^dateSelected)(NSDate *date);
@property (copy, nonatomic) void(^daySelected)(NSNumber *day);
@property (nonatomic, strong) NSArray *stringArray;
@property (nonatomic, assign) BOOL is_date_picker;

@end
