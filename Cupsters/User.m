//
//  User.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/9/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "User.h"

@interface User()

@property (readwrite, strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIView *userImage;

@end


@implementation User


- (User*)initUserWithFirstName:(NSString*)firstName LastName:(NSString*)lastName UserPlan:(Plan*)plan {
    
    User *user = [[User alloc] init];
    
    user.firstName = firstName;
    user.lastName = lastName;
    
    user.name = [@[firstName, lastName] componentsJoinedByString:@" "];

    

    self.userImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        
    NSString *firstLetter = [firstName substringToIndex:1];
    NSString *secondLetter = [lastName substringToIndex:1];
        
    user.initials = [[@[firstLetter, secondLetter] componentsJoinedByString:@""] uppercaseString];
        
    
    
    if (plan == nil) {
        plan = [[Plan alloc] init];
        plan.name = @"Кофеман - Базовый";
    }
    user.plan = plan;
    
    return user;
}


@end
