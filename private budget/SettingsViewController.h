//
//  SettingsViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 08.11.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CenterViewController.h"
#import "MainAbstractViewController.h"

@interface SettingsViewController : MainAbstractViewController

@property (nonatomic, copy) void (^addButtonClicked)();

@end
