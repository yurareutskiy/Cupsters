//
//  CafeTableViewCell.m
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "CafeTableViewCell.h"

@implementation CafeTableViewCell {
    NSUserDefaults *userDefaults;
}
@synthesize delegate;
- (void)awakeFromNib {
    
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    _index = 0;
    _volumeNum = @[@150, @200, @250, @300, @350, @400, @450];
    //[userDefaults setObject:[NSString stringWithFormat:@"%@", _volumeNum[_index]] forKey:@"volume"];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)plusBtn:(UIButton *)sender{
    
    if ((_index >= 0) && (_index + 2) < _volumeNum.count){
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", _volumeNum[_index + 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusBrown"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusBrown"] forState:UIControlStateNormal];

        [userDefaults setObject:[NSString stringWithFormat:@"%@", _volumeNum[_index + 1]]
            forKey:@"volume"];
        
        _index++;
    } else if (_index + 2 == _volumeNum.count){
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", _volumeNum[_index + 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusGrey"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusBrown"] forState:UIControlStateNormal];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%@", _volumeNum[_index + 1]] forKey:@"volume"];
        
        _index++;
    }
}

- (IBAction)minusBtn:(UIButton *)sender{
    if (_index == 1) {
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", _volumeNum[_index - 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusBrown"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusGrey"] forState:UIControlStateNormal];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%@", _volumeNum[_index - 1]] forKey:@"volume"];
        
        _index--;
    } else if ((_index > 1) && (_index + 1) <= _volumeNum.count) {
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", _volumeNum[_index - 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusBrown"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusBrown"] forState:UIControlStateNormal];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%@", _volumeNum[_index - 1]] forKey:@"volume"];
        
        _index--;
    }
}

- (IBAction)orderBtn:(UIButton*)sender {
    [self.delegate makeOrder:self];
}

//- (void) makeOrder {
//    
////    [userDefaults setObject:[NSString stringWithFormat:@"%@", volumeNum[index]] forKey:@"volume"];
////    [userDefaults setObject:self.coffeeName.text forKey:@"coffee"];
////    
////    NSLog(@"hey!");
////    NSLog(@"%@", self.coffeeName.text);
////    NSLog(@"%@", [userDefaults objectForKey:@"coffee"]);
//    
//    
//}

@end
