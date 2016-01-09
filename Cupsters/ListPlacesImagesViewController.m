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

@interface ListPlacesImagesViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;

@end

@implementation ListPlacesImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customNavBar];
    
    [self preferredStatusBarStyle];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self configureMenu];
    
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
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}


// Create label with title and image
- (UILabel*)customTitleViewWithImage {
    
    // Create
    UILabel* navigationBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    
    // Create text attachment, which will contain and set text and image
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"cup"];
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
    NSLog(@"Select row at index %@", indexPath);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PlacePhotoTableViewCell *cell = [[PlacePhotoTableViewCell alloc] init];
    [self.table dequeueReusableCellWithIdentifier:cCellBigPlace forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return [self configurePlace:cell At:indexPath.row];
}

-(PlacePhotoTableViewCell*)configurePlace:(PlacePhotoTableViewCell*)cell At:(NSInteger)row {
    
    [cell.backPhoto setImage:[UIImage imageNamed:@"cafeBack1"]];
    [cell.placeName setText:@"КОФЕЙНЯ"];
    [cell.underground setText:@"м. Парк Победы"];
    [cell.distance setText:@"2 км."];
    
    return cell;
}











@end
