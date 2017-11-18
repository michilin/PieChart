//
//  ViewController.h
//  PieChart
//
//  Created by Mickey on 2017/11/13.
//  Copyright © 2017年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet NSArray *itemArray;
@property (strong, nonatomic) IBOutlet NSArray *valueArray;
@property (strong, nonatomic) IBOutlet NSArray *colorArray;

@end

