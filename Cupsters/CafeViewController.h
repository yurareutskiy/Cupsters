//
//  CafeViewController.h
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HMSegmentedControl.h"

@interface CafeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (strong, nonatomic) IBOutlet UIView *cafeView;
- (IBAction)openMap:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView2;
@property (strong, nonatomic) IBOutlet UITableView *tableView3;
@property (strong, nonatomic) IBOutlet UITableViewCell *tableCell;

@property (strong, nonatomic) NSManagedObjectModel *cafe;
//- (IBAction)plusBtn:(UIButton *)sender;
//- (IBAction)minusBtn:(UIButton *)sender;

@end
