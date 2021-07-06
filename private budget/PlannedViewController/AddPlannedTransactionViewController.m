//
//  ConstViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "AddPlannedTransactionViewController.h"
#import "PlannedTransactionTableViewCell.h"
#import "CategoryCell.h"
#import "DBCategory.h"
#import "WYPopoverController.h"
#import "ChooseDateController.h"
#import "DBPlannedTransaction.h"

@interface AddPlannedTransactionViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, WYPopoverControllerDelegate>{
    WYPopoverController* popoverController;
}

@property (strong, nonatomic) NSFetchedResultsController *plannedFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *categoryFetchedResultsController;
@property (strong, nonatomic) NSMutableArray *sectionChanges;
@property (strong, nonatomic) NSMutableArray *itemChanges;
@property (strong, nonatomic) UIButton *selectedButton;
@property (strong, nonatomic) NSDate  *selected_start_date;
@property (strong, nonatomic) NSDate *selected_end_date;
@property (strong, nonatomic) NSNumber *selected_day;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@end

@implementation AddPlannedTransactionViewController

@synthesize plannedTransactionArray;
@synthesize plannedTransactionsTableView;
@synthesize saveButton;
@synthesize pScrollView;
@synthesize descriptionTextfield;
@synthesize receiverTextfield;
@synthesize amountTextfield;
@synthesize dueDateButton;
@synthesize startButton;
@synthesize endButton;
@synthesize endLabel;
@synthesize startLabel;
@synthesize catCollectionView;
@synthesize dueDateLabel;
@synthesize selectedItemIndexPath;
@synthesize sectionChanges;
@synthesize itemChanges;
@synthesize selectedButton;
@synthesize selected_end_date;
@synthesize selected_start_date;
@synthesize selected_day;
@synthesize tap;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self getCategories];
    [self getPlannedTransactions];
    [self refresh_data];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.view removeGestureRecognizer:self.tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureView{
    [super configureView];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.pScrollView];
    [self.pScrollView addSubview:self.plannedTransactionsTableView];
    [self.pScrollView addSubview:self.descriptionTextfield];
    [self.pScrollView addSubview:self.receiverTextfield];
    [self.pScrollView addSubview:self.amountTextfield];
    [self.pScrollView addSubview:self.dueDateLabel];
    [self.pScrollView addSubview:self.dueDateButton];
    [self.pScrollView addSubview:self.startButton];
    [self.pScrollView addSubview:self.startLabel];
    [self.pScrollView addSubview:self.endButton];
    [self.pScrollView addSubview:self.endLabel];
    [self.pScrollView addSubview:self.catCollectionView];
    
    self.pScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 670);
}

#pragma mark -
#pragma mark KeyboardDelegate
#pragma mark -
- (void)keyboardDidShow: (NSNotification *) notif {
    [self.view addGestureRecognizer:self.tap];
    
    // Do something here
    UIScrollView *scrollView = self.pScrollView;
    
    NSDictionary *userInfo = [notif userInfo];
    
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *keyboardEndRectObject = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndRectObject getValue:&keyboardEndRect];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    keyboardEndRect = [self.view convertRect:keyboardEndRect fromView:window];
    
    [UIView beginAnimations:@"changeTableViewContentInset" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    
    CGRect intersectionOfKeyboardRectAndWindowRect = CGRectIntersection(window.frame, keyboardEndRect);
    CGFloat bottomInset = intersectionOfKeyboardRectAndWindowRect.size.height;
    scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);
    
    [UIView commitAnimations];
}

- (void)keyboardDidHide: (NSNotification *) notif {
    [self.view removeGestureRecognizer:self.tap];
    
    // Do something here
    UIScrollView *scrollView = self.pScrollView;
    
    if (UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, UIEdgeInsetsZero))
        return;
    
    NSDictionary *userInfo = [notif userInfo];
    
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *keyboardEndRectObject = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndRectObject getValue:&keyboardEndRect];
    
    [UIView beginAnimations:@"changeTableViewContentInset" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    
    scrollView.contentInset = UIEdgeInsetsZero;
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark User

-(void)getPlannedTransactions{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBPlannedTransaction"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]]];
    
    // Initialize Fetched Results Controller
    self.plannedFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.plannedFetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.plannedFetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}


- (void)getCategories {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBCategory"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    // Initialize Fetched Results Controller
    self.categoryFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.categoryFetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.categoryFetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

#pragma mark -
#pragma mark UIAction

-(void)saveButtonClicked:(UIButton *)button{
    if (![self formValidation]) {
        return;
    }
    
    NSEntityDescription *planned_transaction_entity_desc = [NSEntityDescription entityForName:@"DBPlannedTransaction" inManagedObjectContext:self.managedObjectContext];
    
    DBCategory *category = [self.categoryFetchedResultsController objectAtIndexPath:selectedItemIndexPath];
    
    DBPlannedTransaction *new_planned_transaction = [[DBPlannedTransaction alloc] initWithEntity:planned_transaction_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
    
    new_planned_transaction.amount =[NSNumber numberWithDouble:self.amountTextfield.text.doubleValue];
    new_planned_transaction.start_date = selected_start_date;
    new_planned_transaction.end_date = selected_end_date;
    new_planned_transaction.day = selected_day;
    new_planned_transaction.is_income = category.income;
    new_planned_transaction.receiver = self.receiverTextfield.text;
    new_planned_transaction.transaction_description = self.descriptionTextfield.text;
    new_planned_transaction.ptran_category = category;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBCurrency"];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [USERDEF stringForKey:kSelectedCurrency]];
    [fetchRequest setPredicate:predicate];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        new_planned_transaction.ptran_currency = [result firstObject];
        
        NSError *error = nil;
        
        if (![new_planned_transaction.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        } else {
            [self refresh_data];
        }
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
}

-(void)dueButtonClicked:(UIButton *)button{
    selectedButton = button;
    [self showChooseDatePopover:NO];
}

-(void)startButtonClicked:(UIButton *)button{
    selectedButton = button;
    [self showChooseDatePopover:YES];
}

-(void)endButtonClicked:(UIButton *)button{
    selectedButton = button;
    [self showChooseDatePopover:YES];
}

#pragma mark - tap
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark User

- (BOOL)formValidation {
    if (selectedItemIndexPath == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Анхаар" message:@"Ангилал сонгоогүй байна!" delegate:nil cancelButtonTitle:@"За" otherButtonTitles:nil] show];
        return NO;
    }
    if (self.amountTextfield.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Анхаар" message:@"Мөнгөн дүн оруулна уу!" delegate:nil cancelButtonTitle:@"За" otherButtonTitles:nil] show];
        return NO;
    }
    if (self.descriptionTextfield.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Анхаар" message:@"Утга оруулна уу!" delegate:nil cancelButtonTitle:@"За" otherButtonTitles:nil] show];
        return NO;
    }
    if (self.receiverTextfield.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Анхаар" message:@"Хүлээн авагч оруулна уу!" delegate:nil cancelButtonTitle:@"За" otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

-(void)reload{
    [self.tableView reloadData];
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
        [self set_button_title:date button:selectedButton];
    };
    chooseDateController.daySelected = ^(NSNumber *day){
        [popoverController dismissPopoverAnimated:YES];
        selected_day = day;
        [selectedButton setTitle:[NSString stringWithFormat:@"%@",day] forState:UIControlStateNormal];
    };
    popoverController = [[WYPopoverController alloc] initWithContentViewController:chooseDateController];
    popoverController.delegate = self;
    [popoverController presentPopoverAsDialogAnimated:YES options:WYPopoverAnimationOptionScale];
}

-(void)refresh_data{
    selectedItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *sections = [self.categoryFetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:0];
    if([sectionInfo numberOfObjects] > 0)
        [self.catCollectionView selectItemAtIndexPath:selectedItemIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
    
    selected_end_date = selected_start_date = [NSDate date];
    selected_day = [NSNumber numberWithInt:1];
    
    self.descriptionTextfield.text = self.receiverTextfield.text = self.amountTextfield.text = @"";
    
    [self.dueDateButton setTitle:[NSString stringWithFormat:@"%@",selected_day] forState:UIControlStateNormal];
    [self set_button_title:selected_start_date button:self.startButton];
    [self set_button_title:selected_end_date button:self.endButton];
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
    if (controller == self.plannedFetchedResultsController) {
        [self.plannedTransactionsTableView beginUpdates];
    } else {
        sectionChanges = [[NSMutableArray alloc] init];
        itemChanges = [[NSMutableArray alloc] init];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (controller == self.plannedFetchedResultsController) {
        [self.plannedTransactionsTableView endUpdates];
    } else {
        [self.catCollectionView performBatchUpdates:^{
            for (NSDictionary *change in sectionChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch(type) {
                        case NSFetchedResultsChangeInsert:
                            [self.catCollectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.catCollectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            break;
                        case NSFetchedResultsChangeMove:
                            break;
                    }
                }];
            }
            for (NSDictionary *change in itemChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch(type) {
                        case NSFetchedResultsChangeInsert:
                            [self.catCollectionView insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.catCollectionView deleteItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.catCollectionView reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [self.catCollectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                    }
                }];
            }
        } completion:^(BOOL finished) {
            sectionChanges = nil;
            itemChanges = nil;
        }];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if (controller == self.plannedFetchedResultsController) {
    } else {
        NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
        change[@(type)] = @(sectionIndex);
        [sectionChanges addObject:change];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (controller == self.plannedFetchedResultsController) {
        switch (type) {
            case NSFetchedResultsChangeInsert: {
                [self.plannedTransactionsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
            case NSFetchedResultsChangeDelete: {
                [self.plannedTransactionsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
            case NSFetchedResultsChangeUpdate: {
                [self configureCell:(PlannedTransactionTableViewCell *)[self.plannedTransactionsTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
            }
            case NSFetchedResultsChangeMove: {
                [self.plannedTransactionsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.plannedTransactionsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    } else {
        
        NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
        switch(type) {
            case NSFetchedResultsChangeInsert:
                change[@(type)] = newIndexPath;
                break;
            case NSFetchedResultsChangeDelete:
                change[@(type)] = indexPath;
                break;
            case NSFetchedResultsChangeUpdate:
                change[@(type)] = indexPath;
                break;
            case NSFetchedResultsChangeMove:
                change[@(type)] = @[indexPath, newIndexPath];
                break;
        }
        [itemChanges addObject:change];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.plannedFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.plannedFetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlannedTransactionTableViewCell";
    
    PlannedTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PlannedTransactionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    cell.indexPath = indexPath;
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(PlannedTransactionTableViewCell *)cell
    atIndexPath:(NSIndexPath *)indexPath
{
    cell.transaction = nil;
    cell.transaction = [self.plannedFetchedResultsController objectAtIndexPath:indexPath];
    
    [cell layoutSubviews];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSArray *sections = [self.categoryFetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    [self configureCell:cell forItemAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(CategoryCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBCategory *category = [self.categoryFetchedResultsController objectAtIndexPath:indexPath];
    cell.category = category;
    cell.smallImageView.alpha = 0.6f;
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame) {
        cell.smallImageView.alpha = 1.0f;
    }
    [cell layoutSubviews];
}

#pragma mark -
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            self.selectedItemIndexPath = nil;
        } else {
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    } else {
        
        self.selectedItemIndexPath = indexPath;
    }
    
    [collectionView reloadData];
}

#pragma mark -
#pragma mark Getters

- (UIScrollView *)pScrollView {
    if (pScrollView == nil) {
        pScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-60)];
        pScrollView.backgroundColor = CLEAR_COLOR;
        pScrollView.delegate = self;
        pScrollView.showsVerticalScrollIndicator = NO;
        pScrollView.showsHorizontalScrollIndicator = NO;
        pScrollView.decelerationRate = 0.1f;
        pScrollView.pagingEnabled = NO;
        pScrollView.alwaysBounceVertical = YES;
    }
    return pScrollView;
}

-(UITapGestureRecognizer *)tap{
    if (tap == nil) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    }
    return tap;
}

- (UITableView *)plannedTransactionsTableView {
    if (plannedTransactionsTableView == nil) {
        plannedTransactionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230) style:UITableViewStylePlain];
        plannedTransactionsTableView.backgroundColor = CLEAR_COLOR;
        plannedTransactionsTableView.delegate = self;
        plannedTransactionsTableView.dataSource = self;
    }
    return plannedTransactionsTableView;
}

- (UIButton *)saveButton {
    if (saveButton == nil) {
        saveButton = [[MyButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-114, 25, 100, 34)];
        [saveButton setTitle:@"Хадгалах" forState:UIControlStateNormal];
        saveButton.layer.borderWidth = 1;
        saveButton.layer.cornerRadius = 4;
        saveButton.titleLabel.font = FONT_NORMAL_SMALL;
        [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return saveButton;
}

- (UITextField *)descriptionTextfield {
    if (descriptionTextfield == nil) {
        descriptionTextfield = [[MyTextField alloc] initWithFrame:CGRectMake(20, 240, SCREEN_WIDTH-40, 30)];
        descriptionTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        descriptionTextfield.backgroundColor = [UIColor whiteColor];
        descriptionTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        descriptionTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        descriptionTextfield.font = FONT_NORMAL_SMALL;
        descriptionTextfield.placeholder = @"Утга";
    }
    return descriptionTextfield;
}

- (UITextField *)receiverTextfield {
    if (receiverTextfield == nil) {
        receiverTextfield = [[MyTextField alloc] initWithFrame:CGRectMake(20, 285, SCREEN_WIDTH-40, 30)];
        receiverTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        receiverTextfield.backgroundColor = [UIColor whiteColor];
        receiverTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        receiverTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        receiverTextfield.font = FONT_NORMAL_SMALL;
        receiverTextfield.placeholder = @"Хэнд";
    }
    return receiverTextfield;
}

- (UITextField *)amountTextfield {
    if (amountTextfield == nil) {
        amountTextfield = [[MyTextField alloc] initWithFrame:CGRectMake(20, 330, SCREEN_WIDTH-40, 30)];
        amountTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        amountTextfield.backgroundColor = [UIColor whiteColor];
        amountTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        amountTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        amountTextfield.keyboardType = UIKeyboardTypeNumberPad;
        amountTextfield.font = FONT_NORMAL_SMALL;
        amountTextfield.placeholder = @"Дүн";
    }
    return amountTextfield;
}

- (UILabel *)dueDateLabel {
    if (dueDateLabel == nil) {
        dueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 375, 150, 25)];
        dueDateLabel.backgroundColor = CLEAR_COLOR;
        dueDateLabel.textColor = BLACK_COLOR;
        dueDateLabel.font = FONT_NORMAL_SMALL;
        dueDateLabel.text = @"Сар бүрийн";
    }
    return dueDateLabel;
}

- (UIButton *)dueDateButton {
    if (dueDateButton == nil) {
        dueDateButton = [[MyButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 370, SCREEN_WIDTH/2-20, 34)];
        dueDateButton.titleLabel.font = FONT_NORMAL_SMALL;
        dueDateButton.layer.borderWidth = 1;
        dueDateButton.layer.cornerRadius = 4;
        [dueDateButton addTarget:self action:@selector(dueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return dueDateButton;
}

- (UILabel *)startLabel {
    if (startLabel == nil) {
        startLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 420, SCREEN_WIDTH/2-40, 25)];
        startLabel.backgroundColor = CLEAR_COLOR;
        startLabel.textColor = BLACK_COLOR;
        startLabel.font = FONT_NORMAL_SMALL;
        startLabel.text = @"Эхлэх өдөр";
    }
    return startLabel;
}

- (UIButton *)startButton {
    if (startButton == nil) {
        startButton = [[MyButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 415, SCREEN_WIDTH/2-20, 34)];
        startButton.titleLabel.font = FONT_NORMAL_SMALL;
        startButton.layer.cornerRadius = 4;
        startButton.layer.borderWidth = 1;
        [startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return startButton;
}
- (UILabel *)endLabel {
    if (endLabel == nil) {
        endLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 464, SCREEN_WIDTH/2-40, 25)];
        endLabel.backgroundColor = CLEAR_COLOR;
        endLabel.textColor = BLACK_COLOR;
        endLabel.font = FONT_NORMAL_SMALL;
        endLabel.text = @"Дуусах өдөр";
    }
    return endLabel;
}

- (UIButton *)endButton {
    if (endButton == nil) {
        endButton = [[MyButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 460, SCREEN_WIDTH/2-20, 34)];
        endButton.layer.cornerRadius = 4;
        endButton.layer.borderWidth = 1;
        endButton.titleLabel.font = FONT_NORMAL_SMALL;
        [endButton addTarget:self action:@selector(endButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return endButton;
}

- (UICollectionView *)catCollectionView {
    
    if (catCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        catCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 505, SCREEN_WIDTH, 165) collectionViewLayout:layout];
        catCollectionView.backgroundColor = CLEAR_COLOR;
        catCollectionView.dataSource = self;
        catCollectionView.delegate = self;
        catCollectionView.alwaysBounceHorizontal = YES;
        catCollectionView.layer.borderColor = [UIColor blackColor].CGColor;
        catCollectionView.layer.borderWidth = 1;
        
        layout.itemSize = CGSizeMake(90, 80);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [catCollectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"CategoryCell"];
    }
    return catCollectionView;
}

@end
