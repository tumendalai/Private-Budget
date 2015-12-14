//
//  SettingsViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 08.11.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "SettingsViewController.h"
#import "DBCategory.h"
#import "CategoryCell.h"
#import "CategoryImageCell.h"

@interface SettingsViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField  *nameTextfield;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UICollectionView *catCollectionView;
@property (nonatomic, strong) UICollectionView *catImageCollectionView;
@property (nonatomic, strong) UISegmentedControl *incomeOrExpenseSegmentedControl;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) NSArray *categoryImageArray;
@property (nonatomic, strong) NSIndexPath       *selectedItemIndexPath;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSBlockOperation *blockOperation;
@property (strong, nonatomic) NSMutableArray *sectionChanges;
@property (strong, nonatomic) NSMutableArray *itemChanges;

@end

@implementation SettingsViewController
@synthesize addButtonClicked;
@synthesize scrollView;
@synthesize nameTextfield;
@synthesize categoryArray;
@synthesize addButton;
@synthesize catCollectionView;
@synthesize selectedItemIndexPath;
@synthesize catImageCollectionView;
@synthesize categoryImageArray;
@synthesize resetButton;
@synthesize categoryLabel;
@synthesize incomeOrExpenseSegmentedControl;
@synthesize sectionChanges;
@synthesize itemChanges;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCategories];
    [self categoryImageArray];
    selectedItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)configureView{
    [super configureView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.nameTextfield];
    [self.scrollView addSubview:self.addButton];
    [self.scrollView addSubview:self.categoryLabel];
    [self.scrollView addSubview:self.resetButton];
    [self.scrollView addSubview:self.catImageCollectionView];
    [self.scrollView addSubview:self.catCollectionView];
    [self.scrollView addSubview:self.incomeOrExpenseSegmentedControl];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 430);
}

#pragma mark -
#pragma mark UIAction

-(void)addButtonClicked:(UIButton *)button{
    if (![self formValidation]) {
        return;
    }
    NSEntityDescription *category_entity_desc = [NSEntityDescription entityForName:@"DBCategory" inManagedObjectContext:self.managedObjectContext];
    DBCategory *newCategory = [[DBCategory alloc] initWithEntity:category_entity_desc insertIntoManagedObjectContext:self.managedObjectContext];
    
    newCategory.name = self.nameTextfield.text;
    newCategory.income = [NSNumber numberWithInt:self.incomeOrExpenseSegmentedControl.selectedSegmentIndex == 0 ? 1:0];
    newCategory.image = [self.categoryImageArray objectAtIndex:selectedItemIndexPath.row];
    
    NSError *error = nil;
    
    if (![newCategory.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    } else {
//        [self.catCollectionView reloadData];
        selectedItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
}

-(void)resetButtonClicked:(UIButton *)button{
}

- (void)incomeOrExpenseSegmentedControlChanged:(UISegmentedControl *)segmentedControl {
    
}

#pragma mark -
#pragma mark User

- (BOOL)formValidation {
    if (selectedItemIndexPath == nil) {
        //        [SEUtils showAlert:NSLocalizedString(@"Зураг сонгоно уу!", nil)];
        return NO;
    }
    if (self.nameTextfield.text.length == 0) {
        return NO;
    }
    return YES;
}

- (void)getCategories {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBCategory"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
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
}

- (NSArray *)categoryImageArray {
    
    if (categoryImageArray == nil) {
        categoryImageArray = @[@"cat_car",
                               @"cat_clothes",
                               @"cat_education",
                               @"cat_entertainment",
                               @"cat_food",
                               @"cat_fun",
                               @"cat_gift",
                               @"cat_household",
                               @"cat_medicine",
                               @"cat_mortgage",
                               @"cat_personal",
                               @"cat_transport"];
    }
    
    return categoryImageArray;
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
    if (collectionView == catImageCollectionView) {
        return self.categoryImageArray.count;
    } else {
        NSArray *sections = [self.fetchedResultsController sections];
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        
        return [sectionInfo numberOfObjects];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == catImageCollectionView) {
        CategoryImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryImageCell" forIndexPath:indexPath];
        
        [self configureCategoryImageCell:cell forItemAtIndexPath:indexPath];
        
        return cell;
    } else {
        CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
        
        [self configureCategoryCell:cell forItemAtIndexPath:indexPath];
        
        return cell;
    }
}

- (void)configureCategoryCell:(CategoryCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.category = category;
    [cell layoutSubviews];
}

- (void)configureCategoryImageCell:(CategoryImageCell *)cell
           forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *image = [self.categoryImageArray objectAtIndex:indexPath.row];
    cell.image = image;
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
    if (collectionView == catImageCollectionView) {
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
}


#pragma mark -
#pragma mark Getters

- (UIScrollView *)scrollView {
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-60)];
        scrollView.backgroundColor = CLEAR_COLOR;
//        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.decelerationRate = 0.1f;
        scrollView.pagingEnabled = NO;
        scrollView.alwaysBounceVertical = YES;
    }
    return scrollView;
}

- (UICollectionView *)catCollectionView {
    
    if (catCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        catCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 165) collectionViewLayout:layout];
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

- (UILabel *)categoryLabel {
    if (categoryLabel == nil) {
        categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 210, SCREEN_WIDTH/2, 25)];
        categoryLabel.backgroundColor = CLEAR_COLOR;
        categoryLabel.textColor = BLACK_COLOR;
        categoryLabel.textAlignment = NSTextAlignmentCenter;
        categoryLabel.text = @"Категори нэмэх";
    }
    return categoryLabel;
}

- (UITextField *)nameTextfield {
    if (nameTextfield == nil) {
        nameTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 245, SCREEN_WIDTH-40, 20)];
        nameTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        nameTextfield.layer.borderWidth = 0.2f;
        nameTextfield.layer.cornerRadius = 3.0f;
        nameTextfield.backgroundColor = [UIColor whiteColor];
        //        nameTextfield.delegate = self;
        nameTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        nameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        [nameTextfield addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        nameTextfield.font = FONT_NORMAL_SMALL;
        nameTextfield.placeholder = @" Нэр";
    }
    return nameTextfield;
}

- (UICollectionView *)catImageCollectionView {
    
    if (catImageCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        catImageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 275, SCREEN_WIDTH, 50) collectionViewLayout:layout];
        catImageCollectionView.backgroundColor = CLEAR_COLOR;
        catImageCollectionView.dataSource = self;
        catImageCollectionView.delegate = self;
        catImageCollectionView.alwaysBounceHorizontal = YES;
        catImageCollectionView.layer.borderColor = [UIColor blackColor].CGColor;
        catImageCollectionView.layer.borderWidth = 0.5f;
        
        layout.itemSize = CGSizeMake(50, 50);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [catImageCollectionView registerClass:[CategoryImageCell class] forCellWithReuseIdentifier:@"CategoryImageCell"];
    }
    return catImageCollectionView;
}

-(UISegmentedControl *)incomeOrExpenseSegmentedControl{
    if (incomeOrExpenseSegmentedControl == nil){
        NSArray *array = @[@"Орлого",@"Зарлага"];
        incomeOrExpenseSegmentedControl = [[UISegmentedControl alloc] initWithItems:array];
        incomeOrExpenseSegmentedControl.frame = CGRectMake(SCREEN_WIDTH/4, 335, SCREEN_WIDTH/2, 20);
        incomeOrExpenseSegmentedControl.backgroundColor = [UIColor whiteColor];
        [incomeOrExpenseSegmentedControl addTarget:self action:@selector(incomeOrExpenseSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
        incomeOrExpenseSegmentedControl.tintColor = [UIColor blueColor];
        incomeOrExpenseSegmentedControl.selectedSegmentIndex = 0;
        incomeOrExpenseSegmentedControl.layer.cornerRadius = 5;
    }
    return incomeOrExpenseSegmentedControl;
}

- (UIButton *)addButton {
    if (addButton == nil) {
        addButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 365, SCREEN_WIDTH/2, 25)];
        //        [addButton setImage:[UIImage imageNamed:@"baraa_add"] forState:UIControlStateNormal];
        [addButton setTitle:@"Нэмэх" forState:UIControlStateNormal];
        addButton.layer.borderWidth = 0.3f;
        addButton.layer.cornerRadius = 4;
        addButton.titleLabel.font = FONT_NORMAL_SMALL;
        [addButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return addButton;
}

- (UIButton *)resetButton {
    if (resetButton == nil) {
        resetButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 400, SCREEN_WIDTH/2, 25)];
        //        [addButton setImage:[UIImage imageNamed:@"baraa_add"] forState:UIControlStateNormal];
        [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
        resetButton.layer.borderWidth = 0.3f;
        resetButton.layer.cornerRadius = 4;
        resetButton.titleLabel.font = FONT_NORMAL_SMALL;
        [resetButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [resetButton addTarget:self action:@selector(resetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return resetButton;
}

@end
