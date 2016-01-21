//
//  SignUpViewController.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/5/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "SignUpViewController.h"
#import "Constants.h"
#import "Server.h"
#import <NSHash/NSString+NSHash.h>

@interface SignUpViewController ()


@end

@implementation SignUpViewController

#pragma mark - Load view


- (void)viewDidLoad {

    self.fields = self.fieldsOutlet;
    self.scrollView = self.scrollViewOutlet;
    
    [self.agreeButton setImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.agreeButton setImage: [UIImage imageNamed:@"checkIn"] forState:UIControlStateSelected];
    

    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *password = [((UITextField*)self.fieldsOutlet[0]).text MD5];
    
    Server *server = [[Server alloc] init];
    NSDictionary *parameters = @{@"email":((UITextField*)self.fieldsOutlet[1]).text, @"password":password, @"first_name":((UITextField*)self.fieldsOutlet[3]).text, @"last_name":((UITextField*)self.fieldsOutlet[2]).text};
    ServerRequest *requset = [ServerRequest initRequest:ServerRequestTypePOST With:parameters To:SignupURLStrring];
    [server sentToServer:requset OnSuccess:^(NSDictionary *result) {
        NSLog(@"%@", result);
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
        [self presentViewController:vc animated:true completion:nil];
    } OrFailure:^(NSError *error) {
        NSLog(@"%@", [error debugDescription]);
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
        [self presentViewController:vc animated:true completion:nil];
    }];

}



@end
