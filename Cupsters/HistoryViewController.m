//
//  HistoryViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 18/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "MenuRevealViewController.h"
#import "SWRevealViewController.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OrderViewController.h"
#import <SCLAlertView.h>
#import "Server.h"
#import "User.h"

@interface HistoryViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;
@property (strong, nonatomic) NSArray *source;

@end

@implementation HistoryViewController {
    NSArray *logoURLs;
    NSManagedObjectContext *context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self customNavBar];
    [self preferredStatusBarStyle];
    [self configureMenu];
    logoURLs = [self completeIconArrayForCoffee];
    
    self.source = [[DataManager sharedManager] getDataFromEntity:@"Orders"];
    
    Server *server = [[Server alloc] init];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
    NSString *user_id = user.id.stringValue;
    ServerRequest *request = [ServerRequest initRequest:ServerRequestTypeGET With:@{@"type" : @"history", @"user_id" : user_id} To:OrderURLStrring];
    [server sentToServer:request OnSuccess:^(id result) {
        self.source = [[DataManager sharedManager] getOrders:result];
        [self.tableView reloadData];
    } OrFailure:^(NSError *error) {
        NSLog(@"%@", [error debugDescription]);
    }];

}

-(void)viewWillAppear:(BOOL)animated {
    
    
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
                                                      action:@selector(toList:)];
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}

- (void)toList:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
    [self presentViewController:vc animated:true completion:nil];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.source count];
}


- (HistoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"histCell" forIndexPath:indexPath];
    
    NSManagedObject *order = self.source[indexPath.row];

    
    [cell.cafeName setText:[order valueForKey:@"cafe"]];
    
    NSString *coffeeName = [order valueForKey:@"coffee"];
    [cell.coffeeName setText:coffeeName];
    [cell.coffeePic setImageWithURL:[self urlForCoffee:coffeeName] placeholderImage:[UIImage imageNamed:@"americano"]];
    [cell.coffeeVol setText:[NSString stringWithFormat:@"%@ мл", [order valueForKey:@"volume"]]];
    
    NSString *status = [order valueForKey:@"orderstatus"];
    if ([status isEqualToString:@"Заказ готов"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"y-M-d H:m:s";
        NSDate *date = [formatter dateFromString:[order valueForKey:@"date"]];
        formatter.dateFormat = @"d MMM yy";
        NSString *lastDate = [[formatter stringFromDate:date] uppercaseString];
        lastDate = [lastDate stringByReplacingOccurrencesOfString:@"." withString:@""];
        [cell.date setText:lastDate];
    } else {
        [cell.date setText:[order valueForKey:@"orderstatus"]];
    }
    
    
    return cell;
}

- (NSArray*)completeIconArrayForCoffee {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coffees" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    fetchRequest.propertiesToFetch = @[[[entity propertiesByName] objectForKey:@"icon"], [[entity propertiesByName] objectForKey:@"name"]];
    fetchRequest.returnsDistinctResults = YES;
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"%@", fetchedObjects);
    return fetchedObjects;
}

- (NSURL*)urlForCoffee:(NSString*)coffeeName {
    for (NSDictionary *coffee in logoURLs) {
        if ([((NSString*)[coffee valueForKey:@"name"]) isEqualToString:coffeeName]) {
            NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://lk.cupsters.ru%@BIG1.png", [coffee valueForKey:@"icon"]]];
            return imageURL;
        }
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://lk.cupsters.ru/img/icons/americanoBIG1.png"]];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:false];
    
    [self performSegueWithIdentifier:@"fromHistory" sender:indexPath];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"fromHistory"]) {
        OrderViewController *vc = segue.destinationViewController;
        NSManagedObject *order = self.source[((NSIndexPath*)sender).row];
        vc.cafe = [self getObjectFrom:order For:@"Cafes"];
        vc.coffee = [self getObjectFrom:order For:@"Coffees"];
        vc.orderID = ((NSNumber*)[order valueForKey:@"id"]).stringValue;
        vc.isAlreadySend = 1;
    }
}

- (NSManagedObject*)getObjectFrom:(NSManagedObject*)order For:(NSString*)type {
    NSString *entityName = type;
    NSString *propertyName;
    if ([type isEqualToString:@"Coffees"]) {
        propertyName = @"coffee_id";
    } else if ([type isEqualToString:@"Cafes"]) {
        propertyName = @"cafe_id";
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    request.entity = entity;
    NSString *idString = [order valueForKey:propertyName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", idString];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *fetchedResult = [context executeFetchRequest:request error:&error];
    return [fetchedResult firstObject];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
