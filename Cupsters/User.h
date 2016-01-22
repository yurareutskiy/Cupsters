//
//  User.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/9/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Plan.h"

@interface User : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (readonly, strong, nonatomic) NSString *name;
@property (strong, nonatomic) Plan *plan;
@property (strong, nonatomic) NSString *initials;
@property (strong, nonatomic) NSNumber *id;

+ (instancetype)initUserWithFirstName:(NSString*)firstName LastName:(NSString*)lastName userID:(NSString*)id UserPlan:(Plan*)plan;

@end
