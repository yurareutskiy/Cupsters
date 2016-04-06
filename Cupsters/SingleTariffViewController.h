//
//  SingleTariffViewController.h
//  Cupsters
//
//  Created by Anton Scherbakov on 18/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLRSessionInfo.h"
#import "PLRWebView.h"
#import "PLRSessionInfo.h"
#import "PLRPayment.h"
#import "PaylerAPIClient.h"

@interface SingleTariffViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UILabel *avgPrice;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *cups;
- (IBAction)sliderValue:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UIView *upView;
@property (strong, nonatomic) IBOutlet UILabel *tariffType;
@property (strong, nonatomic) IBOutlet UILabel *tariffName;

@property (strong, nonatomic) NSString *type;
- (IBAction)connect:(UIButton *)sender;
- (IBAction)useCouponAction:(UIButton *)sender;



@end
