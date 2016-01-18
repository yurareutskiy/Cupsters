//
//  MenuRevealViewController.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/7/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface MenuRevealViewController : UIViewController <SWRevealViewControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPlan;
@property (weak, nonatomic) IBOutlet UILabel *userInitials;

@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) IBOutlet UIView *tarifsView;
@property (strong, nonatomic) IBOutlet UIView *couponsView;
@property (strong, nonatomic) IBOutlet UIView *historyView;

- (IBAction)goToTarifs:(UIButton *)sender;
- (IBAction)goToCoupons:(UIButton *)sender;
- (IBAction)goToHistory:(UIButton *)sender;


@end
