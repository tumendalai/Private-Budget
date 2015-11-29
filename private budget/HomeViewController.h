//
//  HomeViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"
#import "MainAbstractViewController.h"

@interface HomeViewController : MainAbstractViewController

@property (nonatomic, strong) CenterViewController *centerController;

@end
