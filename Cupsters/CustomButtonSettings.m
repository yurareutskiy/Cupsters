//
//  CustomButtonSettings.m
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "CustomButtonSettings.h"

@implementation CustomButtonSettings

- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = _masksToBounds;
    self.layer.borderWidth = _borderWidth;
    self.layer.shadowColor = _shadowColor.CGColor;
    self.layer.shadowOpacity = _shadowOpacity;
    self.layer.shadowRadius = _shadowRadius;
    self.layer.shadowOffset = CGSizeMake(_widthOffset, _heightOffset);

}

@end
