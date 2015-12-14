//
//  ChooseIntervalController.h
//  private budget
//
//  Created by Enkhdulguun on 12/14/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseIntervalController : UIViewController

@property (copy, nonatomic) void(^intervalSelected)(NSInteger);
@property (nonatomic, strong) NSArray *stringArray;

@end
