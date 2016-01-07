//
//  PlacePhotoTableViewCell.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/7/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacePhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backPhoto;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *underground;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end
