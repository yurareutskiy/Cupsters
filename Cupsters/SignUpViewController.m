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
#import <TOWebViewController.h>
#import "UIColor+HEX.h"

@interface SignUpViewController () 


@end

@implementation SignUpViewController

#pragma mark - Load view


- (void)viewDidLoad {
    
    [super viewDidLoad];


    for (UITextField *tf in self.fieldsOutlet) {
        switch (tf.tag) {
            case 3:
                if ([self.email length] > 0 && ![self.email isEqualToString:@"Email"]) {
                    tf.text = self.email;
                }
                break;
            case 4:
                if ([self.password length] > 0 && ![self.password isEqualToString:@"Пароль"]) {
                    tf.text = self.password;
                }
            default:
                break;
        }
    }



    self.fields = self.fieldsOutlet;
    self.scrollView = self.scrollViewOutlet;
    
    [self.agreeButton setImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.agreeButton setImage: [UIImage imageNamed:@"checkIn"] forState:UIControlStateSelected];
    


}

-(void)viewDidAppear:(BOOL)animated {
    

    
    self.textAgreeStatement.delegate = self;
    self.textAgreeStatement.linkAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Regular" size:15], (id)kCTForegroundColorAttributeName : (id)[UIColor lightGrayColor].CGColor};
    self.textAgreeStatement.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    NSRange rangePersonalData = [self.textAgreeStatement.text rangeOfString:@"обработку персональных данных"];
    NSRange rangeAgreement = [self.textAgreeStatement.text rangeOfString:@"пользовательского соглашени"];
    [self.textAgreeStatement addLinkToURL:[NSURL URLWithString:@"http://cupsters.ru/ui/policy.pdf"] withRange:rangePersonalData];
    [self.textAgreeStatement addLinkToURL:[NSURL URLWithString:@"http://cupsters.ru/ui/user_agreement.pdf"] withRange:rangeAgreement];

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
            [RKDropdownAlert title:@"Ошибка сервера" message:@"Что-то пошло не так, но мы уже работаем над этим. Попробуйте позже." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
        }
        NSLog(@"%@", [error debugDescription]);
    }];

}

- (BOOL)validateFields {

    for (UITextField *field in self.fields) {
        field.text = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([field.text length] < 2) {
            [RKDropdownAlert title:nil message:@"Нужно больше букв!" backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
            return NO;
        }
        if ([field.text isEqualToString:@"Email"] || [field.text isEqualToString:@"Password"] || [field.text isEqualToString:@"Имя"] || [field.text isEqualToString:@"Фамилия"]) {
            [RKDropdownAlert title:nil message:@"Пожалуйста, заполните все поля." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
            NSLog(@"No unique value");
            return NO;
        }
        if (field.tag == 1 || field.tag == 2) {
            NSRegularExpression *regex = [[NSRegularExpression alloc]
                                           initWithPattern:@"[a-zA-Zа-яА-Я]" options:0 error:NULL];
            
            NSUInteger matches = [regex numberOfMatchesInString:field.text options:0
                                                          range:NSMakeRange(0, [field.text length])];
            
            if (matches != [field.text length]) {
                [RKDropdownAlert title:nil message:@"Все поля необходимо заполнять латиницей" backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                NSLog(@"First name or last name must contain only latin characters");
                return NO;
            }
        }
        if (field.tag == 3) {
            if (![field.text containsString:@"@"] || ![field.text containsString:@"."]) {
                [RKDropdownAlert title:nil message:@"Некорректно указан e-mail. Проверьте и попробуйте еще раз." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                NSLog(@"Invalid email");
                return NO;
            }
            if (![field.text canBeConvertedToEncoding:NSISOLatin1StringEncoding]) {
                [RKDropdownAlert title:nil message:@"Некорректно указан e-mail. Проверьте и попробуйте еще раз." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                NSLog(@"Invalid email");
                return NO;
            }
        }
        if (field.tag == 4) {
            if ([field.text length] < 8) {
                [RKDropdownAlert title:nil message:@"НПопробуйте придумать пароль посложнее (от 8 символов)" backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
                NSLog(@"Too short password");
                return NO;
            }
            NSRegularExpression *regex = [[NSRegularExpression alloc]
                                          initWithPattern:@"[a-zA-Z0-9]" options:0 error:NULL];
            
            NSUInteger matches = [regex numberOfMatchesInString:field.text options:0
                                                          range:NSMakeRange(0, [field.text length])];
            
            if (matches != [field.text length]) {
                [RKDropdownAlert title:nil message:@"Попробуйте придумать пароль посложнее (от 8 символов, содержать цифру, строчную и заглавную букву)." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil];
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


#pragma mark - TTTAttributedLabelDelegate

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"%@", url);
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    navigationController.navigationBar.barTintColor = [UIColor colorWithHEX:cBrown];
    navigationController.navigationBar.translucent = NO;
    webViewController.title = @"Cupsters - Agreements";
    webViewController.showPageTitles = NO;
    navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:cFontMyraid size:18.f],
                                                               NSForegroundColorAttributeName: [UIColor whiteColor]};
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}





@end
