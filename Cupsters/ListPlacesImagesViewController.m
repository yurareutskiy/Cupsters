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
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (strong, nonatomic) SWRevealViewController *reveal;
@property (strong, nonatomic) NSArray *source;

@end

@implementation ListPlacesImagesViewController {
    NSUserDefaults *userDefaults;
    CLLocationManager *locationManager;
    CLLocation *pointOfInterest;
    NSMutableArray *filteredTableData;
    NSManagedObjectContext *context;
    NSArray *fullData;
    BOOL wasSegue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishLoadingDataFromEntity:)
                                                 name:kNotificatiionLoading
                                               object:nil];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self setNeedsStatusBarAppearanceUpdate];
    
    pointOfInterest = [[CLLocation alloc] initWithLatitude:55.7522200 longitude:37.6155600];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    self.table.backgroundColor = [UIColor clearColor];
    
//    self.searchBar.frame = CGRectMake(0.0, -44.0, self.view.frame.size.width, 44);

    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self configureMenu];
//    [self.table setContentOffset:CGPointMake(0, 44)];

//    pointOfInterest = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
}

-(void)viewWillAppear:(BOOL)animated {
    self.searchBar.barTintColor = [UIColor colorWithHEX:cBrown];
    [self preferredStatusBarStyle];
    [self customNavBar];
    
    if (self.source == nil) {
        [self fetchData];
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"horizontal Accuracy: %f", [locations firstObject].horizontalAccuracy);
    NSLog(@"vertical Accuracy: %f\n", [locations firstObject].verticalAccuracy);

//    if ([locations firstObject].horizontalAccuracy < 50.f || [locations firstObject].verticalAccuracy < 50.f) {
        [manager stopUpdatingLocation];
        pointOfInterest = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
        [self fetchData];
        [self completeDistanceArray:self.source];
        [self.table reloadData];
        [locationManager stopUpdatingLocation];
//    }
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


- (void)fetchData {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Cafes" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    static double const D = 5000000. * 1.1;
    double const R = 6371009.; // Earth readius in meter=
    double meanLatitidue = pointOfInterest.coordinate.latitude * M_PI / 180.;
    double deltaLatitude = D / R * 180. / M_PI;
    double deltaLongitude = D / (R * cos(meanLatitidue)) * 180. / M_PI;
    double minLatitude = pointOfInterest.coordinate.latitude - deltaLatitude;
    double maxLatitude = pointOfInterest.coordinate.latitude + deltaLatitude;
    double minLongitude = pointOfInterest.coordinate.longitude - deltaLongitude;
    double maxLongitude = pointOfInterest.coordinate.longitude + deltaLongitude;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(%f <= longitude) AND (longitude <= %f) AND (%f <= lattitude) AND (lattitude <= %f) AND (status = %@)",
                              minLongitude, maxLongitude, minLatitude, maxLatitude, @1];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    self.source = [context executeFetchRequest:fetchRequest error:&error];
    NSAssert(self.source != nil, @"Failed to execute %@: %@", fetchRequest, error);
    [self completeDistanceArray:self.source];

}

- (void)completeDistanceArray:(NSArray*)dataArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSManagedObject *place;
    NSString *address;
    NSString *distanceText;
    NSLog(@"lat - %f, lon - %f", pointOfInterest.coordinate.latitude, pointOfInterest.coordinate.longitude);
    for (int i = 0; i < [dataArray count]; i++) {
        place = [dataArray objectAtIndex:i];
        address = [place valueForKey:@"address"];
        double longitude = ((NSNumber*)[dataArray[i] valueForKey:@"longitude"]).doubleValue;
        double lattitude = ((NSNumber*)[dataArray[i] valueForKey:@"lattitude"]).doubleValue;
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
    self.table.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);

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
    self.searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(performSearch)];
    
    // Add gesture recognizer
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    
    self.navigationItem.leftBarButtonItem = self.menuButton;
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self performSegueWithIdentifier:@"goToCafe" sender:indexPath];
    NSLog(@"Select row at index %@", indexPath);
    [self.view endEditing:YES];
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
    
    if ([object valueForKey:@"name"] == nil) {
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
    wasSegue = 1;
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

#pragma mark - Search

- (void)performSearch {
    if (self.searchBar.frame.origin.y == 0) {
        [self hideSearch:self];
        return;
    }
    NSLog(@"Search %@", NSStringFromCGRect(self.searchBar.frame));

    [UIView animateWithDuration:0.3 animations:^{
        if (!wasSegue) {
            self.table.contentOffset = CGPointMake(0.0, -44.0);
        }
        self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            if (wasSegue) {
                self.table.contentOffset = CGPointMake(0.0, -44.0);
                self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
            }
        }];
    }];
    [self.searchBar becomeFirstResponder];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSearch:)];
    [self.table addGestureRecognizer:tapRecognizer];
    NSLog(@"Search 2 %@", self.searchBar);
}

- (void)hideSearch:(id)sender {
    if ([sender isKindOfClass:[UITableView class]]) {
    }
    [self.table removeGestureRecognizer:[self.table.gestureRecognizers lastObject]];
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.table.contentOffset = CGPointMake(0.0, 0.0);
        self.searchBar.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);
    }];
}

-(void)filter:(NSString*)text {
    filteredTableData = [[NSMutableArray alloc] init];
    
    // Create our fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Define the entity we are looking for
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Cafes" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Define how we want our entities to be sorted
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"name" ascending:YES];
    
    // If we are searching for anything...
    if(text.length != 0) {
        // Define how we want our entities to be filtered
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[c] %@) OR (address CONTAINS[c] %@)", text, text];
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *error;
    
    // Finally, perform the load
    NSArray* loadedEntities = [context executeFetchRequest:fetchRequest error:&error];
    filteredTableData = [[NSMutableArray alloc] initWithArray:loadedEntities];
    [self completeDistanceArray:filteredTableData];
    [self.table reloadData];
}

#pragma mark - UISearchBar Delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"text = %@", searchText);
//    NSLog(@"first object 1 = %@", [searchResults firstObject]);
    [self filter:searchText];
//    [self.table reloadData];
//    NSLog(@"first object 2 = %@", [searchResults firstObject]);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.searchBar.frame.origin.y == 0 && [scrollView isEqual:self.table]) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.searchBar.frame = CGRectMake(0, -44.f, self.view.frame.size.width, 44);
//            self.table.contentOffset = CGPointMake(0.0, 0.0);
//        }];
//        [self.view endEditing:YES];
//
//    }
    NSLog(@"%@", scrollView);
}



@end
