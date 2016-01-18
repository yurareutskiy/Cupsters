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
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizerTarifs;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizerCoupons;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizerHistory;
@property (strong, nonatomic) User *user;

@end

@implementation MenuRevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.revealViewController.delegate = self;
    
    self.user = [[User alloc] initUserWithFirstName:@"Юрий" LastName:@"Реутский" UserPlan:nil];


//    [self.view addSubview:self.user.image];
    
    self.userPhoto.layer.cornerRadius = 30;
    self.userInitials.text = self.user.initials;
    
    self.userPlan.text = self.user.plan.name;
    self.userName.text = self.user.name;
    self.userName.adjustsFontSizeToFitWidth = true;
    
    _tapRecognizerProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTheProfile:)];
    [self.profileView addGestureRecognizer:_tapRecognizerProfile];
    _tapRecognizerProfile.delegate = self;
    
    _tapRecognizerTarifs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTheTarifs:)];
    [self.tarifsView addGestureRecognizer:_tapRecognizerTarifs];
    _tapRecognizerTarifs.delegate = self;
    
    _tapRecognizerCoupons = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTheCoupons:)];
    [self.couponsView addGestureRecognizer:_tapRecognizerCoupons];
    _tapRecognizerCoupons.delegate = self;
    
    _tapRecognizerHistory = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTheHistory:)];
    [self.historyView addGestureRecognizer:_tapRecognizerHistory];
    _tapRecognizerHistory.delegate = self;
    
}

-(void)ClickTheProfile:(id)sender
{
    [self performSegueWithIdentifier:@"goToProfile" sender:self];
}

-(void)ClickTheTarifs:(id)sender
{
    [self performSegueWithIdentifier:@"goToTarifs" sender:self];
}

-(void)ClickTheCoupons:(id)sender
{
    [self performSegueWithIdentifier:@"goToCoupons" sender:self];
}

-(void)ClickTheHistory:(id)sender
{
    [self performSegueWithIdentifier:@"goToHistory" sender:self];
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

@end
