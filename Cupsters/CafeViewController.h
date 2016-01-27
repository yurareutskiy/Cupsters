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
#import "CafeTableViewCell.h"
#import <CoreData/CoreData.h>

@interface CafeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, CLLocationManagerDelegate, CafeTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (strong, nonatomic) IBOutlet UIView *cafeView;
- (IBAction)openMap:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView2;
@property (strong, nonatomic) IBOutlet UITableView *tableView3;
@property (strong, nonatomic) NSManagedObject *cafe;
@property (strong, nonatomic) NSManagedObject *coffee;
@property (strong, nonatomic) IBOutlet UIImageView *cafeBg;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *address;

//- (IBAction)plusBtn:(UIButton *)sender;
//- (IBAction)minusBtn:(UIButton *)sender;

@end
