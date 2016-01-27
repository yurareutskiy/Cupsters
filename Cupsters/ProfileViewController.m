//
//  ProfileViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "MenuRevealViewController.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "TariffViewController.h"

@interface ProfileViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;
@property (strong, nonatomic) UIViewController *vc;

@end

@implementation ProfileViewController {
    UIView *mask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self customNavBar];
    [self preferredStatusBarStyle];
    [self configureMenu];
    
    self.upView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.upView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.upView.layer.shadowRadius = 1.0f;
    self.upView.layer.shadowOpacity = 0.5f;
    [self.upView.layer setMasksToBounds:NO];
    
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
    self.initals.text = user.initials;
    self.initals.font = [UIFont fontWithName:@"MyriadPro-Regular" size:42];
    self.initals.layer.masksToBounds = YES;
    self.initals.layer.cornerRadius = self.initals.frame.size.height / 2;
    self.userName.text = user.name;
    self.locationLabel.alpha = 0.6;
    self.locationLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];

    if (user.plan) {
        self.tariff.text = [NSString stringWithFormat:@"Тариф: %@", user.plan[@"name"]];
        self.price.text = [NSString stringWithFormat:@"%@ ₽", user.plan[@"price"]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"y-M-d H:m:s";
        NSDateComponents *monthComponent = [[NSDateComponents alloc] init];
        monthComponent.month = 1;
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *beginDate = [formatter dateFromString:user.plan[@"create_date"]];
        NSDate *endDate = [theCalendar dateByAddingComponents:monthComponent toDate:beginDate options:nil];
        formatter.dateFormat = @"d MMMM";
        self.timeLimitLabel.text = [NSString stringWithFormat:@"Годен до %@", [formatter stringFromDate:endDate]];
    } else {
        self.suggestLabel.hidden = NO;
        self.tariff.hidden = YES;
        self.price.hidden = YES;
        self.periodLabel.hidden = YES;
        self.timeLimitLabel.hidden = YES;
//        float upperPoint = self.tariff.frame.origin.y;
//        float bottomPoint = self.changePlanButton.frame.origin.y;
//        CGRect rect = CGRectMake(25.f, self.tariff.superview.frame.origin.y - 35, self.view.frame.size.width - 50, 75);
//        UILabel *suugestLabel = [[UILabel alloc] initWithFrame:rect];
//        rect = self.changePlanButton.frame;
//        rect.origin.y = suugestLabel.frame.origin.y + suugestLabel.frame.size.height + 20;
//        self.changePlanButton.frame = rect;
//        suugestLabel.numberOfLines = 0;
//        suugestLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:22];
        self.changePlanButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:32];
//        suugestLabel.textColor = [UIColor colorWithHEX:cBrown];
      
        
    }

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
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}


- (void)toList:(id)sender {
    
    [self presentViewController:self.vc animated:true completion:nil];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changePlan:(UIButton *)sender {
    TariffViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"tariffs"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changeCond:(UIButton *)sender {
}
@end
