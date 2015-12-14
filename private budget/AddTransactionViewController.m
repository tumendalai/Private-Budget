//
//  ViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "AddTransactionViewController.h"
#import "DBCategory.h"
#import "CategoryCell.h"
#import "DBTransaction.h"

@interface AddTransactionViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField  *descTextfield;
@property (nonatomic, strong) UITextField *resTextfield;
@property (nonatomic, strong) UITextField *amountTextfield;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UICollectionView *catCollectionView;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSIndexPath       *selectedItemIndexPath;
@property (strong, nonatomic) NSFetchedResultsController *categoryFetchedResultsController;
@property (strong, nonatomic) NSBlockOperation *blockOperation;
@property (strong, nonatomic) NSMutableArray *sectionChanges;
@property (strong, nonatomic) NSMutableArray *itemChanges;


@end

@implementation AddTransactionViewController
@synthesize saveButtonClicked;
@synthesize scrollView;
@synthesize descTextfield;
@synthesize resTextfield;
@synthesize amountTextfield;
@synthesize categoryArray;
@synthesize saveButton;
@synthesize catCollectionView;
@synthesize selectedItemIndexPath;
@synthesize sectionChanges;
@synthesize itemChanges;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureView{
    [super configureView];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.descTextfield];
    [self.scrollView addSubview:self.resTextfield];
    [self.scrollView addSubview:self.amountTextfield];
    [self.scrollView addSubview:self.catCollectionView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 370);
}

#pragma mark -
#pragma mark UIAction

-(void)saveButtonClicked:(UIButton *)button{
    if (![self formValidation]) {
        return;
    }
    
    NSEntityDescription *transaction_entity_desc = [NSEntityDescription entityForName:@"DBTransaction" inManagedObjectContext:self.managedObjectContext];
    
    DBCategory *category = [self.categoryFetchedResultsController objectAtIndexPath:selectedItemIndexPath];
   
    DBTransaction *newTransaction = [[DBTransaction alloc] initWithEntity:transaction_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
    
    newTransaction.amount =[NSNumber numberWithDouble:self.amountTextfield.text.doubleValue];
    newTransaction.date = [NSDate date];
    newTransaction.is_income = category.income;
    newTransaction.receiver = self.resTextfield.text;
    newTransaction.transaction_description = self.descTextfield.text;
    newTransaction.tran_category = category;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBCurrency"];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [USERDEF stringForKey:kSelectedCurrency]];
    [fetchRequest setPredicate:predicate];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        newTransaction.tran_currency = [result firstObject];
        
        NSError *error = nil;
        
        if (![newTransaction.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        } else {
            //        [self.catCollectionView reloadData];
            selectedItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
}

#pragma mark -
#pragma mark User

- (BOOL)formValidation {
    if (selectedItemIndexPath == nil) {
//                [SEUtils showAlert:NSLocalizedString(@"Зураг сонгоно уу!", nil)];
        return NO;
    }
    if (self.amountTextfield.text.length == 0) {
        return NO;
    }
    if (self.descTextfield.text.length == 0) {
        return NO;
    }
    if (self.resTextfield.text.length == 0) {
        return NO;
    }
    return YES;
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
    
    selectedItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

#pragma mark -
#pragma mark Fetched Results Controller Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    sectionChanges = [[NSMutableArray alloc] init];
    itemChanges = [[NSMutableArray alloc] init];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
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

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    change[@(type)] = @(sectionIndex);
    [sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
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
    [collectionView reloadItemsAtIndexPaths:indexPaths];
}


#pragma mark -
#pragma mark Getters
- (UIScrollView *)scrollView {
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-60)];
        scrollView.backgroundColor = CLEAR_COLOR;
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.decelerationRate = 0.1f;
        scrollView.pagingEnabled = NO;
        scrollView.alwaysBounceVertical = YES;
    }
    return scrollView;
}

- (UIButton *)saveButton {
    if (saveButton == nil) {
        saveButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-114, 25, 100, 25)];
        //        [saveButton setImage:[UIImage imageNamed:@"baraa_add"] forState:UIControlStateNormal];
        [saveButton setTitle:@"Хадгалах" forState:UIControlStateNormal];
        saveButton.layer.borderWidth = 0.3f;
        saveButton.layer.cornerRadius = 4;
        saveButton.titleLabel.font = FONT_NORMAL_SMALL;
        [saveButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return saveButton;
}

- (UITextField *)amountTextfield {
    if (amountTextfield == nil) {
        amountTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 20)];
        amountTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        amountTextfield.layer.borderWidth = 0.2f;
        amountTextfield.layer.cornerRadius = 3.0f;
        amountTextfield.backgroundColor = [UIColor whiteColor];
        //        descTextfield.delegate = self;
        amountTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        amountTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        [descTextfield addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        amountTextfield.font = FONT_NORMAL_SMALL;
        amountTextfield.placeholder = @" Дүн";
    }
    return amountTextfield;
}

- (UICollectionView *)catCollectionView {
    
    if (catCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        catCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 165) collectionViewLayout:layout];
        catCollectionView.backgroundColor = CLEAR_COLOR;
        catCollectionView.dataSource = self;
        catCollectionView.delegate = self;
        catCollectionView.alwaysBounceHorizontal = YES;
        catCollectionView.layer.borderColor = [UIColor blackColor].CGColor;
        catCollectionView.layer.borderWidth = 0.5f;
        
        layout.itemSize = CGSizeMake(90, 80);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [catCollectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"CategoryCell"];
    }
    return catCollectionView;
}

- (UITextField *)descTextfield {
    if (descTextfield == nil) {
        descTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 250, SCREEN_WIDTH-40, 20)];
        descTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        descTextfield.layer.borderWidth = 0.2f;
        descTextfield.layer.cornerRadius = 3.0f;
        descTextfield.backgroundColor = [UIColor whiteColor];
        //        descTextfield.delegate = self;
        descTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        descTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        [descTextfield addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        descTextfield.font = FONT_NORMAL_SMALL;
        descTextfield.placeholder = @" Утга";
    }
    return descTextfield;
}

- (UITextField *)resTextfield {
    if (resTextfield == nil) {
        resTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 280, SCREEN_WIDTH-40, 20)];
        resTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        resTextfield.layer.borderWidth = 0.2f;
        resTextfield.layer.cornerRadius = 3.0f;
        resTextfield.backgroundColor = [UIColor whiteColor];
        //        descTextfield.delegate = self;
        resTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        resTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        [descTextfield addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        resTextfield.font = FONT_NORMAL_SMALL;
        resTextfield.placeholder = @" Хэнд";
    }
    return resTextfield;
}



@end
