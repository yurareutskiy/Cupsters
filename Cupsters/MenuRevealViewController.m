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

@interface MenuRevealViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizerProfile;
@property (strong, nonatomic) User *user;

@end

@implementation MenuRevealViewController {
    UIView *mask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.revealViewController.delegate = self;
    
    self.user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];



    

//    [self.view addSubview:self.user.image];
    
    self.userPhoto.layer.cornerRadius = 30;
    self.userInitials.text = self.user.initials;
    
    self.userPlan.text = self.user.plan[@"tariff"];
    self.userName.text = self.user.name;
    self.userName.adjustsFontSizeToFitWidth = true;
    
    _tapRecognizerProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTheProfile:)];
    [self.profileView addGestureRecognizer:_tapRecognizerProfile];
    _tapRecognizerProfile.delegate = self;
    
}

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
@end
