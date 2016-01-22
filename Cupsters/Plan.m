//
//  Plan.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/9/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "Plan.h"

@implementation Plan

+ (instancetype)initWithParams:(NSDictionary*)params {
    Plan *plan = [[Plan alloc] init];
    plan.name = params[@"tariff"];
    plan.count = params[@"count"];
    plan.type = params[@"type"];
    plan.begin = params[@"create_date"];
    return plan;
}

@end
