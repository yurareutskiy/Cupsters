//
//  SignUpViewController.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/5/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModelViewController.h"


@interface SignUpViewController: LoginModelViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewOutlet;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fieldsOutlet;

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

- (IBAction)editDidBeginAction:(UITextField *)sender;
- (IBAction)editDidEndAction:(UITextField *)sender;
- (IBAction)agreeButtonAction:(UIButton *)sender;

@end
