//
//  MapTableViewCell.h
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *number;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *underground;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UIImageView *backPhoto;
@property (strong, nonatomic) IBOutlet UILabel *numberRow;

@end
