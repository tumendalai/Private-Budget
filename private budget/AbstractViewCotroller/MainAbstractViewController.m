//
//  MainAbstractViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "MainAbstractViewController.h"
#import "HomeViewController.h"
@interface MainAbstractViewController ()

@end

@implementation MainAbstractViewController
@synthesize backgroundImageView;
@synthesize headerView;
@synthesize backButton;

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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)headerTapped:(UITapGestureRecognizer*)gesture{
    [self.view endEditing:YES];
}
#pragma mark -
#pragma mark Getters
-(UIImageView *)headerView {
    if (headerView == nil) {
        headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        headerView.image = [UIImage imageNamed:@"header light.png"];
        headerView.userInteractionEnabled = YES;
//        {
//            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped:)];
//            [headerView addGestureRecognizer:tapGesture];
//            
//        }
    }
    return headerView;
}
-(UIButton *)backButton {
    if (backButton == nil) {
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.imageView.clipsToBounds = YES;
        backButton.frame = CGRectMake(0, 20, 44, 44);
        [backButton setImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return backButton;
}


@end
