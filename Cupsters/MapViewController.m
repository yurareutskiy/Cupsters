//
//  MapViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 16/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "MapViewController.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "PlacePhotoTableViewCell.h"
#import "MenuRevealViewController.h"
#import "SWRevealViewController.h"
#import "MapTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DataManager.h"
#import "CafeViewController.h"
#import "AppDelegate.h"
#import <RKDropdownAlert.h>

@interface MapViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;
//@property (strong, nonatomic) NSArray *source;

@end

static NSString *baseURL = @"http://cupsters.ru";

@implementation MapViewController {
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    CLLocation *pointOfInterest;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the location manager if this object does not
    // already have one.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];

    GMSCameraPosition *camera = [GMSCameraPosition
                                 cameraWithLatitude:locationManager.location.coordinate.latitude
                                 longitude:locationManager.location.coordinate.longitude
                                 zoom:15];
    
    pointOfInterest = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - _tableView.frame.size.height - 64.0) camera:camera];
    mapView.myLocationEnabled = YES;
    
    [self.view addSubview:mapView];
    
    
    mapView.layer.shadowColor = [[UIColor grayColor] CGColor];
    mapView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    mapView.layer.shadowRadius = 1.0f;
    mapView.layer.shadowOpacity = 0.5f;
    [mapView.layer setMasksToBounds:NO];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView;
    
    mapView.settings.myLocationButton = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self preferredStatusBarStyle];
    [self configureMenu];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    mapView.delegate = self;
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated {
    
    [self customNavBar];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    [self makeCafeMarker:mapView];
    
}

-(void)viewDidAppear:(BOOL)animated {
    self.menu.view.frame = CGRectMake(self.menu.view.frame.origin.x, 0.f, 280.f, self.menu.view.frame.size.height + 60.f);
}

-(void) makeCafeMarker:(GMSMapView*)map {
    
    for (int i = 0; i < self.objectsArray.count; i++) {
        
        NSManagedObject *cafe = [[self.objectsArray objectAtIndex:i] valueForKey:@"place"];
        NSNumber *longitude = [cafe valueForKey:@"longitude"];
        NSNumber *lattitude = [cafe valueForKey:@"lattitude"];
        NSString *name = [cafe valueForKey:@"name"];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(lattitude.doubleValue, longitude.doubleValue);
        marker.title = name;
        marker.snippet = name;
        marker.map = map;
        marker.icon = [self makePin:(i + 1)];
        marker.userData = [[NSNumber alloc] initWithInt:i];
    }
    
}

- (UIImage*)makePin:(NSInteger)row {
    
    UIImage *image = [UIImage imageNamed:@"brownPin"];
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height / 2)];
    [number setText:[NSString stringWithFormat:@"%d", row]];
    [number setTextAlignment:NSTextAlignmentCenter];
    [number setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:13.0]];
    [number setTextColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0]];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [number drawTextInRect:CGRectMake(0, 4, image.size.width, image.size.height / 2)];
    UIImage *resultImage  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    [self performSegueWithIdentifier:@"goToCafe" sender:marker.userData];
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
    
    
    // Add gesture recognizer
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    // Set menu button
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self.revealViewController
                                                      action:@selector(revealToggle:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}

- (UILabel*)customTitleViewWithImage {
    
    // Create
    UILabel* navigationBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    
    // Create text attachment, which will contain and set text and image
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"smallCup"];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentCounter"]];
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString* title = @"Нет данных о геолокации";
    NSString* message = @" Мы не можем Вас найти. Пожалуйста, включите геолокацию";
    [RKDropdownAlert title:title message:message backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil time:5];
}

#pragma mark - Table View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:false];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self performSegueWithIdentifier:@"goToCafe" sender:[[NSNumber alloc] initWithInt:indexPath.row]];
    NSLog(@"Select row at index %@", indexPath);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objectsArray.count;
}

-(MapTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mapCell";
    
    MapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return [self configurePlace:cell At:indexPath.row]; //[self configurePlace:cell At:indexPath.row];
}

-(MapTableViewCell*)configurePlace:(MapTableViewCell*)cell At:(NSInteger)row {
    
    NSManagedObject *object = [[self.objectsArray objectAtIndex:row] valueForKey:@"place"];
    
//    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://lk.cupsters.ru/%@", [object valueForKey:@"icon"]]];
    [cell.numberRow setText:[NSString stringWithFormat:@"%d", row + 1]];
    [cell.logo setImageWithURL:[NSURL URLWithString:@"http://cupsters.ru/img/logo_red.png"]];
    [cell.name setText:[object valueForKey:@"name"]];
    [cell.underground setText:[object valueForKey:@"address"]];
    [cell.distance setText:[[self.objectsArray objectAtIndex:row] valueForKey:@"distanceText"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goToList:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
//    [self performSegueWithIdentifier:@"goToList" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goToCafe"]) {
        NSInteger row = ((NSNumber*)sender).intValue;
        CafeViewController *vc = (CafeViewController*)segue.destinationViewController;
        vc.cafe = [[self.objectsArray objectAtIndex:row] valueForKey:@"place"];
        vc.distanceText = [[self.objectsArray objectAtIndex:row] valueForKey:@"distanceText"];
    }
}

@end
