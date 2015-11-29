//
//  MainViewController.m
//  MiningDictionary
//
//  Created by 6i on 2014-11-20.
//  Copyright (c) 2014 Munkh-Erdene. All rights reserved.
//
#import "CenterViewController.h"
//#import "TableViewCell.h"
#import "HomeViewController.h"
#import "PlannedTransactionViewController.h"
#import "ReportViewController.h"
#import "SettingsViewController.h"
#import "AddTransactionViewController.h"


@interface CenterViewController ()
//footer
@property (nonatomic,strong) HomeViewController        *homeViewController;
@property (nonatomic,strong) PlannedTransactionViewController       *plannedTransactionViewController;
@property (nonatomic,strong) ReportViewController   *reportViewController;
@property (nonatomic,strong) AddTransactionViewController       *addTransactionViewController;
@property (nonatomic,strong) SettingsViewController      *settingsViewController;

@end

@implementation CenterViewController
@synthesize homeViewController, plannedTransactionViewController, reportViewController, addTransactionViewController,settingsViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshController:(int)menuIndex array:(UIViewController *)viewController{
    if (self.plannedTransactionViewController.navController.viewControllers.count > 1){
        [self.plannedTransactionViewController.navController popViewControllerAnimated:NO];
        
    }
    switch (menuIndex) {
        case 1: {
            self.homeViewController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
            self.homeViewController.navController = (UINavigationController *)self.navigationController;
            self.homeViewController.centerController = self;
            [self.view addSubview:self.homeViewController.view];
            self.homeViewController.view.frame = self.view.bounds;
        }
            break;
        case 2: {
            if (self.plannedTransactionViewController.navController.viewControllers.count > 1){
                [self.plannedTransactionViewController.navController popViewControllerAnimated:NO];
                
            }
            if (![self isKindOfClass:[PlannedTransactionViewController class]]){
                if (self.plannedTransactionViewController.addPlannedTransactionViewController.navController.viewControllers.count > 1){
                    [self.plannedTransactionViewController.addPlannedTransactionViewController.navController popViewControllerAnimated:NO];
                }
                if (self.plannedTransactionViewController) {
                    [self.view bringSubviewToFront:self.plannedTransactionViewController.view];
                    [self.plannedTransactionViewController.plannedTransactionsTableView reloadData];
                    break;
                }
                self.plannedTransactionViewController = [[PlannedTransactionViewController alloc] initWithNibName:nil bundle:nil];
                self.plannedTransactionViewController.navController = self.navigationController;
                __weak typeof(self)weakSelf = self;
                self.plannedTransactionViewController.backClicked = ^{
                    [weakSelf refreshController:0 array:nil];
                };
                [self.view addSubview:self.plannedTransactionViewController.view];
                self.plannedTransactionViewController.view.frame = self.view.bounds;
                
            }
        }
            break;
        case 3: {
            if (self.addTransactionViewController) {
                [self.view bringSubviewToFront:self.addTransactionViewController.view];
                break;
            }
            self.addTransactionViewController = [[AddTransactionViewController alloc] initWithNibName:nil bundle:nil];
            self.addTransactionViewController.navController = self.navigationController;
            __weak typeof(self)weakSelf = self;
            self.addTransactionViewController.saveButtonClicked = ^{
                [weakSelf refreshController:0 array:nil];
            };
            [self.view addSubview:self.addTransactionViewController.view];
            self.addTransactionViewController.view.frame = self.view.bounds;
            
        }
            break;
        case 4:{
            
                    if (self.reportViewController) {
                        [self.reportViewController.productChartView reloadData];
                        [self.view bringSubviewToFront:self.reportViewController.view];
                        break;
                    }
                    self.reportViewController = [[ReportViewController alloc] initWithNibName:nil bundle:nil];
                    self.reportViewController.navController = self.navigationController;
                    __weak typeof(self)weakSelf = self;
//                    self.reportViewController.backClicked = ^{
//                        [weakSelf refreshController:0 array:nil];
//                    };
                    [self.view addSubview:self.reportViewController.view];
                    self.reportViewController.view.frame = self.view.bounds;
        }
            break;
        case 5:{
            if (self.settingsViewController) {
                [self.view bringSubviewToFront:self.settingsViewController.view];
                break;
            }
            self.settingsViewController = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
            self.settingsViewController.navController = self.navigationController;
            __weak typeof(self)weakSelf = self;
//            self.settingsViewController.backClicked = ^{
//                [weakSelf refreshController:0 array:nil];
//            };
            [self.view addSubview:self.settingsViewController.view];
            self.settingsViewController.view.frame = self.view.bounds;
        }
            break;
            
        default:
            break;
    }
    
}


@end
