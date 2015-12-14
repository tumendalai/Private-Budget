//
//  MainAbstractViewController.m
//  MiningDictionary
//
//  Created by 6i on 2014-11-26.
//  Copyright (c) 2014 Munkh-Erdene. All rights reserved.
//

#import "MainAbstractViewController.h"
#import "HomeViewController.h"
@interface MainAbstractViewController ()

@end

@implementation MainAbstractViewController
@synthesize backgroundImageView;
@synthesize headerView;
@synthesize backButton;
@synthesize navController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)configureView {
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.backButton];
}

#pragma mark -
#pragma mark IBActions
-(void)backButtonClicked:(UIButton *)button {
    if (![self isKindOfClass:[HomeViewController class]]) {
        if (self.navController.viewControllers.count > 1){
            [self.navController popViewControllerAnimated:YES];
        }else {
            //            if (self.navController.viewControllers.count > 1){
            //                [self.navController popViewControllerAnimated:YES];
            //        }
        }
    }
}

-(void)headerTapped:(UITapGestureRecognizer*)gesture{
    [self.view endEditing:YES];
}
#pragma mark -
#pragma mark Getters
-(UIImageView *)backgroundImageView {
    if (backgroundImageView == nil) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
        backgroundImageView.image = [UIImage imageNamed:@"iphone 5 wall.png"];
        backgroundImageView.userInteractionEnabled = YES;
    }
    return backgroundImageView;
}
-(UIImageView *)headerView {
    if (headerView == nil) {
        headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        headerView.image = [UIImage imageNamed:@"header light.png"];
        headerView.userInteractionEnabled = YES;
        {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped:)];
            [headerView addGestureRecognizer:tapGesture];
            
        }
    }
    return headerView;
}
-(UIButton *)backButton {
    if (backButton == nil) {
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.imageView.clipsToBounds = YES;
        backButton.frame = CGRectMake(0, 20, SCREEN_WIDTH, 64);
        [backButton setImage:[UIImage imageNamed:@"home header.png"] forState:UIControlStateNormal];
        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return backButton;
}


@end
