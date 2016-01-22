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


+ (User*)initUserWithFirstName:(NSString*)firstName LastName:(NSString*)lastName userID:(NSString*)id UserPlan:(Plan*)plan {
    
    User *user = [[User alloc] init];
    
    user.firstName = firstName;
    user.lastName = lastName;
    
    user.name = [@[firstName, lastName] componentsJoinedByString:@" "];

    user.id = [[NSNumber alloc] initWithInt:((NSString*)id).intValue];
        
    NSString *firstLetter = [firstName substringToIndex:1];
    NSString *secondLetter = [lastName substringToIndex:1];
        
    user.initials = [[@[firstLetter, secondLetter] componentsJoinedByString:@""] uppercaseString];
    
    user.plan = plan;
    
    return user;
}


@end
