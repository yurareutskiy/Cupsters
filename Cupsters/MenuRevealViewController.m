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

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
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
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTheImage:)];
    [self.profileView addGestureRecognizer:_tapRecognizer];
    _tapRecognizer.delegate = self;
    
}

-(void)ClickTheImage:(id)sender
{
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

@end
