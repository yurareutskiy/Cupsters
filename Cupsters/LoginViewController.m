//
//  LoginViewController.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/5/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "VKSdk+CustomAuthorizationDelegate.h"
#import "Server.h"
#import <NSHash/NSString+NSHash.h>
#import "DataManager.h"
#import <RKDropdownAlert.h>

@interface LoginViewController ()

@end

@implementation LoginViewController 

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"isLogin"]) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
        [self presentViewController:vc animated:false completion:nil];
    }

}

- (void)viewDidLoad {
    


    
    self.fields = self.fieldsOutlet;
    self.scrollView = self.scrollViewOutlet;
    
    [super viewDidLoad];

    
    [[VKSdk initializeWithAppId:@"5229696"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Voids

- (void)firstVK {
    [VKSdk authorize:@[@"audio", @"photos", @"pages", @"messages", @"stats", @"wall", @"questions", @"email"]];
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
                sender.secureTextEntry = false;
                sender.text = @"Password";
            default:
                break;
        }
    }
//    self.activeField = nil;
}

- (IBAction)signUpButtonAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"signUp" sender:self];
}

- (IBAction)signInButtonAction:(UIButton *)sender {
    
    if (![self validateFields]) {
        #pragma message "Make alert for validating"
        return;
    }
    
    // email - 1, pass - 0
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (!token) {
        token = @"first";
    }
    NSString *password = [((UITextField*)self.fieldsOutlet[0]).text MD5];
    
    Server *server = [[Server alloc] init];
    NSDictionary *parameters = @{@"type":@"self", @"email":((UITextField*)self.fieldsOutlet[1]).text, @"password":password, @"token":token};
    ServerRequest *requset = [ServerRequest initRequest:ServerRequestTypePOST With:parameters To:SigninURLStrring];
    [server sentToServer:requset OnSuccess:^(NSDictionary *result) {
        NSLog(@"%@", result);
        [[DataManager sharedManager] saveDataWithLogin:result];
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
        [self presentViewController:vc animated:true completion:nil];
    } OrFailure:^(NSError *error) {
        NSLog(@"%@", [error debugDescription]);
        if ([((ServerError*)error).serverCode isEqualToString:@"no_user"]) {
            [RKDropdownAlert title:@"Ошибка входа" message:@"Такого пользователя мы еще не знаем. Проверьте данные или зарегестрируйтесь." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
        } else if ([((ServerError*)error).serverCode isEqualToString:@"wrong_password"]) {
            [RKDropdownAlert title:@"Ошибка входа" message:@"Неправильеый пароль" backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
        } else {
            [RKDropdownAlert title:@"Ошибка сервера" message:@"Попробуйте повторить попытку позже." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
        }
//        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
//        [self presentViewController:vc animated:true completion:nil];
    }];
}

- (BOOL)validateFields {
    for (UITextField *field in self.fields) {
        field.text = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([field.text length] < 4) {
            NSLog(@"Less then 4 symbols");
            [RKDropdownAlert title:nil message:@"Слишком кратко, необходимо хотя бы 4 символа написать о себе и 8 в пароле." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
            return NO;
        }
        if ([field.text isEqualToString:@"Email"] || [field.text isEqualToString:@"Password"]) {
            NSLog(@"No unique value");
            [RKDropdownAlert title:nil message:@"Не ленись и заполни все поля." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];            
            return NO;
        }
        if (field.tag == 1) {
            if (![field.text containsString:@"@"] || ![field.text containsString:@"."]) {
                NSLog(@"Invalid email");
                [RKDropdownAlert title:nil message:@"Хмм. Уверен, что ты правильно написал почту?" backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                return NO;
            }
            if (![field.text canBeConvertedToEncoding:NSISOLatin1StringEncoding]) {
                NSLog(@"Invalid email");
                [RKDropdownAlert title:nil message:@"Хмм. Уверен, что ты правильно написал почту?" backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];                
                return NO;
            }
        }
        if (field.tag == 2) {
            if ([field.text length] < 8) {
                [RKDropdownAlert title:nil message:@"Надо быть хоть немного параноиком. Пароль должен содержать, как минимум 8 символов." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                NSLog(@"Too short password");
                return NO;
            }
            NSRegularExpression *regex = [[NSRegularExpression alloc]
                                          initWithPattern:@"[a-zA-Z0-9]" options:0 error:NULL];
            
            NSUInteger matches = [regex numberOfMatchesInString:field.text options:0
                                                          range:NSMakeRange(0, [field.text length])];
            
            if (matches != [field.text length]) {
                [RKDropdownAlert title:nil message:@"Даже твоя бабушка подбирает пароль надежнее! Напиши хотя бы по одной цифре, заглавной и строчной букве." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                NSLog(@"Invalid password");
                return NO;
            }
            
        }
    }
    return YES;
}

#pragma mark - Buttons

- (IBAction)withVK:(UIButton *)sender {
    [VKSdk wakeUpSession:@[@"audio"] completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (error) {
            NSLog(@"fetched error:%@", error);
//        } else if (state == VKAuthorizationAuthorized) {
//            [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"isLogin"];
//            NSLog(@"I'm here");
        } else if ([self isKindOfClass:[LoginViewController class]]) {
            [self firstVK];
        }
    }];
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
                             NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
                             if (!token) {
                                 token = @"first";
                             }

                             NSDictionary *parameters = @{@"email":result[@"email"], @"type":@"FB", @"id_sn":result[@"id"], @"token":token, @"first_name":result[@"first_name"], @"last_name":result[@"last_name"]};
                             ServerRequest *request = [ServerRequest initRequest:ServerRequestTypePOST With:parameters To:SigninURLStrring];
                             Server *server = [[Server alloc] init];
                             [server sentToServer:request OnSuccess:^(NSDictionary *result) {

                                 [[DataManager sharedManager] saveDataWithLogin:result];
                                 UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
                                 [self presentViewController:vc animated:true completion:nil];
                             } OrFailure:^(NSError *error) {
                                [RKDropdownAlert title:@"Ошибка сервера" message:@"Попробуйте повторить попытку позже." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                                 NSLog(@"%@", [error debugDescription]);
                             }];

                         }
                         else {
                             NSLog(@"fetched error:%@", error);
                         }
                     }];
                 }
             }
         }];
    }

#pragma mark - VKSDK Delegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult*)result {
    if (result.error) {
        NSLog(@"%@", [result.error debugDescription]);
        return;
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (!token) {
        token = @"first";
    }
    
    NSDictionary *parameters = @{@"email":result.token.email, @"type":@"VK", @"id_sn":result.token.userId, @"token":token, @"first_name":result.user.first_name, @"last_name":result.user.last_name};
    ServerRequest *request = [ServerRequest initRequest:ServerRequestTypePOST With:parameters To:SigninURLStrring];
    Server *server = [[Server alloc] init];
    [server sentToServer:request OnSuccess:^(NSDictionary *result) {
        [[DataManager sharedManager] saveDataWithLogin:result];
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
        [self presentViewController:vc animated:true completion:nil];
    } OrFailure:^(NSError *error) {
        [RKDropdownAlert title:@"Ошибка сервера" message:@"Попробуйте повторить попытку позже." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
        NSLog(@"%@", [error debugDescription]);
    }];
}

- (void)vkSdkUserAuthorizationFailed:(NSError*)error {
    NSLog(@"vkSdkUserAuthorizationFailed - %@", error);
}

- (void)vkSdkShouldPresentViewController:(UIViewController*)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError*)captchaError {
    NSLog(@"vkSdkNeedCaptchaEnter - %@", captchaError);
}
- (void)vkSdkTokenHasExpired:(VKAccessToken*)expiredToken {
    NSLog(@"vkSdkTokenHasExpired - %@", expiredToken);
}
- (void)vkSdkUserDeniedAccess:(VKError*)authorizationError {
    NSLog(@"vkSdkUserDeniedAccess - %@", authorizationError);
}
- (void)vkSdkReceivedNewToken:(VKAccessToken*)newToken {
    NSLog(@"vkSdkReceivedNewToken - %@", newToken);
    //    defaults.setObject(newToken, forKey: "token")
    //    server.checkTokenOnServer(newToken.accessToken, user: defaults.objectForKey("user") as! String, deviceNum: deviceInfo)
}

@end
