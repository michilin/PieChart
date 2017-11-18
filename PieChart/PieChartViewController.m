//
//  ViewController.m
//  PieChart
//
//  Created by Mickey on 2017/11/13.
//  Copyright © 2017年 Mickey. All rights reserved.
//

#import "PieChartViewController.h"

#define mainScreenWidth [[UIScreen mainScreen] bounds].size.width
#define mainScreenHeight [[UIScreen mainScreen] bounds].size.height
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define	ISPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define RADIUS 130
#define CIRCLE_HEIGHT 30

#define CELL_ROW_HEIGHT 44

#define ITEM1COLOR [UIColor colorWithRed:239/255.0 green:89/255.0 blue:89/255.0 alpha:1.0]
#define ITEM2COLOR [UIColor colorWithRed:249/255.0 green:167/255.0 blue:70/255.0 alpha:1.0]
#define ITEM3COLOR [UIColor colorWithRed:255/255.0 green:206/255.0 blue:72/255.0 alpha:1.0]
#define ITEM4COLOR [UIColor colorWithRed:130/255.0 green:196/255.0 blue:81/255.0 alpha:1.0]
#define ITEM5COLOR [UIColor colorWithRed:118/255.0 green:68/255.0 blue:163/255.0 alpha:1.0]
#define REMAINCOLOR [UIColor colorWithRed:0/255.0 green:167/255.0 blue:248/255.0 alpha:1.0]


@interface PieChartViewController ()

@end

@implementation PieChartViewController
{
    double totalAmount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _itemArray = [[NSArray alloc] initWithObjects:@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", nil];
    _colorArray = [[NSArray alloc] initWithObjects:ITEM1COLOR, ITEM2COLOR, ITEM3COLOR, ITEM4COLOR, ITEM5COLOR, nil];

    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_headerView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    for (int i = 0 ; i < _valueArray.count; i++) {
        totalAmount = totalAmount + [_valueArray[i] doubleValue];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self initCircle];
}

- (void)viewWillLayoutSubviews {
    _headerView.frame = CGRectMake((self.view.frame.size.width-RADIUS*2)/2, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, 2.0*RADIUS, 311);
    _tableView.frame = CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + _headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _headerView.frame.size.height - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT);

}

- (void)viewDidDisappear:(BOOL)animated {
    _valueArray = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Draw circle

- (void)initCircle {
    CGRect circleRect = CGRectMake(0, CIRCLE_HEIGHT, 2.0*RADIUS, 2.0*RADIUS);
    CGPoint centerPoint = CGPointMake(circleRect.origin.x+circleRect.size.width/2, circleRect.origin.y+circleRect.size.height/2);

    CGFloat startAngle = M_PI *3/2.0;
    CGFloat size = 0;

    for (int i = 0; i < _valueArray.count; i++) {
        size = [_valueArray[i] integerValue];
        if (size == 0) {
            continue;
        }
        CGFloat angle = [self countAngle:[_valueArray[i] integerValue]];
        [_headerView.layer addSublayer:[self drawItemPieWithCenter:centerPoint startAngle:startAngle endAngle:startAngle + angle color:_colorArray[i]]];
        startAngle += angle;
    }
    if (totalAmount == 0) {
        [_headerView.layer addSublayer:[self drawRemainPieWithCenter:centerPoint startAngle:-M_PI/2 endAngle:3*M_PI/2 color:REMAINCOLOR]];
    }
}

- (CGFloat)countAngle:(CGFloat)value {
    CGFloat percent;
    percent = value / totalAmount;
    CGFloat angle = M_PI * 2 * percent;
    return angle;
}

- (CAShapeLayer *)drawItemPieWithCenter:(CGPoint)center startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color {
    CGRect circleRect = CGRectMake(0, CIRCLE_HEIGHT, 2.0*RADIUS, 2.0*RADIUS);
    CGPoint centerPoint = CGPointMake(circleRect.origin.x+circleRect.size.width/2, circleRect.origin.y+circleRect.size.height/2);
    
    // draw an arc with background color
    CAShapeLayer *pie = [CAShapeLayer layer];
    pie.fillColor = [UIColor clearColor].CGColor;
    pie.lineWidth = 5;
    pie.strokeColor = [UIColor whiteColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:RADIUS startAngle:startAngle endAngle:endAngle clockwise:YES];
    pie.path = path.CGPath;
    pie.frame = CGRectMake(0, 0, self.view.frame.size.width/2 + 50, CIRCLE_HEIGHT + RADIUS*2 + 10);
    
    // draw an slightly smaller mask in the end of arc with drawColorArray
    CGFloat gapAngle = (M_PI_4 / 12.0)/2.0;
    CAShapeLayer *pieMask = [CAShapeLayer layer];
    pieMask.fillColor = [UIColor clearColor].CGColor;
    pieMask.strokeColor = color.CGColor;
    pieMask.lineWidth = 5;
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    if ((endAngle-startAngle) >= gapAngle) {
        [maskPath addArcWithCenter:centerPoint radius:RADIUS startAngle:startAngle endAngle:endAngle-gapAngle clockwise:YES];
        pieMask.path = maskPath.CGPath;
        pieMask.frame = CGRectMake(0, 0, self.view.frame.size.width/2 + 50, CIRCLE_HEIGHT + RADIUS*2 + 10);
    }
    [pie setMask:pieMask];
    
    return pieMask;
}

- (CAShapeLayer *)drawRemainPieWithCenter:(CGPoint)center startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color {
    if (startAngle == endAngle) {
        endAngle = M_PI*3/2.0 +M_PI*2;
    }
    CGRect circleRect = CGRectMake(0, CIRCLE_HEIGHT, 2.0*RADIUS, 2.0*RADIUS);
    CGPoint centerPoint = CGPointMake(circleRect.origin.x+circleRect.size.width/2, circleRect.origin.y+circleRect.size.height/2);
    
    CAShapeLayer *pie = [CAShapeLayer layer];
    pie.fillColor = [UIColor clearColor].CGColor;
    pie.lineWidth = 4;
    pie.strokeColor = color.CGColor;
    pie.lineDashPattern = @[@3,@3];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:RADIUS startAngle:startAngle endAngle:endAngle clockwise:YES];
    pie.path = path.CGPath;
    pie.frame = CGRectMake(0, 0, self.view.frame.size.width/2 + 50, CIRCLE_HEIGHT + RADIUS*2 + 10);
    
    return pie;
}

# pragma mark - UITableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
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
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        // circle
        UILabel *circleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 33, cell.frame.size.height)];
        circleLabel.text = @"•";
        circleLabel.textAlignment = UIControlContentVerticalAlignmentCenter;
        UIFont *font = [UIFont systemFontOfSize:40];
        circleLabel.font = font;
        circleLabel.textColor = [self.colorArray objectAtIndex: indexPath.row % self.colorArray.count];
        circleLabel.tag = 111;
        [cell addSubview:circleLabel];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(circleLabel.frame.origin.x+circleLabel.frame.size.width, 0, cell.frame.size.width - (circleLabel.frame.origin.x+circleLabel.frame.size.width), cell.frame.size.height)];
        titleLabel.textAlignment = UIControlContentVerticalAlignmentCenter;
        titleLabel.text = [self.itemArray objectAtIndex:indexPath.row];
        titleLabel.tag = 112;
        [cell addSubview:titleLabel];

        // titleLabel
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-16, cell.frame.size.height)];
        numberLabel.textAlignment = UIControlContentVerticalAlignmentCenter;
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.text = [self.valueArray objectAtIndex:indexPath.row];
        numberLabel.tag = 113;
        [cell addSubview:numberLabel];
    }
    return cell;
}


#pragma mark - Orientation
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
