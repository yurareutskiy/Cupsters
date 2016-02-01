//
//  MapViewController.h
//  Cupsters
//
//  Created by Anton Scherbakov on 16/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;

@interface MapViewController : UIViewController<CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *objectsArray;
- (IBAction)goToList:(UIButton *)sender;

@end
