//
//  ListPlacesImagesViewController.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/7/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "ListPlacesImagesViewController.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "PlacePhotoTableViewCell.h"
#import "MenuRevealViewController.h"
#import "SWRevealViewController.h"
#import "DataManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "CafeViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
@import GoogleMaps;

@interface ListPlacesImagesViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;
@property (strong, nonatomic) NSArray *source;

@end

@implementation ListPlacesImagesViewController {
    NSUserDefaults *userDefaults;
    CLLocationManager *locationManager;
    CLLocation *pointOfInterest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishLoadingDataFromEntity:)
                                                 name:kNotificatiionLoading
                                               object:nil];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    


    
    [self preferredStatusBarStyle];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self configureMenu];
    
    pointOfInterest = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"horizontal Accuracy: %f", [locations firstObject].horizontalAccuracy);
    NSLog(@"vertical Accuracy: %f\n", [locations firstObject].verticalAccuracy);

    if ([locations firstObject].horizontalAccuracy < 10.f && [locations firstObject].verticalAccuracy < 10.f) {
        [manager stopUpdatingLocation];
        pointOfInterest = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
        [self fetchData];
        [self completeDistanceArray];
        [self.table reloadData];

    }
//    [locationManager stopUpdatingLocation];
}

-(void)viewDidDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)finishLoadingDataFromEntity:(NSNotification*)notification {
    if ([[notification object] isEqualToString:@"Cafes"]) {

        [self fetchData];
        [self.table reloadData];
    }
}

- (void) reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(GMSReverseGeocodeCallback)handler {
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self customNavBar];

    if (self.source == nil) {
        [self fetchData];
    }
}

- (void)fetchData {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Cafes" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    static double const D = 5000000. * 1.1;
    double const R = 6371009.; // Earth readius in meters
    double meanLatitidue = pointOfInterest.coordinate.latitude * M_PI / 180.;
    double deltaLatitude = D / R * 180. / M_PI;
    double deltaLongitude = D / (R * cos(meanLatitidue)) * 180. / M_PI;
    double minLatitude = pointOfInterest.coordinate.latitude - deltaLatitude;
    double maxLatitude = pointOfInterest.coordinate.latitude + deltaLatitude;
    double minLongitude = pointOfInterest.coordinate.longitude - deltaLongitude;
    double maxLongitude = pointOfInterest.coordinate.longitude + deltaLongitude;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(%f <= longitude) AND (longitude <= %f) AND (%f <= lattitude) AND (lattitude <= %f)",
                              minLongitude, maxLongitude, minLatitude, maxLatitude];
    
//    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    self.source = [context executeFetchRequest:fetchRequest error:&error];
    NSAssert(self.source != nil, @"Failed to execute %@: %@", fetchRequest, error);
    [self completeDistanceArray];

}

- (void)completeDistanceArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSManagedObject *place;
    NSString *address;
    NSString *distanceText;
    NSLog(@"lat - %f, lon - %f", pointOfInterest.coordinate.latitude, pointOfInterest.coordinate.longitude);
    for (int i = 0; i < [self.source count]; i++) {
        place = [self.source objectAtIndex:i];
        address = [place valueForKey:@"address"];
        double longitude = ((NSNumber*)[self.source[i] valueForKey:@"longitude"]).doubleValue;
        double lattitude = ((NSNumber*)[self.source[i] valueForKey:@"lattitude"]).doubleValue;
        CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:lattitude longitude:longitude];
        double distance = [pointOfInterest distanceFromLocation:placeLocation];
        
        if (distance < 1000.f) {
            distanceText = [NSString stringWithFormat:@"%d м", (int)distance];
        } else {
            distanceText = [NSString stringWithFormat:@"%d км", ((int)(distance + 500.f))/1000];
        }
        array[i] = @{@"distanceText":distanceText, @"distanceRaw":[NSNumber numberWithDouble:distance], @"place":place};
    }
    
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"distanceRaw" ascending:NO];
    self.objectsArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        double value1 = ((NSNumber*)[obj1 valueForKey:@"distanceRaw"]).doubleValue;
        double value2 = ((NSNumber*)[obj2 valueForKey:@"distanceRaw"]).doubleValue;
        if (value1 > value2) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedAscending;
        }
    }];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void)viewDidAppear:(BOOL)animated {
    self.menu.view.frame = CGRectMake(self.menu.view.frame.origin.x, 0.f, 280.f, self.menu.view.frame.size.height + 60.f);
}

- (void)customNavBar {
    
    // Set background color
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHEX:cBrown];
    self.navigationController.navigationBar.translucent = NO;
    
    
    // Set title view
    
    self.navigationItem.titleView = [self customTitleViewWithImage];

}

- (void)configureMenu {
    
    self.reveal = self.revealViewController;
    
    if (!self.reveal) {
        return;
    }
    

    

    
    // Set menu button
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self.revealViewController
                                                      action:@selector(revealToggle:)];
    
    // Add gesture recognizer
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}


// Create label with title and image
- (UILabel*)customTitleViewWithImage {
    
    // Create
    UILabel* navigationBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    
    // Create text attachment, which will contain and set text and image
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"smallCup"];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[ud objectForKey:@"currentCounter"]];
    [myString appendAttributedString:attachmentString];
    
    // Configure our label
    navigationBarLabel.attributedText = myString;
    navigationBarLabel.font = [UIFont fontWithName:cFontMyraid size:18.f];
    navigationBarLabel.textColor = [UIColor whiteColor];
    navigationBarLabel.textAlignment = NSTextAlignmentCenter;

    return navigationBarLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Actions




#pragma mark - UITableView




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.table deselectRowAtIndexPath:indexPath animated:false];
    [self.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self performSegueWithIdentifier:@"goToCafe" sender:indexPath];
    NSLog(@"Select row at index %@", indexPath);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objectsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PlacePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cCellBigPlace forIndexPath:indexPath];
    if (!cell) {
        cell = [[PlacePhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cCellBigPlace];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return [self configurePlace:cell At:indexPath.row];
}

-(PlacePhotoTableViewCell*)configurePlace:(PlacePhotoTableViewCell*)cell At:(NSInteger)row {
    
    NSManagedObject *object = [[self.objectsArray objectAtIndex:row] valueForKey:@"place"];
    
//    if ([[object valueForKey:@"image"] isEqualToString:@""]) {
//        // default image
//        imageURL = [NSURL URLWithString:@"http://lk.cupsters.ru/img/cafe/maxresdefault.jpg"];
//    } else {
//        imageURL = [NSURL URLWithString:[object valueForKey:@"image"]];
//    }
    if ([object valueForKey:@"name"] == nil) {
//        [self fetchData];
    }
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://lk.cupsters.ru/%@", [object valueForKey:@"image"]]];
    NSLog(@"%@", imageURL);
//    imageURL = [NSURL URLWithString:@"http://lk.cupsters.ru/img/cafe/maxresdefault.jpg"];
    [cell.distance setText:[[self.objectsArray objectAtIndex:row] valueForKey:@"distanceText"]];
    [cell.backPhoto setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"cafeBack1"]];
    [cell.placeName setText:[object valueForKey:@"name"]];
    [cell.underground setText:[object valueForKey:@"address"]];
//    [cell.distance setText:@"2 км."];
    
    return cell;
}


- (IBAction)goToMap:(UIButton *)sender {
    [self performSegueWithIdentifier:@"goToMap" sender:self];
////    MainView *nextView = [[MainView alloc] init];
//    [UIView animateWithDuration:0.75
//                     animations:^{
//                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
////                         [self.navigationController pushViewController:nextView animated:NO];
//                         [self performSegueWithIdentifier:@"goToMap" sender:self];
//                         [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
//                     }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToCafe"]) {
        CafeViewController *vc = (CafeViewController*)segue.destinationViewController;
        NSInteger row = ((NSIndexPath*)sender).row;
        NSManagedObject *cafe = [[self.objectsArray objectAtIndex:row] valueForKey:@"place"];
        vc.cafe = cafe;
        vc.distanceText = [[self.objectsArray objectAtIndex:((NSIndexPath*)sender).row] valueForKey:@"distanceText"];

    } else if ([segue.identifier isEqualToString:@"goToMap"]) {
        MapViewController *vc = segue.destinationViewController;
        vc.objectsArray = self.objectsArray;
    
    }
//    } else if ([segue.identifier isEqualToString:@"goToMap"]) {
//        UIViewController *destination = segue.destinationViewController;
//        NSMutableArray *viewControllers = self.navigationController.viewControllers;
//        segue.destinationViewController.navigationController.navigationBarHidden = false;
//        [self.navigationController setViewControllers:viewControllers];
//    }

}



- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender {
}

@end
