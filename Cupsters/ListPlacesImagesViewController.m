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
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self setNeedsStatusBarAppearanceUpdate];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];

    [self customNavBar];
    
    [self preferredStatusBarStyle];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self configureMenu];
    
    pointOfInterest = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
}

-(void)viewWillAppear:(BOOL)animated {
    //self.source = [[DataManager sharedManager] getDataFromEntity:@"Cafes"];
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
                             @"(%@ <= longitude) AND (longitude <= %@)"
                             @"AND (%@ <= lattitude) AND (lattitude <= %@)",
                             @(minLongitude), @(maxLongitude), @(minLatitude), @(maxLatitude)];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    self.source = [context executeFetchRequest:fetchRequest error:&error];
    NSAssert(self.source != nil, @"Failed to execute %@: %@", fetchRequest, error);

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


// Create label with title and image
- (UILabel*)customTitleViewWithImage {
    
    // Create
    UILabel* navigationBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    
    // Create text attachment, which will contain and set text and image
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"smallCup"];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@"1 ЧАШКА  "];
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
    return [self.source count];
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
    
    NSManagedObject *object = [self.source objectAtIndex:row];
    
//    if ([[object valueForKey:@"image"] isEqualToString:@""]) {
//        // default image
//        imageURL = [NSURL URLWithString:@"http://lk.cupsters.ru/img/cafe/maxresdefault.jpg"];
//    } else {
//        imageURL = [NSURL URLWithString:[object valueForKey:@"image"]];
//    }
    
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://lk.cupsters.ru/%@", [object valueForKey:@"image"]]];
    NSLog(@"%@", imageURL);
//    imageURL = [NSURL URLWithString:@"http://lk.cupsters.ru/img/cafe/maxresdefault.jpg"];

    [cell.backPhoto setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"cafeBack1"]];
    [cell.placeName setText:[object valueForKey:@"name"]];
    [cell.underground setText:[object valueForKey:@"address"]];
    [cell.distance setText:@"2 км."];
    
    return cell;
}


- (IBAction)goToMap:(UIButton *)sender {
    [self performSegueWithIdentifier:@"goToMap" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToCafe"]) {
        CafeViewController *vc = (CafeViewController*)segue.destinationViewController;
        vc.cafe = [self.source objectAtIndex:((NSIndexPath*)sender).row];
        
        [userDefaults setObject:[((NSManagedObject*)[self.source objectAtIndex:((NSIndexPath*)sender).row]) valueForKey:@"name"] forKey:@"cafe"];
        [userDefaults setObject:[((NSManagedObject*)[self.source objectAtIndex:((NSIndexPath*)sender).row]) valueForKey:@"address"] forKey:@"address"];
    }

}
@end
