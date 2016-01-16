//
//  LoginViewController.h
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

@interface LoginViewController : LoginModelViewController<VKSdkDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fieldsOutlet;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewOutlet;


- (IBAction)editDidBeginAction:(UITextField *)sender;
- (IBAction)editDidEndAction:(UITextField *)sender;

- (IBAction)signUpButtonAction:(UIButton *)sender;
- (IBAction)signInButtonAction:(UIButton *)sender;

- (IBAction)withVK:(UIButton *)sender;
- (IBAction)withFB:(UIButton *)sender;

- (void)firstVK;

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult*)result;
- (void)vkSdkUserAuthorizationFailed:(NSError*)error;
- (void)vkSdkShouldPresentViewController:(UIViewController*)controller;
- (void)vkSdkNeedCaptchaEnter:(VKError*)captchaError;
- (void)vkSdkTokenHasExpired:(VKAccessToken*)expiredToken;
- (void)vkSdkUserDeniedAccess:(VKError*)authorizationError;
- (void)vkSdkReceivedNewToken:(VKAccessToken*)newToken;

@end
