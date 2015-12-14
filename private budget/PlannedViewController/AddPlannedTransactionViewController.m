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

@interface AddPlannedTransactionViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *plannedFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *categoryFetchedResultsController;
@property (strong, nonatomic) NSBlockOperation *blockOperation;
@end

@implementation AddPlannedTransactionViewController

@synthesize plannedTransactionArray;
@synthesize plannedTransactionsTableView;
@synthesize saveButton;
@synthesize scrollView;
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
@synthesize categoryArray;
@synthesize selectedItemIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self plannedTransactionArray];
    [self categoryArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureView{
    [super configureView];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.plannedTransactionsTableView];
    [self.scrollView addSubview:self.descriptionTextfield];
    [self.scrollView addSubview:self.receiverTextfield];
    [self.scrollView addSubview:self.amountTextfield];
    [self.scrollView addSubview:self.dueDateLabel];
    [self.scrollView addSubview:self.dueDateButton];
    [self.scrollView addSubview:self.startButton];
    [self.scrollView addSubview:self.startLabel];
    [self.scrollView addSubview:self.endButton];
    [self.scrollView addSubview:self.endLabel];
    [self.scrollView addSubview:self.catCollectionView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+80);
}

#pragma mark -
#pragma mark User

-(void)getPlannedTransactions{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DBPlannedTransaction"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    
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
    
    selectedItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

#pragma mark -
#pragma mark UIAction

-(void)saveButtonClicked:(UIButton *)button{
    if (![self formValidation]) {
        return;
    }
}

-(void)dueButtonClicked:(UIButton *)button{
}

-(void)startButtonClicked:(UIButton *)button{
}

-(void)endButtonClicked:(UIButton *)button{
}

#pragma mark -
#pragma mark User

- (BOOL)formValidation {
    if (selectedItemIndexPath == nil) {
//        [SEUtils showAlert:NSLocalizedString(@"Зураг сонгоно уу!", nil)];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Fetched Results Controller Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (controller == self.plannedFetchedResultsController) {
        [self.plannedTransactionsTableView beginUpdates];
    } else {
        self.blockOperation = [NSBlockOperation new];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (controller == self.plannedFetchedResultsController) {
        [self.plannedTransactionsTableView endUpdates];
    } else {
        [self.catCollectionView performBatchUpdates:^{
            [self.blockOperation start];
        } completion:^(BOOL finished) {
            // Do whatever
        }];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    __weak UICollectionView *collectionView = self.catCollectionView;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            if (controller == self.plannedFetchedResultsController) {
                [self.plannedTransactionsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self.blockOperation addExecutionBlock:^{
                    [collectionView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] ];
                }];
            }
            break;
        }
        case NSFetchedResultsChangeDelete: {
            if (controller == self.plannedFetchedResultsController) {
                [self.plannedTransactionsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self.blockOperation addExecutionBlock:^{
                    [collectionView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
                }];
            }
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            if (controller == self.plannedFetchedResultsController) {
                [self configureCell:(PlannedTransactionTableViewCell *)[self.plannedTransactionsTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            } else {
                [self.blockOperation addExecutionBlock:^{
                    [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
                }];
            }
            break;
        }
        case NSFetchedResultsChangeMove: {
            if (controller == self.plannedFetchedResultsController) {
                [self.plannedTransactionsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.plannedTransactionsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self.blockOperation addExecutionBlock:^{
                    [collectionView moveSection:indexPath.section toSection:newIndexPath.section];
                }];
            }
            break;
        }
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

- (UITextField *)descriptionTextfield {
    if (descriptionTextfield == nil) {
        descriptionTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 240, SCREEN_WIDTH-40, 20)];
        descriptionTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        descriptionTextfield.layer.borderWidth = 0.2f;
        descriptionTextfield.layer.cornerRadius = 3.0f;
        descriptionTextfield.backgroundColor = [UIColor whiteColor];
//        descriptionTextfield.delegate = self;
        descriptionTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        descriptionTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [descriptionTextfield addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        descriptionTextfield.font = FONT_NORMAL_SMALL;
        descriptionTextfield.placeholder = @" Утга";
    }
    return descriptionTextfield;
}

- (UITextField *)receiverTextfield {
    if (receiverTextfield == nil) {
        receiverTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 285, SCREEN_WIDTH-40, 20)];
        receiverTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        receiverTextfield.layer.borderWidth = 0.2f;
        receiverTextfield.layer.cornerRadius = 3.0f;
        receiverTextfield.backgroundColor = [UIColor whiteColor];
        //        descriptionTextfield.delegate = self;
        receiverTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        receiverTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        [descriptionTextfield addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        receiverTextfield.font = FONT_NORMAL_SMALL;
        receiverTextfield.placeholder = @" Хэнд";
    }
    return receiverTextfield;
}

- (UITextField *)amountTextfield {
    if (amountTextfield == nil) {
        amountTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 330, SCREEN_WIDTH-40, 20)];
        amountTextfield.layer.borderColor = [UIColor blackColor].CGColor;
        amountTextfield.layer.borderWidth = 0.2f;
        amountTextfield.layer.cornerRadius = 3.0f;
        amountTextfield.backgroundColor = [UIColor whiteColor];
        //        descriptionTextfield.delegate = self;
        amountTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
        amountTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        [descriptionTextfield addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        amountTextfield.font = FONT_NORMAL_SMALL;
        amountTextfield.placeholder = @" Дүн";
    }
    return amountTextfield;
}

- (UILabel *)dueDateLabel {
    if (dueDateLabel == nil) {
        dueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 150, 25)];
        dueDateLabel.backgroundColor = CLEAR_COLOR;
        dueDateLabel.textColor = BLACK_COLOR;
        dueDateLabel.font = FONT_NORMAL_SMALL;
        dueDateLabel.text = @"Сар бүрийн";
    }
    return dueDateLabel;
}

- (UIButton *)dueDateButton {
    if (dueDateButton == nil) {
        dueDateButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 360, SCREEN_WIDTH/2-20, 25)];
        //        [saveButton setImage:[UIImage imageNamed:@"baraa_add"] forState:UIControlStateNormal];
        [dueDateButton setTitle:@"00" forState:UIControlStateNormal];
        [dueDateButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        dueDateButton.titleLabel.font = FONT_NORMAL_SMALL;
        dueDateButton.layer.borderWidth = 0.2f;
        dueDateButton.layer.cornerRadius = 3.0f;
        [dueDateButton addTarget:self action:@selector(dueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return dueDateButton;
}

- (UILabel *)startLabel {
    if (startLabel == nil) {
        startLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 390, 150, 25)];
        startLabel.backgroundColor = CLEAR_COLOR;
        startLabel.textColor = BLACK_COLOR;
        startLabel.font = FONT_NORMAL_SMALL;
        startLabel.text = @"Эхлэх өдөр";
    }
    return startLabel;
}

- (UIButton *)startButton {
    if (startButton == nil) {
        startButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 390, SCREEN_WIDTH/2-20, 25)];
        //        [saveButton setImage:[UIImage imageNamed:@"baraa_add"] forState:UIControlStateNormal];
        [startButton setTitle:@"2015-11-31 00:00:00" forState:UIControlStateNormal];
        startButton.titleLabel.font = FONT_NORMAL_SMALL;
        startButton.layer.cornerRadius = 3.0f;
        startButton.layer.borderWidth = 0.2f;
        [startButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return startButton;
}
- (UILabel *)endLabel {
    if (endLabel == nil) {
        endLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 420, SCREEN_WIDTH/2-40, 25)];
        endLabel.backgroundColor = CLEAR_COLOR;
        endLabel.textColor = BLACK_COLOR;
        endLabel.font = FONT_NORMAL_SMALL;
        endLabel.text = @"Дуусах өдөр";
    }
    return endLabel;
}

- (UIButton *)endButton {
    if (endButton == nil) {
        endButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 420, SCREEN_WIDTH/2-20, 25)];
        //        [saveButton setImage:[UIImage imageNamed:@"baraa_add"] forState:UIControlStateNormal];
        endButton.layer.cornerRadius = 3.0f;
        endButton.layer.borderWidth = 0.2f;
        [endButton setTitle:@"2015-11-31 00:00:00" forState:UIControlStateNormal];
        [endButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        endButton.titleLabel.font = FONT_NORMAL_SMALL;
        [endButton addTarget:self action:@selector(endButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return endButton;
}

- (UICollectionView *)catCollectionView {
    
    if (catCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        catCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 450, SCREEN_WIDTH, 200) collectionViewLayout:layout];
        catCollectionView.backgroundColor = CLEAR_COLOR;
        catCollectionView.dataSource = self;
        catCollectionView.delegate = self;
        catCollectionView.alwaysBounceHorizontal = YES;
        catCollectionView.layer.borderColor = [UIColor blackColor].CGColor;
        catCollectionView.layer.borderWidth = 0.5f;
        
        layout.itemSize = CGSizeMake(90, 80);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(26, 0, 0, 0);
        
        [catCollectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"CategoryCell"];
    }
    return catCollectionView;
}

@end
