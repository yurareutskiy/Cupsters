//
//  MenuRevealViewController.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/7/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface MenuRevealViewController : UIViewController <SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPlan;
@property (weak, nonatomic) IBOutlet UILabel *userInitials;

@end
