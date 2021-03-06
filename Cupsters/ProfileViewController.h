//
//  ProfileViewController.h
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *upView;
@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *initals;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *tariff;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *timeLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestLabel;
@property (strong, nonatomic) IBOutlet UIButton *changePlanButton;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UISwitch *recurrentPaymentSwitcher;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
- (IBAction)changePlan:(UIButton *)sender;
- (IBAction)changeCond:(UIButton *)sender;
- (IBAction)switchRecurrenPayment:(UISwitch *)sender;
- (IBAction)addNewCardAction:(id)sender;

@end
