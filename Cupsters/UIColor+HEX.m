//
//  UIColor+HEX.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/7/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "UIColor+HEX.h"

@implementation UIColor (HEX)

+ (UIColor*)colorWithHEX:(NSString*)hex {
    
    if ([[hex substringToIndex:1] isEqualToString:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    
    NSString *redString = [hex substringToIndex:2];
    NSString *greenString = [hex substringWithRange:NSMakeRange(2, 2)];
    NSString *blueString = [hex substringFromIndex:4];
    
    NSArray *stringComponents = @[redString, greenString, blueString];
    NSMutableArray *components = [NSMutableArray array];
    
    for (NSString *component in stringComponents) {

        float number = (float)strtoull([component UTF8String], NULL, 16);
        [components addObject:[NSNumber numberWithFloat:number]];
    
    }
    
    
    return [UIColor colorWithRed:((NSNumber*)components[0]).floatValue/255.f
                           green:((NSNumber*)components[1]).floatValue/255.f
                            blue:((NSNumber*)components[2]).floatValue/255.f
                           alpha:1.f];
}


@end
