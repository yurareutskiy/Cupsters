//
//  Plan.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/9/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plan : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSDate *begin;
@property (strong, nonatomic) id type;

+ (instancetype)initWithParams:(NSDictionary*)params;

@end
