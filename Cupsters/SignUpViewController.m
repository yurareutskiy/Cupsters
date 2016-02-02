//
//  SignUpViewController.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/5/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "SignUpViewController.h"
#import "Constants.h"
#import "VKSdk+CustomAuthorizationDelegate.h"
#import "Server.h"
#import <NSHash/NSString+NSHash.h>
#import "DataManager.h"
#import <RKDropdownAlert.h>

@interface SignUpViewController ()


@end

@implementation SignUpViewController

#pragma mark - Load view


- (void)viewDidLoad {

    self.fields = self.fieldsOutlet;
    self.scrollView = self.scrollViewOutlet;
    
    [self.agreeButton setImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.agreeButton setImage: [UIImage imageNamed:@"checkIn"] forState:UIControlStateSelected];
    
    [[VKSdk initializeWithAppId:@"5229696"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];

    [super viewDidLoad];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VKSDK Delegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult*)result {
    if (result.error) {
        NSLog(@"65%@", [result.error debugDescription]);
        return;
    }
    NSLog(@"vkSdkAccessAuthorizationFinishedWithResult");
    NSLog(@"%@", result.user.first_name);
    NSLog(@"%@", result.user.last_name);
    NSLog(@"%@", result.token.userId);
    NSLog(@"%@", result.token.email);
    NSDictionary *parameters = @{@"email":result.token.email, @"type":@"VK", @"id_sn":result.user.id, @"first_name":result.user.first_name, @"last_name":result.user.last_name};
    ServerRequest *request = [ServerRequest initRequest:ServerRequestTypePOST With:parameters To:SignupURLStrring];
    Server *server = [[Server alloc] init];
    [server sentToServer:request OnSuccess:^(NSDictionary *result) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
        [self presentViewController:vc animated:true completion:nil];
    } OrFailure:^(NSError *error) {
        NSLog(@"12%@", [error debugDescription]);
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



- (IBAction)editDidBeginAction:(UITextField *)sender {
    
    if (sender.tag == 4) {
        sender.secureTextEntry = true;
    }
    sender.text = @"";
    self.activeField = sender;
    
}

- (IBAction)editDidEndAction:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        switch (sender.tag) {
            case 1:
                sender.text = @"Имя";
                break;
            case 2:
                sender.text = @"Фамилия";
                break;
            case 3:
                sender.text = @"Email";
                break;
            case 4:
                sender.text = @"Пароль";
                sender.secureTextEntry = false;
                break;
            default:
                break;
        }
    }
    self.activeField = nil;
}

#pragma mark - Voids


- (IBAction)agreeButtonAction:(UIButton *)sender {

    if (sender.isSelected == true) {
        sender.alpha = 0.6;
        sender.selected = false;
    } else {
        sender.alpha = 1;

        sender.selected = true;
    }
    
}

- (IBAction)signUpDoneButtonAction:(UIButton *)sender {
    
    if (![self validateFields]) {
        
        return;
    }
    
    if (self.agreeButton.selected == NO) {
        [RKDropdownAlert title:nil message:@"Забыли дать согласие на обработку данных." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
        return;
    }
    
    NSString *password = [((UITextField*)self.fieldsOutlet[0]).text MD5];
    
    Server *server = [[Server alloc] init];
    NSDictionary *parameters = @{@"type":@"self", @"email":((UITextField*)self.fieldsOutlet[1]).text, @"password":password, @"first_name":((UITextField*)self.fieldsOutlet[3]).text, @"last_name":((UITextField*)self.fieldsOutlet[2]).text};
    ServerRequest *requset = [ServerRequest initRequest:ServerRequestTypePOST With:parameters To:SignupURLStrring];
    [server sentToServer:requset OnSuccess:^(NSDictionary *result) {
        [[DataManager sharedManager] saveDataWithLogin:result];
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
        [self presentViewController:vc animated:true completion:nil];
    } OrFailure:^(NSError *error) {
        if ([((ServerError*)error).serverCode isEqualToString:@"email_exist"]) {
            [RKDropdownAlert title:@"Ошибка регистрации" message:@"Пользователь с таким email уже зарегестрирован." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
        } else {
            [RKDropdownAlert title:@"Ошибка сервера" message:@"Попробуйте повторить попытку позже." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
        }
        NSLog(@"%@", [error debugDescription]);
    }];

}

- (BOOL)validateFields {

    for (UITextField *field in self.fields) {
        field.text = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([field.text length] < 4) {
            [RKDropdownAlert title:nil message:@"Слишком кратко, необходимо хотя бы 4 символа написать о себе и 8 в пароле." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
            return NO;
        }
        if ([field.text isEqualToString:@"Email"] || [field.text isEqualToString:@"Password"] || [field.text isEqualToString:@"Имя"] || [field.text isEqualToString:@"Фамилия"]) {
            [RKDropdownAlert title:nil message:@"Не ленись и заполни все поля." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
            NSLog(@"No unique value");
            return NO;
        }
        if (field.tag == 1 || field.tag == 2) {
            NSRegularExpression *regex = [[NSRegularExpression alloc]
                                           initWithPattern:@"[a-zA-Zа-яА-Я]" options:0 error:NULL];
            
            NSUInteger matches = [regex numberOfMatchesInString:field.text options:0
                                                          range:NSMakeRange(0, [field.text length])];
            
            if (matches != [field.text length]) {
                [RKDropdownAlert title:nil message:@"Мы, конечно, все патриоты, но поля нужно заполнять латиницей." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                NSLog(@"First name or last name must contain only latin characters");
                return NO;
            }
        }
        if (field.tag == 3) {
            if (![field.text containsString:@"@"] || ![field.text containsString:@"."]) {
                [RKDropdownAlert title:nil message:@"Хмм. Уверен, что ты правильно написал почту?" backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                NSLog(@"Invalid email");
                return NO;
            }
            if (![field.text canBeConvertedToEncoding:NSISOLatin1StringEncoding]) {
                [RKDropdownAlert title:nil message:@"Хмм. Уверен, что ты правильно написал почту?" backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                NSLog(@"Invalid email");
                return NO;
            }
        }
        if (field.tag == 4) {
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



- (IBAction)dismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
