//
//  LoginViewController.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/5/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    self.fields = self.fieldsOutlet;
    self.scrollView = self.scrollViewOutlet;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Text field actions

- (IBAction)editDidBeginAction:(UITextField *)sender {
    
    if (sender.tag == 2) {
        sender.secureTextEntry = true;
    }
    sender.text = @"";
    self.activeField = sender;
}

- (IBAction)editDidEndAction:(UITextField *)sender {
    if ([sender.text isEqualToString:@""]) {
        switch (sender.tag) {
            case 1:
                sender.text = @"Email";
                break;
            case 2:
                sender.text = @"Password";
            default:
                break;
        }
    }
    self.activeField = nil;
}

- (IBAction)signUpButtonAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"signUp" sender:self];
}

- (IBAction)signInButtonAction:(UIButton *)sender {

    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
    [self presentViewController:vc animated:true completion:nil];
}

#pragma mark Buttons

- (IBAction)withVK:(UIButton *)sender {
    VKSdk.wakeUpSession(scope) { (state, error) -> Void in
        if (state == VKAuthorizationState.Authorized) {
            
            print("here i am 1")
            print(self.defaults.objectForKey("token"))
            print(state)
            
            
        } else if (state == VKAuthorizationState.Initialized) {
            
            print("here i am 2")
            self.firstLog()
            
        } else if (error != nil) {
            
            print("here i am 3")
            print(error)
            
        }
    }
}

- (IBAction)withFB:(UIButton *)sender {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 if ([FBSDKAccessToken currentAccessToken]) {
                     FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                   initWithGraphPath:@"/me"
                                                   parameters:@{@"fields": @"id, first_name, last_name, email"}
                                                   HTTPMethod:@"GET"];
                     [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                           NSDictionary *result,
                                                           NSError *error) {
                         if (!error) {
                             NSLog(@"fetched email:%@", result[@"email"]);
                             NSLog(@"fetched first_name:%@", result[@"first_name"]);
                             NSLog(@"fetched id:%@", result[@"id"]);
                             NSLog(@"fetched last_name:%@", result[@"last_name"]);
                         }
                         else {
                             NSLog(@"test: %@", error);
                         }
                     }];
                 }
             }
         }];
    }

@end
