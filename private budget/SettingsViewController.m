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

@property (nonatomic, strong) UIScrollView *sScrollView;
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
@property (strong, nonatomic) NSMutableArray *sectionChanges;
@property (strong, nonatomic) NSMutableArray *itemChanges;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation SettingsViewController
@synthesize addButtonClicked;
@synthesize sScrollView;
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
@synthesize persistentStoreCoordinator;
@synthesize tap;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCategories];
    [self categoryImageArray];
    [self refresh_data];
    [self.backButton setHidden:YES];
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
}

-(void)configureView{
    [super configureView];
    [self.view addSubview:self.sScrollView];
    [self.sScrollView addSubview:self.nameTextfield];
    [self.sScrollView addSubview:self.addButton];
    [self.sScrollView addSubview:self.categoryLabel];
    [self.sScrollView addSubview:self.resetButton];
    [self.sScrollView addSubview:self.catImageCollectionView];
    [self.sScrollView addSubview:self.catCollectionView];
    [self.sScrollView addSubview:self.incomeOrExpenseSegmentedControl];
    
    self.sScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 480);
}
#pragma mark -
#pragma mark KeyboardDelegate
#pragma mark -
- (void)keyboardDidShow: (NSNotification *) notif {
    [self.view addGestureRecognizer:self.tap];
    
    // Do something here
    UIScrollView *scrollView = self.sScrollView;
    
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
    UIScrollView *scrollView = self.sScrollView;
    
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
        [self refresh_data];
    }
}

-(void)resetButtonClicked:(UIButton *)button{

    [self deleteAllEntities:@"DBCategory"];
    [self deleteAllEntities:@"DBCurrency"];
    [self deleteAllEntities:@"DBTransaction"];
    [self deleteAllEntities:@"DBPlannedTransaction"];
    [USERDEF setValue:nil forKey:kSelectedCurrency];
    [APPDEL saveContext];
    [APPDEL chooseCurrency];
}

- (void)deleteAllEntities:(NSString *)nameEntity
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [self.managedObjectContext deleteObject:object];
    }
}

- (void)incomeOrExpenseSegmentedControlChanged:(UISegmentedControl *)segmentedControl {
    
}

#pragma mark - tap
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark User

- (BOOL)formValidation {
    if (selectedItemIndexPath == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Анхаар" message:@"Зураг сонгоно уу!" delegate:nil cancelButtonTitle:@"За" otherButtonTitles:nil] show];
        return NO;
    }
    if (self.nameTextfield.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Анхаар" message:@"Нэр оруулна уу!" delegate:nil cancelButtonTitle:@"За" otherButtonTitles:nil] show];
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
        categoryImageArray = @[@"Number_0",
                               @"Number_1",
                               @"Number_2",
                               @"Number_3",
                               @"Number_4",
                               @"Number_5",
                               @"Number_6",
                               @"Number_7",
                               @"Number_8",
                               @"Number_9",];
    }
    
    return categoryImageArray;
}

-(void)refresh_data{
    selectedItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.catImageCollectionView reloadData];
    [self.catImageCollectionView selectItemAtIndexPath:selectedItemIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    self.nameTextfield.text = @"";
    self.incomeOrExpenseSegmentedControl.selectedSegmentIndex = 0;
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

- (UIScrollView *)sScrollView {
    if (sScrollView == nil) {
        sScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-60)];
        sScrollView.backgroundColor = CLEAR_COLOR;
        sScrollView.showsVerticalScrollIndicator = NO;
        sScrollView.showsHorizontalScrollIndicator = NO;
        sScrollView.decelerationRate = 0.1f;
        sScrollView.pagingEnabled = NO;
        sScrollView.alwaysBounceVertical = YES;
    }
    return sScrollView;
}

-(UITapGestureRecognizer *)tap{
    if (tap == nil) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    }
    return tap;
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

- (UILabel *)categoryLabel {
    if (categoryLabel == nil) {
        categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 185, SCREEN_WIDTH/2, 25)];
        categoryLabel.backgroundColor = CLEAR_COLOR;
        categoryLabel.textColor = BLACK_COLOR;
        categoryLabel.textAlignment = NSTextAlignmentCenter;
        categoryLabel.font = FONT_NORMAL;
        categoryLabel.text = @"Категори нэмэх";
    }
    return categoryLabel;
}

- (UITextField *)nameTextfield {
    if (nameTextfield == nil) {
        nameTextfield = [[MyTextField alloc] initWithFrame:CGRectMake(20, 225, SCREEN_WIDTH-40, 30)];
        nameTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        nameTextfield.backgroundColor = [UIColor whiteColor];
        nameTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        nameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        nameTextfield.font = FONT_NORMAL_SMALL;
        nameTextfield.placeholder = @"Нэр";
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
        catImageCollectionView.layer.borderWidth = 1;
        
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
        incomeOrExpenseSegmentedControl.frame = CGRectMake(SCREEN_WIDTH/4, 340, SCREEN_WIDTH/2, 30);
        incomeOrExpenseSegmentedControl.backgroundColor = [UIColor whiteColor];
        [incomeOrExpenseSegmentedControl addTarget:self action:@selector(incomeOrExpenseSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:FONT_NORMAL_SMALL
                                                               forKey:NSFontAttributeName];
        [incomeOrExpenseSegmentedControl setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
        incomeOrExpenseSegmentedControl.tintColor = [UIColor blueColor];
        incomeOrExpenseSegmentedControl.selectedSegmentIndex = 0;
        incomeOrExpenseSegmentedControl.layer.cornerRadius = 5;
    }
    return incomeOrExpenseSegmentedControl;
}

- (UIButton *)addButton {
    if (addButton == nil) {
        addButton = [[MyButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 385, SCREEN_WIDTH/2, 34)];
        [addButton setTitle:@"Нэмэх" forState:UIControlStateNormal];
        addButton.layer.borderWidth = 1;
        addButton.layer.cornerRadius = 4;
        addButton.titleLabel.font = FONT_NORMAL_SMALL;
        [addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return addButton;
}

- (UIButton *)resetButton {
    if (resetButton == nil) {
        resetButton = [[MyButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 435, SCREEN_WIDTH/2, 34)];
        [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
        resetButton.layer.borderWidth = 1;
        resetButton.layer.cornerRadius = 4;
        resetButton.titleLabel.font = FONT_NORMAL_SMALL;
        [resetButton addTarget:self action:@selector(resetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return resetButton;
}

@end
