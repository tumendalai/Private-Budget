//
//  ViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CenterViewController.h"
#import "MainAbstractViewController.h"

@interface AddTransactionViewController : MainAbstractViewController


@property (nonatomic, copy) void (^saveButtonClicked)();


@end

