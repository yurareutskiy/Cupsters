//
//  CouponViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 18/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "CouponViewController.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "MenuRevealViewController.h"
#import "SWRevealViewController.h"
#import <RKDropdownAlert.h>
#import "User.h"
#include "Server.h"

@interface CouponViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;
@property (strong, nonatomic) NSString *codeText;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self customNavBar];
    [self preferredStatusBarStyle];
    [self configureMenu];
    
    self.code.delegate = self;
    self.notCode.delegate = self;
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    self.menu.view.frame = CGRectMake(self.menu.view.frame.origin.x, 0.f, 280.f, self.menu.view.frame.size.height + 60.f);
}

- (void)customNavBar {
    
    // Set background color
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHEX:cBrown];
    self.navigationController.navigationBar.translucent = NO;
    
    
    // Set title view
    
    self.navigationItem.titleView = [self customTitleViewWithImage];
    
}

- (void)configureMenu {
    
    self.reveal = self.revealViewController;
    
    if (!self.reveal) {
        return;
    }
    
    
    // Add gesture recognizer
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    // Set menu button
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(toList:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}

- (void)toList:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
    [self presentViewController:vc animated:true completion:nil];
    
}

- (UILabel*)customTitleViewWithImage {
    
    // Create
    UILabel* navigationBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    
    // Create text attachment, which will contain and set text and image
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"smallCup"];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentCounter"]];
    [myString appendAttributedString:attachmentString];
    
    // Configure our label
    navigationBarLabel.attributedText = myString;
    navigationBarLabel.font = [UIFont fontWithName:cFontMyraid size:18.f];
    navigationBarLabel.textColor = [UIColor whiteColor];
    navigationBarLabel.textAlignment = NSTextAlignmentCenter;
    
    return navigationBarLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    _code.textAlignment = NSTextAlignmentLeft;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    switch (range.location) {
        case 0:
            _code.text = [NSString stringWithFormat:@"%@ ", string];
            self.codeText = string;
            break;
        case 2:
            _code.text = [NSString stringWithFormat:@"%@%@ ", self.code.text, string];
            self.codeText = [NSString stringWithFormat:@"%@%@", self.codeText, string];
            break;
        case 4:
            _code.text = [NSString stringWithFormat:@"%@%@ ", self.code.text, string];
            self.codeText = [NSString stringWithFormat:@"%@%@", self.codeText, string];
            break;
        case 6:
            _code.text = [NSString stringWithFormat:@"%@%@ ", self.code.text, string];
            self.codeText = [NSString stringWithFormat:@"%@%@", self.codeText, string];
            break;
        case 8:
            _code.text = [NSString stringWithFormat:@"%@%@ ", self.code.text, string];
            self.codeText = [NSString stringWithFormat:@"%@%@", self.codeText, string];
            break;
        case 10:
            _code.text = [NSString stringWithFormat:@"%@%@", self.code.text, string];
            self.codeText = [NSString stringWithFormat:@"%@%@", self.codeText, string];
            [self sendCoupon];
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                _code.text = @"";
            //                [self.code resignFirstResponder];
            //            });
            break;
        default:
            break;
    }
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.code resignFirstResponder];
}

-(NSString *)formatCode:(NSString *)code{
    code = [code stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return code;
}

-(NSInteger)getLength:(NSString*)code {
    code = [code stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSInteger length = [code length];
    
    return length;
}

- (void)sendCoupon {
    User *user = [User sharedUser];
    int __block currentCounter = ((NSString*)user.plan[@"counter"]).intValue;
    if (currentCounter == -1) {
        [RKDropdownAlert title:@"Купон не доступен" message:@"У вас безлимитный тариф." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil time:3];
        return;
    }
    Server *server = [[Server alloc] init];
    NSDictionary *parameters = @{@"user_id":user.id, @"code":self.codeText};
    ServerRequest *request = [ServerRequest initRequest:ServerRequestTypePOST With:parameters To:CouponURLString];
    
    [server sentToServer:request OnSuccess:^(NSDictionary *result) {
        NSMutableDictionary *plan = [user.plan mutableCopy];
        currentCounter += + ((NSString*)result[@"counter"]).intValue;
        
        NSString *text;
        if (currentCounter == 1) {
            text = @"ЧАШКА";
        } else if (currentCounter == 2 || currentCounter == 3 || currentCounter == 4) {
            text = @"ЧАШКИ";
        } else {
            text = @"ЧАШЕК";
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld %@  ", (long)currentCounter, text] forKey:@"currentCounter"];
        plan[@"counter"] = [NSString stringWithFormat:@"%d", currentCounter];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
        user.plan = plan;
        NSLog(@"%@", result);
        user.counter = [NSNumber numberWithInt:((NSNumber*)user.counter).intValue + ((NSString*)result[@"counter"]).intValue];
        [user save];
        [self customNavBar];
        [RKDropdownAlert title:@"Верный код" message:@"У вас увеличился счет кружек." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil time:3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.code.text = @"";
            [self.view endEditing:YES];
        });

    } OrFailure:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.code.text = @"";
            [RKDropdownAlert title:@"Неверный код" message:@"Проверьте код еще раз и введите." backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil time:3];
        });
    }];
    
}


@end
