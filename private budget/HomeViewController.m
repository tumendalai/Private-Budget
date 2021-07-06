//
//  HomeViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "HomeViewController.h"
#import "TransactionTableViewCell.h"
#import "NSDate+CupertinoYankee.h"
#import "DBPlannedTransaction.h"
#import "WYPopoverController.h"
#import "ChooseDateController.h"
#import "NSDate+CupertinoYankee.h"
#import "DBCurrency.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, WYPopoverControllerDelegate>{
    UIButton *selectedButton;
    WYPopoverController* popoverController;
}

@property (nonatomic, strong) UITableView *transactionTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *endButton;
@property (nonatomic, strong) UILabel *firstStockLabel1;
@property (nonatomic, strong) UILabel *firstStockLabel2;
@property (nonatomic, strong) UILabel *endStockLabel1;
@property (nonatomic, strong) UILabel *endStockLabel2;

@end

@implementation HomeViewController

@synthesize transactionTableView;
@synthesize startButton;
@synthesize endButton;
@synthesize selected_start_date;
@synthesize selected_end_date;
@synthesize fetchedResultsController;
@synthesize firstStockLabel1;
@synthesize firstStockLabel2;
@synthesize endStockLabel1;
@synthesize endStockLabel2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selected_start_date = [[NSDate date] beginningOfMonth];
    selected_end_date = [[NSDate date] endOfMonth];
    [self getTransactions:selected_start_date  end:selected_end_date];
    [self set_button_title:selected_start_date button:startButton];
    [self set_button_title:selected_end_date button:endButton];
    [self.backButton setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - user
-(void)configureView{
    [super configureView];
    [self.view addSubview:self.transactionTableView];
    [self.headerView addSubview:self.startButton];
    [self.headerView addSubview:self.endButton];
    [self.view addSubview:self.firstStockLabel1];
    [self.view addSubview:self.firstStockLabel2];
    [self.view addSubview:self.endStockLabel1];
    [self.view addSubview:self.endStockLabel2];
}

-(void)getTransactions:(NSDate *)beginDate end:(NSDate*)endDate{
    
    // Perform Fetch
    NSError *error = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", beginDate, endDate];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    [self getLastStock:predicate];
    [self getFirstStock:beginDate];
    [self reload];
    [self check_planned_transaction_due_date];
}

-(void)check_planned_transaction_due_date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"d"];
    NSLocale *enUSLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:enUSLocale];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBPlannedTransaction"];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"start_date < %@ AND end_date > %@ AND day = %@", [NSDate date], [NSDate date],[NSNumber numberWithInt:[formatter stringFromDate:[NSDate date]].intValue]];
    [fetchRequest setPredicate:predicate];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    NSDate *todayDate = [NSDate date];
    NSDate *beginningOfMonth = [todayDate beginningOfMonth];
    NSDate *endOfMonth = [todayDate endOfMonth];
    
    if (!fetchError) {
        if (result.count > 0) {
            for (DBPlannedTransaction *planned_transaction in result){
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBTransaction"];
                
                
                // Create Predicate
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"amount = %@ AND receiver = %@ AND transaction_description = %@ AND is_income = %@ AND date > %@ AND date < %@",planned_transaction.amount, planned_transaction.receiver,planned_transaction.transaction_description,planned_transaction.is_income, beginningOfMonth, endOfMonth];
                [fetchRequest setPredicate:predicate];
                
                NSError *fetchError = nil;
                NSArray *transaction_array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
                
                if (!fetchError) {
                    if (!(transaction_array.count > 0)) {
                        NSEntityDescription *transaction_entity_desc = [NSEntityDescription entityForName:@"DBTransaction" inManagedObjectContext:self.managedObjectContext];
                        
                        DBTransaction *new_transaction = [[DBTransaction alloc] initWithEntity:transaction_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
                        
                        new_transaction.amount = planned_transaction.amount;
                        new_transaction.date = [NSDate date];
                        new_transaction.is_income = planned_transaction.is_income;
                        new_transaction.receiver = planned_transaction.receiver;
                        new_transaction.transaction_description = planned_transaction.transaction_description;
                        new_transaction.tran_category = planned_transaction.ptran_category;
                        new_transaction.tran_currency = planned_transaction.ptran_currency;
                        
                        NSError *error = nil;
                        if (![new_transaction.managedObjectContext save:&error]) {
                            NSLog(@"Unable to save managed object context.");
                            NSLog(@"%@, %@", error, error.localizedDescription);
                        }
                    }
                }
            }
        }
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }

}

-(void)reload{
    [self.transactionTableView reloadData];
}

-(void)getFirstStock:(NSDate *)beginDate{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBTransaction"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date < %@)",beginDate];
    [fetchRequest setPredicate:predicate];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSString *userFirstStock = [USERDEF valueForKey:kFirstStock];
    if (!userFirstStock) {
        userFirstStock = @"0";
    }
    if (!error) {
        if (result.count > 0) {
            double firstStock = 0;
            for (DBTransaction *transaction in result) {
                if (transaction.is_income.boolValue) {
                    firstStock += transaction.amount.doubleValue;
                } else {
                    firstStock -= transaction.amount.doubleValue;
                }
            }
            DBTransaction *firstTransaction = [result firstObject];
            
            self.firstStockLabel2.text = [NSString stringWithFormat:@"%.f%@",userFirstStock.doubleValue + firstStock,firstTransaction.tran_currency.symbol];
        } else {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBCurrency"];
            
            // Create Predicate
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [USERDEF stringForKey:kSelectedCurrency]];
            [fetchRequest setPredicate:predicate];
            
            // Execute Fetch Request
            NSError *fetchError = nil;
            NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
            
            DBCurrency *currentCurrency = nil;
            if (!fetchError) {
                currentCurrency = [result firstObject];
                self.firstStockLabel2.text = [NSString stringWithFormat:@"%.f%@",userFirstStock.doubleValue,currentCurrency.symbol];
            } else {
                NSLog(@"Error fetching data.");
                NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
            }
            
        }
    }
}

-(void)getLastStock:(NSPredicate*)predicate{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBTransaction"];
    [fetchRequest setPredicate:predicate];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        if (result.count > 0) {
            double endStock = 0;
            for (DBTransaction *transaction in result) {
                if (transaction.is_income.boolValue) {
                    endStock += transaction.amount.doubleValue;
                } else {
                    endStock -= transaction.amount.doubleValue;
                }
            }
            DBTransaction *firstTransaction = [result firstObject];
            self.endStockLabel2.text = [NSString stringWithFormat:@"%.f%@",endStock,firstTransaction.tran_currency.symbol];
        } else {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBCurrency"];
            
            // Create Predicate
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [USERDEF stringForKey:kSelectedCurrency]];
            [fetchRequest setPredicate:predicate];
            
            // Execute Fetch Request
            NSError *fetchError = nil;
            NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
            
            DBCurrency *currentCurrency = nil;
            if (!fetchError) {
                currentCurrency = [result firstObject];
                self.endStockLabel2.text = [NSString stringWithFormat:@"0%@",currentCurrency.symbol];
            } else {
                NSLog(@"Error fetching data.");
                NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
            }
            
        }
    }
}

-(void)showChooseDatePopover:(BOOL)is_date_picker{
    ChooseDateController *chooseDateController = [[ChooseDateController alloc] init];
    chooseDateController.preferredContentSize = CGSizeMake(300, 240);
    chooseDateController.is_date_picker = is_date_picker;
    chooseDateController.dateSelected = ^(NSDate *date){
        [popoverController dismissPopoverAnimated:YES];
        if (selectedButton == self.startButton) {
            selected_start_date = date;
        } else {
            selected_end_date = date;
        }
        [self getTransactions:[selected_start_date beginningOfDay] end:[selected_end_date endOfDay]];
        [self set_button_title:date button:selectedButton];
    };
    popoverController = [[WYPopoverController alloc] initWithContentViewController:chooseDateController];
    popoverController.delegate = self;
    [popoverController presentPopoverAsDialogAnimated:YES options:WYPopoverAnimationOptionScale];
}

-(void)set_button_title:(NSDate *)date button:(UIButton*)button{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLocale *enUSLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:enUSLocale];
    [button setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark WYPopoverController delegate
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}

#pragma mark -
#pragma mark Fetched Results Controller Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.transactionTableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.transactionTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.transactionTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.transactionTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:(TransactionTableViewCell *)[self.transactionTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.transactionTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.transactionTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

-(void)startButtonClicked:(UIButton *)button{
    selectedButton = button;
    [self showChooseDatePopover:YES];
}

-(void)endButtonClicked:(UIButton *)button{
    selectedButton = button;
    [self showChooseDatePopover:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TransactionTableViewCell";
    
    TransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TransactionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TransactionTableViewCell *)cell
    atIndexPath:(NSIndexPath *)indexPath
{
    cell.transaction = nil;
    cell.transaction = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell layoutSubviews];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Getter

- (UITableView *)transactionTableView {
    if (transactionTableView == nil) {
        transactionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, SCREEN_WIDTH, SCREEN_HEIGHT-95-75) style:UITableViewStylePlain];
        
        transactionTableView.backgroundColor = CLEAR_COLOR;
        transactionTableView.delegate = self;
        transactionTableView.dataSource = self;
    }
    return transactionTableView;
}

-(NSFetchedResultsController *)fetchedResultsController{
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBTransaction"];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [self.fetchedResultsController setDelegate:self];
    }
    return fetchedResultsController;
}

- (UIButton *)startButton {
    if (startButton == nil) {
        startButton = [[MyButton alloc] initWithFrame:CGRectMake(20, 29, SCREEN_WIDTH/2-30, 34)];
        startButton.titleLabel.font = FONT_NORMAL_SMALL;
        startButton.layer.cornerRadius = 4;
        startButton.layer.borderWidth = 1;
        [startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return startButton;
}

- (UIButton *)endButton {
    if (endButton == nil) {
        endButton = [[MyButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+15, 29, SCREEN_WIDTH/2-30, 34)];
        endButton.layer.cornerRadius = 4;
        endButton.layer.borderWidth = 1;
        endButton.titleLabel.font = FONT_NORMAL_SMALL;
        [endButton addTarget:self action:@selector(endButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return endButton;
}

- (UILabel *)firstStockLabel1 {
    if (firstStockLabel1 == nil) {
        firstStockLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH/2, 15)];
        firstStockLabel1.backgroundColor = CLEAR_COLOR;
        firstStockLabel1.textColor = BLACK_COLOR;
        firstStockLabel1.font = FONT_NORMAL_SMALLER;
        firstStockLabel1.numberOfLines = 2;
        firstStockLabel1.textAlignment = NSTextAlignmentRight;
        firstStockLabel1.text = @"Эхний үлдэгдэл:";
    }
    return firstStockLabel1;
}

- (UILabel *)firstStockLabel2 {
    if (firstStockLabel2 == nil) {
        firstStockLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10 + SCREEN_WIDTH/2, 75, SCREEN_WIDTH/2 - 10, 15)];
        firstStockLabel2.backgroundColor = CLEAR_COLOR;
        firstStockLabel2.textColor = BLACK_COLOR;
        firstStockLabel2.font = FONT_NORMAL_SMALLER;
        firstStockLabel2.textAlignment = NSTextAlignmentLeft;
        firstStockLabel2.numberOfLines = 2;
    }
    return firstStockLabel2;
}

- (UILabel *)endStockLabel1 {
    if (endStockLabel1 == nil) {
        endStockLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-70, SCREEN_WIDTH/2, 15)];
        endStockLabel1.backgroundColor = CLEAR_COLOR;
        endStockLabel1.textColor = BLACK_COLOR;
        endStockLabel1.font = FONT_NORMAL_SMALLER;
        endStockLabel1.numberOfLines = 2;
        endStockLabel1.textAlignment = NSTextAlignmentRight;
        endStockLabel1.text = @"Үлдэгдэл:";
    }
    return endStockLabel1;
}

- (UILabel *)endStockLabel2 {
    if (endStockLabel2 == nil) {
        endStockLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, SCREEN_HEIGHT-70, SCREEN_WIDTH/2 - 10, 15)];
        endStockLabel2.backgroundColor = CLEAR_COLOR;
        endStockLabel2.textColor = BLACK_COLOR;
        endStockLabel2.font = FONT_NORMAL_SMALLER;
        endStockLabel2.textAlignment = NSTextAlignmentLeft;
        endStockLabel2.numberOfLines = 2;
    }
    return endStockLabel2;
}

@end
