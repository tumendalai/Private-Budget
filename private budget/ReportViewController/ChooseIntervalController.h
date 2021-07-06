//
//  ChooseIntervalController.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ChooseIntervalController : UIViewController

@property (copy, nonatomic) void(^intervalSelected)(NSInteger);
@property (nonatomic, strong) NSArray *stringArray;

@end
