//
//  MenuRevealViewController.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/7/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "MenuRevealViewController.h"
#import "UIColor+HEX.h"
#import "Constants.h"
#import "User.h"
#import <TOWebViewController.h>

@interface MenuRevealViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizerProfile;
@property (strong, nonatomic) User *user;

@end

@implementation MenuRevealViewController {
    UIView *mask;
    UITapGestureRecognizer *singleFingerTap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.revealViewController.delegate = self;
    self.tapRecognizerProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTheProfile:)];
    [self.profileView addGestureRecognizer:self.tapRecognizerProfile];
    self.tapRecognizerProfile.delegate = self;
    
}


-(void)viewDidAppear:(BOOL)animated {

    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self.revealViewController
                                            action:@selector(revealToggle:)];
    //    [self.view addGestureRecognizer:singleFingerTap];
    
    [self.revealViewController.frontViewController.view addGestureRecognizer:singleFingerTap];
    
    
    self.user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];

    self.userPhoto.layer.cornerRadius = 30;
    self.userInitials.text = self.user.initials;
    
    self.userPlan.text = self.user.plan[@"name"];
    self.userName.text = self.user.name;
    self.userName.adjustsFontSizeToFitWidth = true;

}

-(void)viewDidDisappear:(BOOL)animated {
    [self.revealViewController.frontViewController.view removeGestureRecognizer:singleFingerTap];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reveal)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.revealViewController.frontViewController.view addGestureRecognizer:swipe];
}

//- (void) closeMenu {
//    self.revealViewController
//}

-(void)ClickTheProfile:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.revealViewController revealToggleAnimated:true];
    });
    [self performSegueWithIdentifier:@"goToProfile" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reveal {
    [self.revealViewController revealToggleAnimated:YES];
}

-(void)revealController:(SWRevealViewController *)revealController panGestureBeganFromLocation:(CGFloat)location progress:(CGFloat)progress overProgress:(CGFloat)overProgress {

    NSLog(@"%f %f %f", location, progress, overProgress);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goToTarifs:(UIButton *)sender {
    [self performSegueWithIdentifier:@"goToTarifs" sender:self];
}

- (IBAction)goToCoupons:(UIButton *)sender {
    [self performSegueWithIdentifier:@"goToCoupons" sender:self];
}

- (IBAction)goToHistory:(UIButton *)sender {
    [self performSegueWithIdentifier:@"goToHistory" sender:self];
}

- (IBAction)aboutUsAction:(id)sender {
//    [self performSegueWithIdentifier:@"aboutUs" sender:self];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://cupsters.ru"]];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://cupsters.ru/faq"]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    navigationController.navigationBar.barTintColor = [UIColor colorWithHEX:cBrown];
    navigationController.navigationBar.translucent = NO;
    webViewController.title = @"Cupsters - About us";
    webViewController.showPageTitles = NO;
    navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:cFontMyraid size:18.f],
                                                               NSForegroundColorAttributeName: [UIColor whiteColor]};
    navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [self presentViewController:navigationController animated:YES completion:nil];
}
@end
