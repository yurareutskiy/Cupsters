//
//  CafeViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "CafeViewController.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "MenuRevealViewController.h"
#import "SWRevealViewController.h"
#import "CafeTableViewCell.h"
@import GoogleMaps;
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AppDelegate.h"
#import "OrderViewController.h"

@interface CafeViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;

@property (strong, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;

@end

@implementation CafeViewController {
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    BOOL openMap;
    CGFloat viewWidth;
    UIView *viewHeader;
    NSArray *volumeNum;
    NSUserDefaults *userDefaults;
    NSArray *source;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [_name setText:[NSString stringWithFormat:@"%@", [_cafe valueForKey:@"name"]]];
    [_address setText:[NSString stringWithFormat:@"%@", [_cafe valueForKey:@"address"]]];
    [_cafeBg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://lk.cupsters.ru/%@", [_cafe valueForKey:@"image"]]]];
    [userDefaults setObject:[_cafe valueForKey:@"id"] forKey:@"id"];
    openMap = false;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self customNavBar];
    [self preferredStatusBarStyle];
    [self configureMenu];
    
    volumeNum = @[@150, @300, @450];
    
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, self.cafeView.frame.size.height, self.view.frame.size.width, 40.0)];
    [viewHeader setBackgroundColor:[UIColor whiteColor]];
    
    GMSCameraPosition *camera = [GMSCameraPosition
                                 cameraWithLatitude:locationManager.location.coordinate.latitude
                                 longitude:locationManager.location.coordinate.longitude
                                 zoom:15];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(self.view.frame.origin.x, self.cafeView.frame.size.height, self.view.frame.size.width, 200.0) camera:camera];
    mapView.myLocationEnabled = YES;
    [mapView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:mapView];
    mapView.hidden = true;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    NSNumber *lat = [_cafe valueForKey:@"lattitude"];
    NSNumber *longi = [_cafe valueForKey:@"longitude"];
    marker.position = CLLocationCoordinate2DMake(lat.doubleValue, longi.doubleValue);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView;
    marker.icon = [UIImage imageNamed:@"brownPin"];
    mapView.settings.myLocationButton = YES;
    
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    
    viewWidth = self.view.frame.size.width;
    
    
    
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(-0.5, self.cafeView.frame.size.height - 0.5, self.view.frame.size.width + 1.0, 40.0 + 0.5)];
    _segmentedControl.sectionTitles = @[@"Кофе", @"Чай",@"Другое"];
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]};
    _segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0];
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    _segmentedControl.tag = 3;
    _segmentedControl.layer.borderColor = [UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0].CGColor;
    _segmentedControl.layer.borderWidth = 0.5f;
    [self.view addSubview:_segmentedControl];
    //[viewHeader addSubview:_segmentedControl];
    
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.view.frame.size.width * 3, self.scrollView.frame.size.height);
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView1.frame = CGRectMake(0, 0, viewWidth, self.scrollView.frame.size.height);
    self.tableView2.frame = CGRectMake(viewWidth, 0, viewWidth, self.scrollView.frame.size.height);
    self.tableView3.frame = CGRectMake(viewWidth * 2, 0, viewWidth, self.scrollView.frame.size.height);
    
    [self.scrollView addSubview:self.tableView1];
    [self.scrollView addSubview:self.tableView2];
    [self.scrollView addSubview:self.tableView3];
    
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 3, self.scrollView.frame.size.height);
    
    //[self.scrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, self.scrollView.frame.size.height) animated:NO];
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, self.scrollView.frame.size.height) animated:YES];
    }];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    
    //self.source = [[DataManager sharedManager] getDataFromEntity:@"Cafes"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Coffees" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"%@ <= id_cafe", [_cafe valueForKey:@"id"]];
    [fetchRequest setPredicate:predicate];
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"name"]];
    fetchRequest.returnsDistinctResults = YES;
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    source = [context executeFetchRequest:fetchRequest error:&error];
    NSAssert(source != nil, @"Failed to execute %@: %@", fetchRequest, error);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(backAction:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
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


#pragma mark - Table View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        
        NSLog(@"Select row at index %d in table %ld, volume is %@", indexPath.row, (long)tableView.tag, [userDefaults objectForKey:@"volume"]);
        
    } else if (tableView.tag == 2) {

        NSLog(@"Select row at index %d in table %ld, volume is %@", indexPath.row, (long)tableView.tag, [userDefaults objectForKey:@"volume"]);
        
    } else {

        NSLog(@"Select row at index %d in table %ld, volume is %@", indexPath.row, (long)tableView.tag, [userDefaults objectForKey:@"volume"]);
        
    }
    
    //    [self.tableView1 deselectRowAtIndexPath:indexPath animated:false];
    //    [self.tableView1 reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
        return 1;
    }
    else if (tableView.tag == 2) {
        return 1;
    }
    else if (tableView.tag == 3) {
        return 1;
    }
    else {
        return 1;
    }
}

// Tying up the segmented control to a scroll view



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return source.count;
    }
    else if (tableView.tag == 2) {
        return 10;
    }
    else if (tableView.tag == 3) {
        return 10;
    }
    else {
        return 10;
    }
}

-(CafeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        CafeTableViewCell *cell = [self.tableView1 dequeueReusableCellWithIdentifier:@"cafeCell" forIndexPath:indexPath];
        
        NSNumber *idCafeCell = [_cafe valueForKey:@"id"];
        cell.idCafe = idCafeCell.integerValue;
        
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        [cell.plus addTarget:self action:@selector(plusBtn:index:for:plus:minus:) with forControlEvents:UIControlEventTouchUpInside];
//        [cell.minus addTarget:self action:@selector(minusBtn:index:for:plus:minus:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.coffeeName setText:[source[indexPath.row] valueForKey:@"name"]];
        [cell setRow:indexPath.row];
        
        return cell;
    }
    else if (tableView.tag == 2) {
        CafeTableViewCell *cell = [self.tableView2 dequeueReusableCellWithIdentifier:@"cafeCell" forIndexPath:indexPath];
        NSNumber *idCafeCell = [_cafe valueForKey:@"id"];
        cell.idCafe = idCafeCell.integerValue;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.coffeeName setText:@"lol"];
        [cell setRow:indexPath.row];
        return cell;
    }
    else if (tableView.tag == 3) {
        CafeTableViewCell *cell = [self.tableView3 dequeueReusableCellWithIdentifier:@"cafeCell" forIndexPath:indexPath];
        NSNumber *idCafeCell = [_cafe valueForKey:@"id"];
        cell.idCafe = idCafeCell.integerValue;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.coffeeName setText:@"lol"];
        [cell setRow:indexPath.row];
        
        return cell;
    }
    else {
        CafeTableViewCell *cell = [self.tableView1 dequeueReusableCellWithIdentifier:@"cafeCell" forIndexPath:indexPath];
        NSNumber *idCafeCell = [_cafe valueForKey:@"id"];
        cell.idCafe = idCafeCell.integerValue;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.coffeeName setText:@"lol"];
        [cell setRow:indexPath.row];
        
        return cell;
    }
    
    
    //[self configurePlace:cell At:indexPath.row];
}


-(CafeTableViewCell*)configurePlace:(CafeTableViewCell*)cell At:(NSInteger)row {
    

    
    return cell;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"yeap");
    NSLog(@"%f", scrollView.contentOffset.x);
    NSLog(@"%f", scrollView.contentOffset.y);
    
    if (self.scrollView.contentOffset.x >= 0 && self.scrollView.contentOffset.x <= 106) {
        [self.segmentedControl setSelectedSegmentIndex:0 animated:YES];
    }
    else if (self.scrollView.contentOffset.x >= 212 && self.scrollView.contentOffset.x <= 520) {
        [self.segmentedControl setSelectedSegmentIndex:1 animated:YES];
    }
    else if (self.
             scrollView.contentOffset.x >= 616) {
        [self.segmentedControl setSelectedSegmentIndex:2 animated:YES];
    }
}

- (void) makeOrder:(UITableViewCell*)cell {
    
    [userDefaults setObject:[NSString stringWithFormat:@"%@", ((CafeTableViewCell*)cell).volumeNum[((CafeTableViewCell*)cell).index]] forKey:@"volume"];
    [userDefaults setObject:((CafeTableViewCell*)cell).coffeeName.text forKey:@"coffee"];
    
    [self performSegueWithIdentifier:@"makeOrder" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"makeOrder"]) {
        OrderViewController *vc = (OrderViewController*)segue.destinationViewController;
        vc.cafe = [source objectAtIndex:((NSIndexPath*)sender).row];
        
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

//- (IBAction)makeAnOrder:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"makeOrder" sender:self];
//}


- (IBAction)openMap:(UIButton *)sender {

    
    if (!openMap) {
        openMap = true;
        [mapView setAlpha:0.0];
        mapView.hidden = false;
        [UIView animateWithDuration:0.5 animations:^{
            [mapView setAlpha:1.0];
        }];
        [UIView animateWithDuration:0.25 animations:^{
        self.tableView1.frame = CGRectMake(self.tableView1.frame.origin.x, self.tableView1.frame.origin.y + mapView.frame.size.height, self.tableView1.frame.size.width, self.tableView1.frame.size.height);
        self.tableView2.frame = CGRectMake(self.tableView2.frame.origin.x, self.tableView2.frame.origin.y + mapView.frame.size.height, self.tableView2.frame.size.width, self.tableView2.frame.size.height);
        self.tableView3.frame = CGRectMake(self.tableView3.frame.origin.x, self.tableView3.frame.origin.y + mapView.frame.size.height, self.tableView3.frame.size.width, self.tableView3.frame.size.height);
        _segmentedControl.frame = CGRectMake(_segmentedControl.frame.origin.x, _segmentedControl.frame.origin.y + mapView.frame.size.height, _segmentedControl.frame.size.width, _segmentedControl.frame.size.height);
        }];
    }
    else {
        openMap = false;
        [UIView animateWithDuration:0.25 animations:^{
            [mapView setAlpha:0.0];
        } completion:^ (BOOL finished) {
            mapView.hidden = true;
        }];
        [UIView animateWithDuration:0.5 animations:^{
        self.tableView1.frame = CGRectMake(self.tableView1.frame.origin.x, self.tableView1.frame.origin.y - mapView.frame.size.height, self.tableView1.frame.size.width, self.tableView1.frame.size.height);
        self.tableView2.frame = CGRectMake(self.tableView2.frame.origin.x, self.tableView2.frame.origin.y - mapView.frame.size.height, self.tableView2.frame.size.width, self.tableView2.frame.size.height);
        self.tableView3.frame = CGRectMake(self.tableView3.frame.origin.x, self.tableView3.frame.origin.y - mapView.frame.size.height, self.tableView3.frame.size.width, self.tableView3.frame.size.height);
        _segmentedControl.frame = CGRectMake(_segmentedControl.frame.origin.x, _segmentedControl.frame.origin.y - mapView.frame.size.height, _segmentedControl.frame.size.width, _segmentedControl.frame.size.height);
        }];
    }
}
//- (IBAction)plusBtn:(UIButton *)sender index:(NSInteger)index for:(UILabel*)volume plus:(UIButton*)plus minus:(UIButton*)minus {
//    if (index + 2 == volumeNum.count) {
//        [volume setText:[NSString stringWithFormat:@"%@ мл", volumeNum[index + 1]]];
//        [plus setImage:[UIImage imageNamed:@"plusGrey"] forState:UIControlStateNormal];
//    } else if (index + 2 < volumeNum.count) {
//        [volume setText:[NSString stringWithFormat:@"%@ мл", volumeNum[index + 1]]];
//        [minus setImage:[UIImage imageNamed:@"minusBrown"] forState:UIControlStateNormal];
//    }
//}
//
//- (IBAction)minusBtn:(UIButton *)sender index:(NSInteger)index for:(UILabel*)volume plus:(UIButton*)plus minus:(UIButton*)minus {
//    if (index + 1 == 2) {
//        [volume setText:[NSString stringWithFormat:@"%@ мл", volumeNum[index - 1]]];
//        [minus setImage:[UIImage imageNamed:@"minusGrey"] forState:UIControlStateNormal];
//    } else if (index + 1 > 2) {
//        [volume setText:[NSString stringWithFormat:@"%@ мл", volumeNum[index - 1]]];
//        [plus setImage:[UIImage imageNamed:@"plusBrown"] forState:UIControlStateNormal];
//    }
//}
@end
