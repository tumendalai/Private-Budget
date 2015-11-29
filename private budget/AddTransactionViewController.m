//
//  ViewController.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "AddTransactionViewController.h"
#import "CategoryObject.h"
#import "CategoryCell.h"

@interface AddTransactionViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField  *descTextfield;
@property (nonatomic, strong) UITextField *resTextfield;
@property (nonatomic, strong) UITextField *amountTextfield;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UICollectionView *catCollectionView;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSIndexPath       *selectedItemIndexPath;


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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
        catCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 200) collectionViewLayout:layout];
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
