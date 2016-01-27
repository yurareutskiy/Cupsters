//
//  CafeTableViewCell.h
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CafeTableViewCellDelegate <NSObject>

- (void) makeOrder:(UITableViewCell*)cell;

@end

@interface CafeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coffeePic;
@property (strong, nonatomic) IBOutlet UIButton *makeButton;
@property (strong, nonatomic) IBOutlet UILabel *coffeeName;
@property (strong, nonatomic) IBOutlet UIButton *plus;
@property (strong, nonatomic) IBOutlet UIButton *minus;
@property (strong, nonatomic) IBOutlet UILabel *volume;
@property (strong, nonatomic) NSArray *volumeNum;
@property (nonatomic) NSInteger index;
@property (assign, nonatomic) NSUInteger row;
@property (weak, nonatomic) id<CafeTableViewCellDelegate> delegate;
- (instancetype)initWith:(NSInteger)tableFrom row:(NSInteger)rowFrom;
- (IBAction)plusBtn:(UIButton *)sender;
- (IBAction)minusBtn:(UIButton *)sender;

@end
