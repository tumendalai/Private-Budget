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
#import "DBCategory.h"
#import "DBTransaction.h"

@interface AppDelegate ()<UITabBarControllerDelegate>
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) AddTransactionViewController *addTransViewController;
@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, strong) UIView *chooseCurrencyView;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UISegmentedControl *currencySegmentedControl;
@property (nonatomic, strong) NSMutableArray *currencyArray;
@property (nonatomic, strong) UITextField *passTextfield;
@property (nonatomic, strong) UITextField *firstStockTextfield;
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
@synthesize firstStockTextfield;
@synthesize homeViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    tabBarController.delegate = self;

    homeViewController = [[HomeViewController alloc] init];
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
    [settingsViewController setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    controllerArray = [NSMutableArray arrayWithObjects:
                            homeViewController,
                            plannedNavController,
                            addTransViewController,
                            reportViewController,
                            settingsViewController, nil];
    
    tabBarController.viewControllers = controllerArray;
//    [USERDEF setValue:@"1234" forKey:kPassword];
    
//    [self.tabBarController.view addSubview:self.loginView];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    [self loginButtonClicked];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self saveContext];
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
        if ([viewController isKindOfClass:[HomeViewController class]]) {
            HomeViewController *homeController = (HomeViewController*)viewController;
            [homeController getTransactions:homeController.selected_start_date end:homeController.selected_end_date];
        }
    } else if([viewController isKindOfClass:[UINavigationController class]] || [viewController isKindOfClass:[ReportViewController class]] || [viewController isKindOfClass:[SettingsViewController class]]) {
        if ([self.tabBarController.viewControllers containsObject:self.addTransViewController]) {
            NSMutableArray *newTabs = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
            [newTabs removeObject:self.addTransViewController];
            [UIView animateWithDuration:0.3f animations:^{
                [self.tabBarController setViewControllers:newTabs];
            } completion:nil];
        }
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav_controller = (UINavigationController *)viewController;
            for (UIViewController *view_controller in nav_controller.viewControllers) {
                if ([view_controller isKindOfClass:[PlannedTransactionViewController class]]) {
                    PlannedTransactionViewController *planned_transaction_controller = (PlannedTransactionViewController*)view_controller;
                    [planned_transaction_controller getPlannedTransactions];
                    [planned_transaction_controller reload];
                }
                if ([view_controller isKindOfClass:[AddPlannedTransactionViewController class]]) {
                    AddPlannedTransactionViewController *planned_transaction_controller = (AddPlannedTransactionViewController*)view_controller;
                    [planned_transaction_controller reload];
                }
            }
        }
        if ([viewController isKindOfClass:[ReportViewController class]]) {
            ReportViewController *reportViewController = (ReportViewController*)viewController;
            [reportViewController makePieChart];
        }
    }
}

#pragma mark - UIAction
- (void)currencySegmentedControlChanged:(UISegmentedControl *)segmentedControl {
    [USERDEF setValue:[self.currencyArray objectAtIndex:segmentedControl.selectedSegmentIndex] forKey:kSelectedCurrency];
}

-(void)loginButtonClicked{
//    NSString *password = self.passTextfield.text;
//    if (password && password.length){
//        if ([[USERDEF valueForKey:kPassword] isEqualToString:password]) {
//            self.loginView.hidden = YES;
            [self chooseCurrency];
//            [self.tabBarController.view endEditing:YES];
//        } else {
//            self.passTextfield.text = @"";
//        }
//    } else {
//        // Show Alert View
//        [[[UIAlertView alloc] initWithTitle:@"Анхаар" message:@"Нууц үгээ оруулна уу!" delegate:nil cancelButtonTitle:@"За" otherButtonTitles:nil] show];
//    }
}

-(void)doneButtonClicked{
    if (![USERDEF valueForKey:kSelectedCurrency]) {
        [[[UIAlertView alloc] initWithTitle:@"Анхаар" message:@"Төлбөрийн нэгж сонгогдоогүй байна!" delegate:nil cancelButtonTitle:@"За" otherButtonTitles:nil] show];
        return;
    }
    if (self.firstStockTextfield.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Анхаар" message:@"Эхний үлдэгдэл оруулна уу!" delegate:nil cancelButtonTitle:@"За" otherButtonTitles:nil] show];
        return;
    } else {
        [USERDEF setValue:self.firstStockTextfield.text forKey:kFirstStock];
    }
    [self createDefaultCategories];
    self.chooseCurrencyView.hidden = YES;
    [self.tabBarController.view endEditing:YES];
    [homeViewController getTransactions:homeViewController.selected_start_date end:homeViewController.selected_end_date];
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
        [self.currencySegmentedControl setSelectedSegmentIndex:-1];
        [self.chooseCurrencyView addSubview:self.currencySegmentedControl];
    }
}

-(void)createDefaultCategories{
    NSEntityDescription *category_entity_desc = [NSEntityDescription entityForName:@"DBCategory" inManagedObjectContext:self.managedObjectContext];
    NSEntityDescription *transaction_entity_desc = [NSEntityDescription entityForName:@"DBTransaction" inManagedObjectContext:self.managedObjectContext];
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBCurrency"];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [USERDEF stringForKey:kSelectedCurrency]];
    [fetchRequest setPredicate:predicate];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    DBCurrency *currency = nil;
    
    if (!fetchError) {
        currency = [result firstObject];
    }
    
    {
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Машин";
        category.image = @"cat_car";
        category.income = @(0);
        
        DBTransaction *newTransaction = [[DBTransaction alloc] initWithEntity:transaction_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        
        newTransaction.amount =[NSNumber numberWithDouble:1000];
        newTransaction.date =[NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:[NSDate date]];
        newTransaction.is_income = category.income;
        newTransaction.receiver = @"Төгөлдөр";
        newTransaction.transaction_description = @"өгөх";
        newTransaction.tran_currency = currency;
        
        [category addTransactionObject:newTransaction];
        
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Хувцас";
        category.image = @"cat_clothes";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Боловсрол";
        category.image = @"cat_education";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Үзвэр";
        category.image = @"cat_entertainment";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Хоол";
        category.image = @"cat_food";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Зугаа";
        category.image = @"cat_fun";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Бэлэг";
        category.image = @"cat_gift";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Гэр ахуй";
        category.image = @"cat_household";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Эм";
        category.image = @"cat_medicine";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Байрны зээл";
        category.image = @"cat_mortgage";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Хувийн";
        category.image = @"cat_personal";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    {
        error = nil;
        DBCategory *category = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
        category.name = @"Тээвэр";
        category.image = @"cat_transport";
        category.income = @(0);
        if (![category.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
}

-(void)createCurrencyTypes{
    
    chooseCurrencyView.hidden = NO;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
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
        
        {
            UITextField *firstTextField = [[MyTextField alloc] initWithFrame:CGRectMake(40, 250, SCREEN_WIDTH-80, 30)];
            firstTextField.placeholder = @"Эхний үлдэгдэл";
            firstTextField.font = FONT_NORMAL_SMALL;
            firstTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.firstStockTextfield = firstTextField;
            [chooseCurrencyView addSubview:firstTextField];
        }
        {
            UIButton *doneButton = [MyButton buttonWithType:UIButtonTypeCustom];
            doneButton.frame = CGRectMake(50, 300, SCREEN_WIDTH-100, 34);
            [doneButton setTitle:@"Болсон" forState:UIControlStateNormal];
            doneButton.layer.borderWidth = 1;
            doneButton.layer.cornerRadius = 5;
            doneButton.titleLabel.font = FONT_NORMAL_SMALL;
            [doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [chooseCurrencyView addSubview:doneButton];
        }
    }
    return chooseCurrencyView;
}

-(UIView*)loginView{
    if (loginView == nil) {
        loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        loginView.backgroundColor = [UIColor whiteColor];
        {
            UITextField *passwordTextfield = [[MyTextField alloc] initWithFrame:CGRectMake(40, SCREEN_HEIGHT/2-30, SCREEN_WIDTH-80, 30)];
            passwordTextfield.placeholder = @"Нууц үг";
            passwordTextfield.font = FONT_NORMAL_SMALL;
            passwordTextfield.keyboardType = UIKeyboardTypeNumberPad;
            self.passTextfield = passwordTextfield;
            [loginView addSubview:passwordTextfield];
        }
        {
            UIButton *loginButton = [MyButton buttonWithType:UIButtonTypeCustom];
            loginButton.frame = CGRectMake(50, SCREEN_HEIGHT/2+10, SCREEN_WIDTH-100, 34);
            [loginButton setTitle:@"Нэвтрэх" forState:UIControlStateNormal];
            loginButton.layer.borderWidth = 1;
            loginButton.layer.cornerRadius = 5;
            loginButton.titleLabel.font = FONT_NORMAL_SMALL;
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
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:FONT_NORMAL_SMALL
                                                               forKey:NSFontAttributeName];
        [currencySegmentedControl setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
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
    _managedObjectContext.stalenessInterval = 0;
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
