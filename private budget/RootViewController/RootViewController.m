//
//  RootViewController.m
//  private budget
//
//  Created by Enkhdulguun on 11/24/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "RootViewController.h"

#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "CenterViewController.h"
#import "Currency.h"
//#import "MainView.h"
//#import "DBDictionary.h"
//#import "MainAbstractViewController.h"
//#import "Database.h"

@interface RootViewController () {
    UIButton *previousSelectedMainMenuButton;
    
    BOOL isNotFirst;
}

@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) CenterViewController *centerController;
@property (nonatomic, strong) UIView *chooseCurrencyTypeView;
@property (nonatomic, strong) UISegmentedControl *currencySegmentedControl;
@property (nonatomic, strong) NSMutableArray *currencyArray;

@end

@implementation RootViewController
@synthesize menuView;
@synthesize mainView;
@synthesize navController;
@synthesize centerController;
@synthesize chooseCurrencyTypeView;
@synthesize currencySegmentedControl;
@synthesize currencyArray;

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
    
   
    //    DATABASE_MANAGER.wordsSavedArray= [NSArray array];
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSLog(@"updateIDRoot: %@", [defaults valueForKey:@"updateID"]);
    //    if (![defaults valueForKey:@"updateID"]) {
    //
    //        [self wordsFromDB];
    //    }else{
    //        OnlineViewController *onlineController = [[OnlineViewController alloc] init];
    //        [onlineController getLib];
    //    }
    
    [self configureView];
    if (![USERDEF valueForKey:kSelectedCurrency]) {
        [self createCurrencyTypes];
        [self.view addSubview:self.chooseCurrencyTypeView];
        [self.chooseCurrencyTypeView addSubview:self.currencySegmentedControl];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!isNotFirst) {
        isNotFirst = YES;
        [self.centerController refreshController:1 array:self];
    }
}

- (void)configureView {
    [self.view addSubview:self.mainView];
    [self.mainView addSubview:self.navController.view];
    [self.view addSubview:self.menuView];
    
}

-(void)changeMenuButtons:(int)buttonTag{
    if (buttonTag == 1 || buttonTag == 3) {
        for (int i = 1; i <=5 ; i++) {
            UIButton *button = (UIButton *)[self.menuView viewWithTag:i];
            UIView *separator = (UIView *)[self.menuView viewWithTag:i+10];
            if (i == 3) {
                button.hidden = NO;
            }
            button.frame = CGRectMake((i-1)*(SCREEN_WIDTH/5), 0, SCREEN_WIDTH/5, 60);
            separator.frame = CGRectMake((i-1)*(SCREEN_WIDTH/5), 0, 1, 60);
        }
    } else {
        for (int i = 1; i <=5 ; i++) {
            UIButton *button = (UIButton *)[self.menuView viewWithTag:i];
            UIView *separator = (UIView *)[self.menuView viewWithTag:i+10];
            if (i == 3) {
                button.hidden = YES;
            }
            int j = i;
            if (j > 2) {
                j -=1;
            }
            button.frame = CGRectMake((j-1)*(SCREEN_WIDTH/4), 0, SCREEN_WIDTH/4, 60);
            separator.frame = CGRectMake((j-1)*(SCREEN_WIDTH/4), 0, 1, 60);
        }
    }
}


-(void)createCurrencyTypes{
    
    chooseCurrencyTypeView.hidden = NO;
    Currency *currency1 = [[Currency alloc] init];
    currency1.image = @"mnt_currency";
    currency1.name = @"MNT";
    currency1.itemid = [NSNumber numberWithInt:1];
    Currency *currency2 = [[Currency alloc] init];
    currency2.image = @"dollar_currency";
    currency2.name = @"USD";
    currency2.itemid = [NSNumber numberWithInt:2];
    Currency *currency3 = [[Currency alloc] init];
    currency3.image = @"currency_euro";
    currency3.name = @"EUR";
    currency3.itemid = [NSNumber numberWithInt:3];
    
//    [DATABASE_MANAGER writeToDatabase:@[currency1, currency2, currency3] toClass:[DBCurrency class] fetchedResultsController:nil];
//    
//    NSArray *dbActiveArray = [DATABASE_MANAGER searchObjectsForEntity:@"DBCurrency" withPredicate:nil andSortKey:@"itemid" andSortAscending:YES];
//    
//    NSArray *currArray = [DATABASE_MANAGER readFromDatabase:dbActiveArray toClass:[Currency class]];
    
    NSArray *currArray = @[currency1, currency2, currency3];
    self.currencyArray = [NSMutableArray array];
    for (Currency *currency in currArray) {
        [self.currencyArray addObject:currency.name];
    }
}

#pragma mark -
#pragma mark IBAction

-(void)menuButtonClicked:(UIButton *)button {
    
    if (previousSelectedMainMenuButton && previousSelectedMainMenuButton != button) {
        previousSelectedMainMenuButton.selected = NO;
    }
    button.selected = YES;
    [self changeMenuButtons:(int)button.tag];
    previousSelectedMainMenuButton = button;
    [self.centerController refreshController:(int)button.tag array:self];
    
}

#pragma mark - UIAction
- (void)currencySegmentedControlChanged:(UISegmentedControl *)segmentedControl {
    self.chooseCurrencyTypeView.hidden = YES;
    [USERDEF setValue:[self.currencyArray objectAtIndex:segmentedControl.selectedSegmentIndex] forKey:kSelectedCurrency];
}

#pragma mark -
#pragma mark Getters
-(UIView*)mainView {
    if (mainView==nil) {
        mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        //        mainView.backgroundColor = GRAY_COLOR;
    }
    return mainView;
}

- (UIView *)menuView {
    if (menuView == nil) {
        menuView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
        menuView.backgroundColor =  [[UIColor blueColor] colorWithAlphaComponent:0.1f];
        menuView.clipsToBounds = YES;
        menuView.userInteractionEnabled = YES;
        
        for (int  i = 0; i < 5; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*(SCREEN_WIDTH/5), 0, SCREEN_WIDTH/5, 60);
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            button.tag = i+1;
            [button setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
            button.imageView.clipsToBounds = YES;
            [button setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
//            CGSize titleSize = button.titleLabel.frame.size;
//            button.titleEdgeInsets = UIEdgeInsetsMake(43, -50, 0 , 0);
//            button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
//            titleSize = button.titleLabel.frame.size;
            
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            
            if (i == 0){
                [button setImage:[UIImage imageNamed:@"adress_button"] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:11];
//                [button setTitle:@"Home" forState:UIControlStateNormal];
            } else if (i == 1){
                [button setImage:[UIImage imageNamed:@"tab_plan"] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:11];
                [[button titleLabel] setTextAlignment:NSTextAlignmentCenter];
//                [button setTitle:@"Хадгалагдсан" forState:UIControlStateNormal];
                
            } else if (i == 2){
                [button setImage:[UIImage imageNamed:@"button_add"] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:11];
                
                [[button titleLabel] setTextAlignment:NSTextAlignmentCenter];
//                [button setTitle:@"Үг нэмэх" forState:UIControlStateNormal];
            } else if (i == 3){
                [button setImage:[UIImage imageNamed:@"tab_review"] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:11];
                
                [[button titleLabel] setTextAlignment:NSTextAlignmentCenter];
//                [button setTitle:@"Үг нэмэх" forState:UIControlStateNormal];
            }else{
                [button setImage:[UIImage imageNamed:@"tab_settings"] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:11];
                
                [[button titleLabel] setTextAlignment:NSTextAlignmentCenter];
//                [button setTitle:@"Онлайн" forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [menuView addSubview:button];
            {
                UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(button.bounds.size.width * i, 0, 1, button.bounds.size.height)];
                separator.tag = i + 11;
                separator.backgroundColor = [UIColor whiteColor];
                [menuView addSubview:separator];
            }
        }
    }
    return menuView;
}

- (UINavigationController *)navController {
    
    if (navController == nil) {
        
        centerController = [[CenterViewController alloc] initWithNibName:nil bundle:nil];
        centerController.view.backgroundColor = [UIColor whiteColor];
        navController = [[UINavigationController alloc] initWithRootViewController:centerController];
        navController.navigationBarHidden = YES;
        navController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60);
        navController.view.autoresizingMask = UIViewAutoresizingNone;
    }
    return navController;
}


-(UIView *)chooseCurrencyTypeView{
    if (chooseCurrencyTypeView == nil){
        chooseCurrencyTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        chooseCurrencyTypeView.backgroundColor = [UIColor whiteColor];
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, SCREEN_WIDTH - 80, 25)];
            label.text = @"Төлбөрийн нэгж";
            label.textAlignment = NSTextAlignmentLeft;
            [chooseCurrencyTypeView addSubview:label];
        }
    }
    return chooseCurrencyTypeView;
}

-(UISegmentedControl *)currencySegmentedControl{
    if (currencySegmentedControl == nil){
        currencySegmentedControl = [[UISegmentedControl alloc] initWithItems:self.currencyArray];
        currencySegmentedControl.frame = CGRectMake(40, 190, SCREEN_WIDTH - 80, 34);
        currencySegmentedControl.backgroundColor = [UIColor whiteColor];
        [currencySegmentedControl addTarget:self action:@selector(currencySegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
        currencySegmentedControl.tintColor = [UIColor blueColor];
        currencySegmentedControl.layer.cornerRadius = 5;
    }
    return currencySegmentedControl;
}

@end
