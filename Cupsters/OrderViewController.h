//
//  OrderViewController.h
//  Cupsters
//
//  Created by Anton Scherbakov on 19/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface OrderViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UITextField *notCode;
@property (strong, nonatomic) IBOutlet UIView *bg;
@property (strong, nonatomic) IBOutlet UILabel *labelCode;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgBottom;
@property (strong, nonatomic) IBOutlet UIView *upView;
@property (strong, nonatomic) IBOutlet UILabel *volume;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) NSManagedObject *cafe;
@property (strong, nonatomic) NSManagedObject *coffee;

@property (strong, nonatomic) NSString *orderID;
@property (assign, nonatomic) BOOL isAlreadySend;
@end
