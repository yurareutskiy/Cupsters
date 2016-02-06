//
//  ListPlacesImagesViewController.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/7/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DataManager.h"


@interface ListPlacesImagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, DataManagerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *objectsArray;
- (IBAction)goToMap:(UIButton *)sender;
- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender;


@end
