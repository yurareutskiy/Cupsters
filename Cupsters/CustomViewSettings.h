//
//  CustomViewSettings.h
//  Cupsters
//
//  Created by Anton Scherbakov on 22/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CustomViewSettings : UIView
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat widthOffset;
@property (nonatomic) IBInspectable CGFloat heightOffset;
@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable BOOL masksToBounds;
@property (nonatomic) IBInspectable float shadowOpacity;

@end
