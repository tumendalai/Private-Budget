//
//  MainAbstractViewController.h
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainAbstractViewController : UIViewController

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIButton *backButton;

-(void)configureView;
-(void)backButtonClicked:(UIButton *)button;

@end
