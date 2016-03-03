//
//  PaymentViewController.h
//  Cupsters
//
//  Created by Anton Scherbakov on 27/02/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PaymentViewController : UIViewController<UIWebViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *number;
@property (strong, nonatomic) IBOutlet UITextField *date;
@property (strong, nonatomic) IBOutlet UITextField *cvv;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) NSString *priceValue;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) NSManagedObject *tariff;

- (IBAction)makePaymentAction:(id)sender;
- (IBAction)useCouponAction:(UIButton *)sender;

@end
