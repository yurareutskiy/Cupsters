//
//  PaymentViewController.h
//  Cupsters
//
//  Created by Anton Scherbakov on 27/02/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController<UIWebViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *number;
@property (strong, nonatomic) IBOutlet UITextField *date;
@property (strong, nonatomic) IBOutlet UITextField *cvv;
@property (strong, nonatomic) IBOutlet UILabel *price;

- (IBAction)makePaymentAction:(id)sender;

@end
