//
//  ChooseIntervalController.m
//  private budget
//
//  Created by Enkhdulguun on 12/14/15.
//  Copyright © 2015 tuguldur purevnyam. All rights reserved.
//

#import "ChooseIntervalController.h"

@interface ChooseIntervalController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableview;

@end

@implementation ChooseIntervalController
@synthesize stringArray;
@synthesize intervalSelected;
@synthesize tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.stringArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlannedTransactionTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    cell.textLabel.text = [self.stringArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.intervalSelected) {
        self.intervalSelected(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 25;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Getters

- (UITableView *)tableview {
    if (tableview == nil) {
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.preferredContentSize.width,self.preferredContentSize.height) style:UITableViewStylePlain];
        
        tableview.delegate = self;
        tableview.dataSource = self;
    }
    return tableview;
}

@end
