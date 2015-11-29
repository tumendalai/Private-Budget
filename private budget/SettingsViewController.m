//
//  SettingsViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 08.11.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "SettingsViewController.h"
#import "CategoryObject.h"
#import "CategoryCell.h"
#import "CategoryImageCell.h"

@interface SettingsViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self categoryArray];
    [self categoryImageArray];
    if (self.categoryImageArray.count > 0) {
        selectedItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    [self.catCollectionView reloadData];
    [self.catImageCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == catImageCollectionView) {
        return self.categoryImageArray.count;
    } else {
        return self.categoryArray.count;
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
    CategoryObject *category = [self.categoryArray objectAtIndex:indexPath.row];
    cell.category = category;
    cell.smallImageView.alpha = 0.6f;
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
    // always reload the selected cell, so we will add the border to that cell
    if (collectionView == catImageCollectionView) {
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

- (NSArray *)categoryImageArray {
    
    if (categoryImageArray == nil) {
        categoryImageArray = @[@"cat_car",@"cat_clothes",@"cat_education",@"cat_entertainment",@"cat_gift"];
    }
    return categoryImageArray;
}

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
        catCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) collectionViewLayout:layout];
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
        catImageCollectionView.backgroundColor = RANDOM_COLOR;
        catImageCollectionView.dataSource = self;
        catImageCollectionView.delegate = self;
        catImageCollectionView.alwaysBounceHorizontal = YES;
        
        layout.itemSize = CGSizeMake(50, 50);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
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
