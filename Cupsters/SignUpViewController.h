//
//  SignUpViewController.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/5/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fields;

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

- (IBAction)editDidBeginAction:(UITextField *)sender;
- (IBAction)editDidEndAction:(UITextField *)sender;
- (IBAction)didEndOnExit:(UITextField *)sender;
- (IBAction)agreeButtonAction:(UIButton *)sender;

@end
