//
//  LoginModelViewController.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/6/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginModelViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSArray *fields;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *activeField;

@end
