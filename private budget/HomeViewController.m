//
//  HomeViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "HomeViewController.h"
#import "Transaction.h"
#import "Currency.h"
#import "TransactionTableViewCell.h"
#import "CategoryObject.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSArray *thisMonthTransactionArray;
@property (nonatomic, strong) UITableView *thisMonthTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation HomeViewController

@synthesize thisMonthTableView;
@synthesize thisMonthTransactionArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self getThisMonthTransactions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - user
-(void)configureView{
    [super configureView];
    [self.view addSubview:self.thisMonthTableView];
}

-(void)getThisMonthTransactions{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBTransaction"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
//    Transaction *transaction = [[Transaction alloc] init];
//    transaction.amount = @"800000";
//    transaction.category_id = @"1";
//    transaction.currency_id = @"1";
//    transaction.date = @"2015-12-31 00:00:00";
//    transaction.itemid = @"1";
//    transaction.reciever = @"Төгөлдөр";
//    transaction.transaction_description = @"Сарын цалин";
//    transaction.is_income = @"1";
//    
//    Transaction *transaction1 = [[Transaction alloc] init];
//    transaction1.amount = @"1800000";
//    transaction1.category_id = @"1";
//    transaction1.currency_id = @"1";
//    transaction1.date = @"2015-12-31 00:00:00";
//    transaction1.itemid = @"1";
//    transaction1.reciever = @"Төгөлдөр";
//    transaction1.transaction_description = @"Сургалтын төлбөр";
//    transaction1.is_income = @"0";
//    
//    thisMonthTransactionArray = @[transaction,transaction1,transaction,transaction1,transaction,transaction,transaction1,transaction,transaction1,transaction,transaction,transaction1,transaction,transaction1,transaction];
//    
//    [self.thisMonthTableView reloadData];
    
}

#pragma mark -
#pragma mark Fetched Results Controller Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.thisMonthTableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.thisMonthTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.thisMonthTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.thisMonthTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:(TransactionTableViewCell *)[self.thisMonthTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.thisMonthTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.thisMonthTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
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

- (UITableView *)thisMonthTableView {
    if (thisMonthTableView == nil) {
        thisMonthTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStylePlain];
        
        thisMonthTableView.backgroundColor = CLEAR_COLOR;
        thisMonthTableView.delegate = self;
        thisMonthTableView.dataSource = self;
    }
    return thisMonthTableView;
}

@end
