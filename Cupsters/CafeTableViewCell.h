//
//  CafeTableViewCell.h
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CafeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coffeePic;
@property (strong, nonatomic) IBOutlet UIButton *makeButton;
@property (strong, nonatomic) IBOutlet UILabel *coffeeName;

@end
