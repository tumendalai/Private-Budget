//
//  ChooseIntervalController.m
//  private budget
//
//  Created by tuguldur purevnyam on 29.10.15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "ChooseDateController.h"

@interface ChooseDateController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *pickButton;
@property (nonatomic, strong) NSMutableArray *dayArray;

@end

@implementation ChooseDateController
@synthesize stringArray;
@synthesize dateSelected;
@synthesize datePicker;
@synthesize pickButton;
@synthesize pickerView;
@synthesize is_date_picker;
@synthesize dayArray;
@synthesize daySelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.datePicker];
    [self.view addSubview:self.pickButton];
    [self.view addSubview:self.pickerView];
    self.datePicker.hidden = !is_date_picker;
    self.pickerView.hidden = is_date_picker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pickButtonClicked:(UIButton *)button{
    if (is_date_picker) {
        if (self.dateSelected) {
            self.dateSelected([self.datePicker date]);
        }
    } else {
        if (self.daySelected) {
            self.daySelected([self.dayArray objectAtIndex:[self.pickerView selectedRowInComponent:0]]);
        }
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.pickerView reloadAllComponents];
}
// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsInComponent;
    if (component==0)
    {
        rowsInComponent = [self.dayArray count];
    }
    return rowsInComponent;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString * nameInRow;
    if (component==0)
    {
        nameInRow =[NSString stringWithFormat:@"%@",[self.dayArray objectAtIndex:row]];
    }
    return nameInRow;
}


// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 80;
}

#pragma mark - Getters

-(NSArray*)dayArray{
    if (dayArray == nil) {
        dayArray = [NSMutableArray array];
        for (int i = 1; i <= 31; i++){
            [dayArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    return dayArray;
}

-(UIDatePicker*)datePicker{
    if (datePicker == nil) {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, 30, 280, 200)];
        datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return datePicker;
}

- (UIButton *)pickButton {
    if (pickButton == nil) {
        pickButton = [[MyButton alloc] initWithFrame:CGRectMake(190, 5, 100, 34)];
        [pickButton setTitle:@"Сонгох" forState:UIControlStateNormal];
        pickButton.layer.borderWidth = 1;
        pickButton.layer.cornerRadius = 4;
        pickButton.titleLabel.font = FONT_NORMAL_SMALL;
        [pickButton addTarget:self action:@selector(pickButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return pickButton;
}

-(UIPickerView*)pickerView{
    if (pickerView == nil) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(110, 30, 80, 200)];
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        [pickerView selectRow:0 inComponent:0 animated:YES];
    }
    return pickerView;
}

@end
