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
#import "User.h"
#import <RKDropdownAlert.h>

@interface CafeViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;

@property (strong, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;

@end

@implementation CafeViewController {
    NSInteger coffeeRows;
    NSInteger teaRows;
    NSInteger othereRows;
    NSManagedObjectContext *context;
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    BOOL openMap;
    CGFloat viewWidth;
    UIView *viewHeader;
    NSArray *volumeNum;
    NSUserDefaults *userDefaults;
    NSArray *source;
    NSDictionary *final;
    NSArray *sourceFinal;
    NSURL *telURL;
    UIAlertView *callAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoView.hidden = true;
    self.scrollViewAddon.delegate = self;
    callAlert.delegate = self;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self.name setText:[self.cafe valueForKey:@"name"]];
    [self.address setText:[self.cafe valueForKey:@"address"]];
    [self.distance setText:self.distanceText];
    [self.cafeBg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://lk.cupsters.ru/%@", [self.cafe valueForKey:@"image"]]]];
    [self.subwayLabel setText:[self.cafe valueForKey:@"subway_station"]];
    [userDefaults setObject:[self.cafe valueForKey:@"id"] forKey:@"id"];
    openMap = false;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self preferredStatusBarStyle];
    [self configureMenu];
    
    volumeNum = @[@150, @300, @450];
    
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, self.cafeView.frame.size.height, self.view.frame.size.width, 40.0)];
    [viewHeader setBackgroundColor:[UIColor whiteColor]];
    
    NSNumber *lat = [_cafe valueForKey:@"lattitude"];
    NSNumber *longi = [_cafe valueForKey:@"longitude"];
    
    GMSCameraPosition *camera = [GMSCameraPosition
                                 cameraWithLatitude:lat.doubleValue
                                 longitude:longi.doubleValue
                                 zoom:15];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(self.view.frame.origin.x, self.cafeView.frame.size.height, self.view.frame.size.width, 200.0) camera:camera];
    mapView.myLocationEnabled = YES;
    [mapView setBackgroundColor:[UIColor whiteColor]];
    [self.infoView setFrame:CGRectMake(0, mapView.frame.origin.y + mapView.frame.size.height, self.infoView.frame.size.width, self.infoView.frame.size.height)];
    
    [self.view addSubview:mapView];
    mapView.hidden = true;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat.doubleValue, longi.doubleValue);
    NSLog(@"coords: lat - %f, long - %f", lat.doubleValue, longi.doubleValue);
    marker.title = [_cafe valueForKey:@"name"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *oDate = [_cafe valueForKey:@"open"];
    NSDate *cDate = [_cafe valueForKey:@"close"];
    NSDate *owDate = [_cafe valueForKey:@"open_weekend"];
    NSDate *cwDate = [_cafe valueForKey:@"close_weekend"];
    formatter.dateFormat = @"HH:mm";
    NSString *openDate = [formatter stringFromDate:oDate];
    NSString *closeDate = [formatter stringFromDate:cDate];
    NSString *opewWDate = [formatter stringFromDate:owDate];
    NSString *closeWDate = [formatter stringFromDate:cwDate];
    
    [self.timeWeek setText:[NSString stringWithFormat:@"Пн-Вт %@ - %@", openDate, closeDate]];
    [self.timeWeekend setText:[NSString stringWithFormat:@"Пн-Вт %@ - %@", opewWDate, closeWDate]];
    [self.addons setText:[NSString stringWithFormat:@"%@", [_cafe valueForKey:@"addons"]]];
//
//    marker.snippet = [NSString stringWithFormat:@"%@ - %@", openDate, closeDate];
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
    //self.scrollView.contentSize = CGSizeMake(viewWidth * 3, self.tableView1.frame.size.height);
    
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
    
    //[self.scrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, self.scrollView.frame.size.height) animated:NO];
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, self.scrollView.frame.size.height) animated:YES];
    }];
    
    coffeeRows = 0;
    teaRows = 0;
    othereRows = 0;
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    self.menu.view.frame = CGRectMake(self.menu.view.frame.origin.x, 0.f, 280.f, self.menu.view.frame.size.height + 60.f);
    self.scrollViewAddon.contentSize = CGSizeMake(self.addons.frame.size.width, self.addons.frame.size.height);

}

-(void)viewWillAppear:(BOOL)animated {
    
    [_distance setText:self.distanceText];

    
    [self customNavBar];

    if (source == nil) {
        //self.source = [[DataManager sharedManager] getDataFromEntity:@"Cafes"];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        context = [appDelegate managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Coffees" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSNumber *idCafe = [_cafe valueForKey:@"id"];
        
        User *user = [User sharedUser];
        NSPredicate *predicate;
        if ([user.plan[@"type"] isEqualToString:@"standart"] && [[self.coffee valueForKey:@"in_standart"] isEqualToString:@"0"]) {
            predicate = [NSPredicate predicateWithFormat:
                                      @"%@ == id_cafe AND 0 == in_standart", idCafe];
        } else {
            predicate = [NSPredicate predicateWithFormat:
                                      @"%@ == id_cafe", idCafe];
        }
        [fetchRequest setPredicate:predicate];
        fetchRequest.propertiesToFetch = @[[[entity propertiesByName] objectForKey:@"name"], [[entity propertiesByName] objectForKey:@"type"], [[entity propertiesByName] objectForKey:@"icon"]];
        fetchRequest.returnsDistinctResults = YES;
        fetchRequest.resultType = NSDictionaryResultType;
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        
        NSError *error = nil;
        NSArray *fetchedResult = [context executeFetchRequest:fetchRequest error:&error];
        
        NSMutableArray *first = [[NSMutableArray alloc] init];
        NSMutableArray *second = [[NSMutableArray alloc] init];
        NSMutableArray *third = [[NSMutableArray alloc] init];
        for (int i = 0; i < [fetchedResult count]; i++) {
            NSString *type = [fetchedResult[i] valueForKey:@"type"];
            if ([type isEqualToString:@"coffee"]) {
                [first addObject:fetchedResult[i]];
                coffeeRows++;
            } else if ([type isEqualToString:@"tea"]) {
                [second addObject:fetchedResult[i]];
                teaRows++;
            } else if ([type isEqualToString:@"other"]) {
                [third addObject:fetchedResult[i]];
                othereRows++;
            }
        }
        int maxRows = MAX(MAX(coffeeRows, teaRows), othereRows);
        self.scrollView.contentSize = CGSizeMake(viewWidth * 3, MAX(self.scrollView.frame.size.height, 100 * maxRows));
        NSLog(@"Content size %@", NSStringFromCGSize(self.scrollView.contentSize));
        source = [NSArray arrayWithObjects:first, second, third, nil];
        NSLog(@"%@", source);
        NSAssert(source != nil, @"Failed to execute %@: %@", fetchRequest, error);
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentCounter"]];
    [myString appendAttributedString:attachmentString];
    
    // Configure our label
    navigationBarLabel.attributedText = myString;
    navigationBarLabel.font = [UIFont fontWithName:cFontMyraid size:18.f];
    navigationBarLabel.textColor = [UIColor whiteColor];
    navigationBarLabel.textAlignment = NSTextAlignmentCenter;
    
    return navigationBarLabel;
}


#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

// Tying up the segmented control to a scroll view



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case 1:
            return coffeeRows ? coffeeRows : 1;
            break;
        case 2:
            return teaRows ? teaRows : 1;
            break;
        case 3:
            return othereRows ? othereRows : 1;
            break;
        default:
            return 0;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CafeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cCellCoffee forIndexPath:indexPath];
    if (!cell) {
        cell = [[CafeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cCellCoffee];
    }

    switch (tableView.tag) {
        case 1:
            if (coffeeRows == 0) {
                cell.hidden = true;
                return cell;
            }
            break;
        case 2:
            if (teaRows == 0) {
                cell.hidden = true;
                return cell;
            }
            break;
        case 3:
            if (othereRows == 0) {
                cell.hidden = true;
                return cell;
            }
            break;
        default:
            break;

    }

    NSLog(@"%@\n%ld", indexPath, (long)tableView.tag);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSManagedObject *coffee = [[source objectAtIndex:tableView.tag - 1] objectAtIndex:indexPath.row];
        
    NSNumber *idCafeCell = [_cafe valueForKey:@"id"];
    cell.idCafe = idCafeCell.integerValue;
    
    cell.delegate = self;

    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://lk.cupsters.ru/%@BIG1.png", [coffee valueForKey:@"icon"]]];
    [cell.coffeePic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"cafeBack1"]];
    

    [cell.coffeeName setText:[coffee valueForKey:@"name"]];
    [cell setRow:indexPath.row];
    
    [cell loadDataInCell];
    
    return cell;

}


- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"yeap");
//    NSLog(@"%f", scrollView.contentOffset.x);
//    NSLog(@"%f", scrollView.contentOffset.y);

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
    

    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coffees" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSNumber *idCafe = [_cafe valueForKey:@"id"];
    NSString *name = ((CafeTableViewCell*)cell).coffeeName.text;
    NSNumber *volume = [[NSNumber alloc] initWithInt:((NSString*)((CafeTableViewCell*)cell).volumeNum[((CafeTableViewCell*)cell).index]).intValue];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_cafe == %@ AND name == %@ AND volume == %@", idCafe, name, volume];

    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    sourceFinal = [context executeFetchRequest:fetchRequest error:&error];
    NSAssert(source.count != 0, @"Failed to execute %@: %@", fetchRequest, error);
    
    [self performSegueWithIdentifier:@"makeOrder" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"makeOrder"]) {
        OrderViewController *vc = (OrderViewController*)segue.destinationViewController;
        
        vc.coffee = [sourceFinal objectAtIndex:0];
        vc.cafe = self.cafe;
    }
    
}



- (IBAction)openMap:(UIButton *)sender {

    
    if (!openMap) {
        openMap = true;
        [mapView setAlpha:0.0];
        mapView.hidden = false;
        [self.infoView setAlpha:0.0];
        self.infoView.hidden = false;
        [UIView animateWithDuration:0.5 animations:^{
            [mapView setAlpha:1.0];
            [self.infoView setAlpha:1.0];
        }];
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView1.frame = CGRectMake(self.tableView1.frame.origin.x, self.tableView1.frame.origin.y + mapView.frame.size.height + self.infoView.frame.size.height, self.tableView1.frame.size.width, self.tableView1.frame.size.height);
            self.tableView2.frame = CGRectMake(self.tableView2.frame.origin.x, self.tableView2.frame.origin.y + mapView.frame.size.height + self.infoView.frame.size.height, self.tableView2.frame.size.width, self.tableView2.frame.size.height);
            self.tableView3.frame = CGRectMake(self.tableView3.frame.origin.x, self.tableView3.frame.origin.y + mapView.frame.size.height + self.infoView.frame.size.height, self.tableView3.frame.size.width, self.tableView3.frame.size.height);
            _segmentedControl.frame = CGRectMake(_segmentedControl.frame.origin.x, _segmentedControl.frame.origin.y + mapView.frame.size.height + self.infoView.frame.size.height, _segmentedControl.frame.size.width, _segmentedControl.frame.size.height);
            self.infoView.frame = CGRectMake(self.infoView.frame.origin.x, mapView.frame.origin.y + mapView.frame.size.height, self.infoView.frame.size.width, self.infoView.frame.size.height);
        }];
    }
    else {
        openMap = false;
        [UIView animateWithDuration:0.25 animations:^{
            [mapView setAlpha:0.0];
            [self.infoView setAlpha:0.0];
        } completion:^ (BOOL finished) {
            mapView.hidden = true;
            self.infoView.hidden = true;
        }];
        [UIView animateWithDuration:0.5 animations:^{
        self.tableView1.frame = CGRectMake(self.tableView1.frame.origin.x, self.tableView1.frame.origin.y - mapView.frame.size.height - self.infoView.frame.size.height, self.tableView1.frame.size.width, self.tableView1.frame.size.height);
        self.tableView2.frame = CGRectMake(self.tableView2.frame.origin.x, self.tableView2.frame.origin.y - mapView.frame.size.height - self.infoView.frame.size.height, self.tableView2.frame.size.width, self.tableView2.frame.size.height);
        self.tableView3.frame = CGRectMake(self.tableView3.frame.origin.x, self.tableView3.frame.origin.y - mapView.frame.size.height - self.infoView.frame.size.height, self.tableView3.frame.size.width, self.tableView3.frame.size.height);
        _segmentedControl.frame = CGRectMake(_segmentedControl.frame.origin.x, _segmentedControl.frame.origin.y - mapView.frame.size.height - self.infoView.frame.size.height, _segmentedControl.frame.size.width, _segmentedControl.frame.size.height);
        }];
    }
}


- (BOOL)checkUserCanMakeOrder {
    User *user = [User sharedUser];
    NSLog(@"plan - %@", user.plan[@"type"]);
    NSLog(@"coffee - %d", [[self.coffee valueForKey:@"in_standart"] isEqualToString:@"0"]);
    if ([user.plan[@"type"] isEqualToString:@"standart"] && [[self.coffee valueForKey:@"in_standart"] isEqualToString:@"0"]) {
        return NO;
    }
    
    NSInteger counter = [user.counter intValue];
    if (counter == 0) {
        return NO;
    } else {
        NSDate *expiredDate = user.plan[@"endDate"];
        if (!expiredDate) {
            return YES;
        }
        NSInteger result = [expiredDate compare:[NSDate date]];
        if (result != 1) {
            return NO;
        }
    }
    return YES;
}


- (IBAction)makeCall:(UIButton *)sender {
    
    NSString *phNo = [_cafe valueForKey:@"phone"];
    if ([[phNo substringToIndex:1] isEqualToString:@"8"] ||
        [[phNo substringToIndex:2] isEqualToString:@"88"] ||
        [[phNo substringToIndex:3] isEqualToString:@"8(8"] ||
        [[phNo substringToIndex:1] isEqualToString:@"("]){
            phNo = [NSString stringWithFormat:@"+7%@", [phNo substringFromIndex:1]];
    }
    NSString *cleanedString = [[phNo componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+"] invertedSet]] componentsJoinedByString:@""];
    telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
    
    NSString *forAlert = [NSString stringWithFormat:@"Номер %@", cleanedString];
    if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
        callAlert = [[UIAlertView alloc] initWithTitle:@"Совершить вызов?" message:forAlert delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"Да", nil];
        [callAlert show];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Ошибка" message:@"Не удалось совершить вызов" delegate:nil cancelButtonTitle:@"Ок" otherButtonTitles:nil, nil];
        [calert show];
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [alertView cancelButtonIndex]){
        [[UIApplication sharedApplication] openURL:telURL];
    }
}
@end
