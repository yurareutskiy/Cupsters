//
//  LoginViewController.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/5/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModelViewController.h"


@interface LoginViewController : LoginModelViewController

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fieldsOutlet;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewOutlet;


- (IBAction)editDidBeginAction:(UITextField *)sender;
- (IBAction)editDidEndAction:(UITextField *)sender;

- (IBAction)signUpButtonAction:(UIButton *)sender;
- (IBAction)signInButtonAction:(UIButton *)sender;

@end
