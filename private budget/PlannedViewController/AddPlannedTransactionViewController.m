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

@interface AddPlannedTransactionViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate>

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
    [self.plannedTransactionsTableView reloadData];
    [self categoryArray];
    if (self.categoryArray.count > 0) {
        selectedItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    [self.catCollectionView reloadData];
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
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (self.plannedTransactionArray.count > 0)
        return self.plannedTransactionArray.count;
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.plannedTransactionArray.count == 0 && indexPath.row == 0) {
        
        return nil;
        
    } else {
        
        static NSString *CellIdentifier = @"PlannedTransactionTableViewCell";
        
        PlannedTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PlannedTransactionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        cell.indexPath = indexPath;
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }
}

//- (EmptyTableViewCell *)getEmptyCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
//    static NSString *CellIdentifier = @"EmptyTableViewCell";
//
//    EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[EmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//
//    [cell layoutSubviews];
//
//    return cell;
//}

- (void)configureCell:(PlannedTransactionTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.transaction = nil;
    cell.transaction = [self.plannedTransactionArray objectAtIndex:indexPath.row];
    
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
    return self.categoryArray.count;
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
    CategoryObject *category = [self.categoryArray objectAtIndex:indexPath.row];
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
    // always reload the selected cell, so we will add the border to that cell
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            // if it's the same as the one we just tapped on, then we're unselecting it
            
            self.selectedItemIndexPath = nil;
        } else {
            // if it's different, then add that old one to our list of cells to reload, and
            // save the currently selected indexPath
            
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    } else {
        // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
        
        self.selectedItemIndexPath = indexPath;
    }
    
    // and now only reload only the cells that need updating
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
}

#pragma mark -
#pragma mark Getters
- (NSArray *)categoryArray {
    
    
    if (categoryArray == nil) {
        CategoryObject *category = [[CategoryObject alloc] init];
        category.image = @"cat_car";
        category.type = @"1";
        category.name = @"Машин";
        CategoryObject *category1 = [[CategoryObject alloc] init];
        category1.image = @"cat_clothes";
        category1.type = @"1";
        category1.name = @"Хувцас";
        CategoryObject *category2 = [[CategoryObject alloc] init];
        category2.image = @"cat_education";
        category2.type = @"1";
        category2.name = @"Боловролын";
        CategoryObject *category3 = [[CategoryObject alloc] init];
        category3.image = @"cat_entertainment";
        category3.type = @"1";
        category3.name = @"Үзвэр";
        CategoryObject *category4 = [[CategoryObject alloc] init];
        category4.image = @"cat_gift";
        category4.type = @"1";
        category4.name = @"Бэлэг";
        
        categoryArray = @[category,category1,category3,category4];
    }
    return categoryArray;
}

-(NSArray*)plannedTransactionArray{
    
    if (plannedTransactionArray == nil){
        PlannedTransaction *transaction = [[PlannedTransaction alloc] init];
        transaction.amount = @"800000";
        transaction.category_id = @"1";
        transaction.currency_id = @"1";
        transaction.date = @"27";
        transaction.itemid = @"1";
        transaction.reciever = @"Төгөлдөр";
        transaction.transaction_description = @"Сарын цалин";
        transaction.is_income = @"1";
        transaction.startDate = @"2015-11-12 12:00:00";
        transaction.endDate = @"2025-11-12 12:00:00";
        
        PlannedTransaction *transaction1 = [[PlannedTransaction alloc] init];
        transaction1.amount = @"800000";
        transaction1.category_id = @"1";
        transaction1.currency_id = @"1";
        transaction1.date = @"30";
        transaction1.itemid = @"1";
        transaction1.reciever = @"Төгөлдөр";
        transaction1.transaction_description = @"Байрны лизинг";
        transaction1.is_income = @"0";
        transaction1.startDate = @"2015-11-12 12:00:00";
        transaction1.endDate = @"2035-11-12 12:00:00";
        
        plannedTransactionArray = @[transaction,transaction1,transaction,transaction1,transaction1,transaction,transaction1,transaction];
    }
    return plannedTransactionArray;
}

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
