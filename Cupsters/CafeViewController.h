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
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *cafeView;
- (IBAction)openMap:(UIButton *)sender;


@end
