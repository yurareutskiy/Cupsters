//
//  HistoryTableViewCell.h
//  Cupsters
//
//  Created by Anton Scherbakov on 18/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coffeePic;
@property (strong, nonatomic) IBOutlet UILabel *cafeName;
@property (strong, nonatomic) IBOutlet UILabel *coffeeName;
@property (strong, nonatomic) IBOutlet UILabel *coffeeVol;
@property (strong, nonatomic) IBOutlet UILabel *date;

@end
