//
//  OrderViewController.h
//  Cupsters
//
//  Created by Anton Scherbakov on 19/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UITextField *notCode;
@property (strong, nonatomic) IBOutlet UIView *bg;
@property (strong, nonatomic) IBOutlet UILabel *labelCode;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgBottom;
@property (strong, nonatomic) IBOutlet UIView *upView;

@end
