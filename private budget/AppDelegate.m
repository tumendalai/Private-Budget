//
//  AppDelegate.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "PlannedTransactionViewController.h"
#import "ReportViewController.h"
#import "SettingsViewController.h"
#import "AddTransactionViewController.h"
#import "DBCurrency.h"

@interface AppDelegate ()<UITabBarControllerDelegate>
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) AddTransactionViewController *addTransViewController;
@property (nonatomic, strong) UIView *chooseCurrencyView;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UISegmentedControl *currencySegmentedControl;
@property (nonatomic, strong) NSMutableArray *currencyArray;
@property (nonatomic, strong) UITextField *passTextfield;
@property (nonatomic, strong) NSMutableArray *controllerArray;

@end

@implementation AppDelegate
@synthesize tabBarController;
@synthesize addTransViewController;
@synthesize chooseCurrencyView;
@synthesize loginView;
@synthesize currencySegmentedControl;
@synthesize passTextfield;
@synthesize controllerArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    tabBarController.delegate = self;

    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    PlannedTransactionViewController* plannedTransactionViewController = [[PlannedTransactionViewController alloc] init];
    self.addTransViewController = [[AddTransactionViewController alloc] init];
    ReportViewController* reportViewController = [[ReportViewController alloc] init];
    SettingsViewController* settingsViewController = [[SettingsViewController alloc] init];
    
    UINavigationController *plannedNavController = [[UINavigationController alloc] initWithRootViewController:plannedTransactionViewController];
    plannedNavController.navigationBarHidden = YES;
    
    homeViewController.title = @"Home";
    plannedTransactionViewController.title = @"Plan";
    addTransViewController.title = @"Add";
    reportViewController.title =@"Report";
    settingsViewController.title =@"Settings";
    
    [homeViewController.tabBarItem setImage:[UIImage imageNamed:@"adress_button"]];
    [plannedNavController.tabBarItem setImage:[UIImage imageNamed:@"tab_plan"]];
    [addTransViewController.tabBarItem setImage:[UIImage imageNamed:@"button_add"]];
    [reportViewController.tabBarItem setImage:[UIImage imageNamed:@"tab_review"]];
    [settingsViewController.tabBarItem setImage:[UIImage imageNamed:@"tab_settings"]];
    
    [homeViewController setManagedObjectContext:self.managedObjectContext];
    [plannedTransactionViewController setManagedObjectContext:self.managedObjectContext];
    [addTransViewController setManagedObjectContext:self.managedObjectContext];
    [reportViewController setManagedObjectContext:self.managedObjectContext];
    [settingsViewController setManagedObjectContext:self.managedObjectContext];
    
    controllerArray = [NSMutableArray arrayWithObjects:
                            homeViewController,
                            plannedNavController,
                            addTransViewController,
                            reportViewController,
                            settingsViewController, nil];
    
    tabBarController.viewControllers = controllerArray;
    [USERDEF setValue:@"1234" forKey:kPassword];
    
//    [self.tabBarController.view addSubview:self.loginView];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - UITabBarController delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[AddTransactionViewController class]] || [viewController isKindOfClass:[HomeViewController class]]) {
        if (![self.tabBarController.viewControllers containsObject:self.addTransViewController]) {
            NSMutableArray *newTabs = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
            [newTabs insertObject:self.addTransViewController atIndex:2];
            [UIView animateWithDuration:0.3f animations:^{
                [self.tabBarController setViewControllers:newTabs];
            } completion:nil];
        }
    } else if([viewController isKindOfClass:[UINavigationController class]] || [viewController isKindOfClass:[ReportViewController class]] || [viewController isKindOfClass:[SettingsViewController class]]) {
        if ([self.tabBarController.viewControllers containsObject:self.addTransViewController]) {
            NSMutableArray *newTabs = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
            [newTabs removeObject:self.addTransViewController];
            [UIView animateWithDuration:0.3f animations:^{
                [self.tabBarController setViewControllers:newTabs];
            } completion:nil];
        }
    }
}

#pragma mark - UIAction
- (void)currencySegmentedControlChanged:(UISegmentedControl *)segmentedControl {
    self.chooseCurrencyView.hidden = YES;
    [USERDEF setValue:[self.currencyArray objectAtIndex:segmentedControl.selectedSegmentIndex] forKey:kSelectedCurrency];
}

-(void)loginButtonClicked{
    NSString *password = self.passTextfield.text;
    if (password && password.length){
        if ([[USERDEF valueForKey:kPassword] isEqualToString:password]) {
            self.loginView.hidden = YES;
            [self chooseCurrency];
        } else {
            self.passTextfield.text = @"";
        }
    } else {
        // Show Alert View
        [[[UIAlertView alloc] initWithTitle:@"Анхаар" message:@"Нууц үгээ оруулна уу!" delegate:nil cancelButtonTitle:@"За" otherButtonTitles:nil] show];
    }
}

#pragma mark - Users

-(void)chooseCurrency{
    if ([USERDEF valueForKey:kSelectedCurrency] == nil) {
        NSEntityDescription *currency_entity_desc = [NSEntityDescription entityForName:@"DBCurrency" inManagedObjectContext:self.managedObjectContext];
        
        DBCurrency *currency1 = [[DBCurrency alloc] initWithEntity:currency_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        currency1.image = @"mnt_currency";
        currency1.name = @"MNT";
        currency1.symbol = @"₮";
        
        DBCurrency *currency2 = [[DBCurrency alloc] initWithEntity:currency_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        currency2.image = @"dollar_currency";
        currency2.name = @"USD";
        currency2.symbol = @"$";
        
        DBCurrency *currency3 = [[DBCurrency alloc] initWithEntity:currency_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        currency3.image = @"currency_euro";
        currency3.name = @"EUR";
        currency3.symbol = @"€";
        
        NSError *error = nil;
        
        if (![currency1.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        error = nil;
        if (![currency2.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        error = nil;
        if (![currency3.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        
        // Currency
        [self.tabBarController.view addSubview:self.chooseCurrencyView];
        [self createCurrencyTypes];
        [self.chooseCurrencyView addSubview:self.currencySegmentedControl];
    }
}

-(void)createCurrencyTypes{
    
    chooseCurrencyView.hidden = NO;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DBCurrency" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        if (result.count > 0) {
            self.currencyArray = [NSMutableArray array];
            for (DBCurrency *currency in result) {
                [self.currencyArray addObject:currency.name];
            }
        }
    }
}

#pragma mark - Getters

-(UIView*)chooseCurrencyView{
    if (chooseCurrencyView == nil) {
        chooseCurrencyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        chooseCurrencyView.backgroundColor = [UIColor whiteColor];
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, SCREEN_WIDTH - 80, 25)];
            label.text = @"Төлбөрийн нэгж";
            label.textAlignment = NSTextAlignmentLeft;
            [chooseCurrencyView addSubview:label];
        }
    }
    return chooseCurrencyView;
}

-(UIView*)loginView{
    if (loginView == nil) {
        loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        loginView.backgroundColor = [UIColor whiteColor];
        {
            UITextField *passwordTextfield = [[UITextField alloc] initWithFrame:CGRectMake(40, SCREEN_HEIGHT/2-30, SCREEN_WIDTH-80, 25)];
            passwordTextfield.layer.borderColor = [UIColor blackColor].CGColor;
            passwordTextfield.layer.borderWidth = 0.5f;
            passwordTextfield.placeholder = @"Нууц үг";
            self.passTextfield = passwordTextfield;
            [loginView addSubview:passwordTextfield];
        }
        {
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            loginButton.frame = CGRectMake(50, SCREEN_HEIGHT/2, SCREEN_WIDTH-100, 25);
            [loginButton setTitle:@"Нэвтрэх" forState:UIControlStateNormal];
            loginButton.layer.borderWidth = 0.5f;
            loginButton.layer.borderColor = [UIColor blackColor].CGColor;
            [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [loginView addSubview:loginButton];
        }
    }
    return loginView;
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

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "tugi.private_budget" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"private_budget" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"private_budget.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
