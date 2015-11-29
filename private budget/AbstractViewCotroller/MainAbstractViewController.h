//
//  MainAbstractViewController.h
//  MiningDictionary
//
//  Created by 6i on 2014-11-26.
//  Copyright (c) 2014 Munkh-Erdene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainAbstractViewController : UIViewController

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UINavigationController *navController;

-(void)configureView;
-(void)backButtonClicked:(UIButton *)button;

@end
