//
//  MainTableViewController.h
//  PieChart
//
//  Created by Mickey on 2017/11/16.
//  Copyright © 2017年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
