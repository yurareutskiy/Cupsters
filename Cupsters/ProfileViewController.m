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

@end

@implementation ProfileViewController {
    UIView *mask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
        self.price.text = [self formattedStringWithPrice:user.plan[@"price"]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *endDate = user.plan[@"endDate"];
        formatter.dateFormat = @"d MMMM";
        self.timeLimitLabel.text = [NSString stringWithFormat:@"Годен до %@", [formatter stringFromDate:endDate]];
        
    } else {
        self.suggestLabel.hidden = NO;
        self.tariff.hidden = YES;
        self.price.hidden = YES;
        self.periodLabel.hidden = YES;
        self.timeLimitLabel.hidden = YES;
        self.changePlanButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:32];
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
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
    [self presentViewController:vc animated:true completion:nil];
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

- (IBAction)switchRecurrenPayment:(UISwitch *)sender {
    
}

- (IBAction)addNewCardAction:(id)sender {
}

- (NSString*)formattedStringWithPrice:(NSString*)price {
    
    NSInteger lenghtString = [price length];
    NSMutableString *resultString = [NSMutableString stringWithString:@""];
    NSInteger counter = lenghtString;
    for (int i = 0; i < lenghtString; i++) {
        char ch = [price characterAtIndex:i];
        if (counter % 3 == 0 && lenghtString != counter) {
            [resultString appendString:@" "];
        }
        [resultString appendString:[NSString stringWithFormat:@"%c", ch]];
        counter--;
    }
    [resultString appendString:@" ₽"];
    return resultString;
}
@end
