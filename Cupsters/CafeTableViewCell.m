//
//  CafeTableViewCell.m
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "CafeTableViewCell.h"

@implementation CafeTableViewCell {
    NSArray *volumeNum;
    NSInteger index;
    NSUserDefaults *userDefaults;
}

- (void)awakeFromNib {
    userDefaults = [NSUserDefaults standardUserDefaults];
    index = 0;
    volumeNum = @[@150, @200, @250, @300, @350, @400, @450];
    [userDefaults setObject:[NSString stringWithFormat:@"%@", volumeNum[index]] forKey:@"volume"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)plusBtn:(UIButton *)sender{
    
    if ((index >= 0) && (index + 2) < volumeNum.count){
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", volumeNum[index + 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusBrown"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusBrown"] forState:UIControlStateNormal];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%@", volumeNum[index + 1]]
            forKey:@"volume"];
        
        index++;
    } else if (index + 2 == volumeNum.count){
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", volumeNum[index + 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusGrey"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusBrown"] forState:UIControlStateNormal];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%@", volumeNum[index + 1]] forKey:@"volume"];
        
        index++;
    }
}

- (IBAction)minusBtn:(UIButton *)sender{
    if (index == 1) {
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", volumeNum[index - 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusBrown"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusGrey"] forState:UIControlStateNormal];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%@", volumeNum[index - 1]] forKey:@"volume"];
        
        index--;
    } else if ((index > 1) && (index + 1) <= volumeNum.count) {
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", volumeNum[index - 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusBrown"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusBrown"] forState:UIControlStateNormal];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%@", volumeNum[index - 1]] forKey:@"volume"];
        
        index--;
    }
}
@end
