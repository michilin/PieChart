//
//  MainTableViewController.m
//  PieChart
//
//  Created by Mickey on 2017/11/16.
//  Copyright © 2017年 Mickey. All rights reserved.
//

#import "MainTableViewController.h"
#import "PieChartViewController.h"

#define mainScreenWidth [[UIScreen mainScreen] bounds].size.width
#define mainScreenHeight [[UIScreen mainScreen] bounds].size.height
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height

#define ISPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define CELL_ROW_HEIGHT 44

@interface MainTableViewController ()

@end

@implementation MainTableViewController
{
    NSMutableArray *valueArray;
    UIView *editingTouchView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.navigationItem.title = @"PieChart";
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendAction:)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearAction:)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    valueArray = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    editingTouchView = [[UIView alloc] initWithFrame:self.view.frame];
    editingTouchView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    editingTouchView.backgroundColor = [UIColor clearColor];
    editingTouchView.hidden = YES;
    editingTouchView.userInteractionEnabled = YES;
    [editingTouchView addGestureRecognizer:tapGesture];
    [self.view bringSubviewToFront:self.tableView];
    [self.view insertSubview:editingTouchView belowSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 56)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *headerTitle = [[UILabel alloc] init];
    headerTitle.font = [UIFont fontWithName:@"Helvetica" size:18];
    headerTitle.text = @"Enter number on each row.";
    headerTitle.textAlignment = NSTextAlignmentCenter;
    headerTitle.numberOfLines = 0;
    headerTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [headerTitle sizeToFit];
    headerTitle.frame = CGRectMake(0, (headerView.frame.size.height - headerTitle.frame.size.height)/2, headerView.frame.size.width, headerTitle.frame.size.height);
    [headerView addSubview:headerTitle];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if( cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    cell.textLabel.text = [[NSArray arrayWithObjects:@"Item 1 Used ", @"Item 2 Used", @"Item 3 Used", @"Item 4 Used", @"Item 5 Used", nil] objectAtIndex:indexPath.row];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 21)];
    textField.placeholder = @"Enter Number";
    textField.tag = indexPath.row;
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    cell.accessoryView = textField;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

# pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    editingTouchView.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignKeyboard];
    return YES;
}

- (void)resignKeyboard {
    editingTouchView.hidden = YES;
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [valueArray replaceObjectAtIndex:textField.tag withObject:resultString];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0";
    }
    return YES;
}

# pragma mark - Button Action

- (IBAction)sendAction:(id)sender {
    [self performSegueWithIdentifier:@"pushToPieChart" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushToPieChart"]) {
        PieChartViewController *vc = [segue destinationViewController];
        
        vc.valueArray = valueArray;
    }
}

- (IBAction)clearAction:(id)sender {
    [self.tableView reloadData];
}

# pragma mark - Orientation

//iOS6 implementation of the rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    if (ISPAD) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
