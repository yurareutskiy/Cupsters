//
//  SignUpViewController.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/5/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModelViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <VKSdk.h>


@interface SignUpViewController: LoginModelViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewOutlet;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fieldsOutlet;

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

- (IBAction)editDidBeginAction:(UITextField *)sender;
- (IBAction)editDidEndAction:(UITextField *)sender;
- (IBAction)agreeButtonAction:(UIButton *)sender;
- (IBAction)signUpDoneButtonAction:(UIButton *)sender;

- (IBAction)regWithVk:(UIButton *)sender;
- (IBAction)regWithFb:(UIButton *)sender;
- (IBAction)dismiss:(UIButton *)sender;

@end
