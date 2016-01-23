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


+ (User*)initUserWithFirstName:(NSString*)firstName LastName:(NSString*)lastName userID:(NSString*)id UserPlan:(NSDictionary*)plan {
    
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

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.initials forKey:@"initials"];
    [aCoder encodeObject:self.plan forKey:@"plan"];
    [aCoder encodeObject:self.id forKey:@"id"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.initials = [aDecoder decodeObjectForKey:@"initials"];
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.plan = [aDecoder decodeObjectForKey:@"plan"];
    }
    return self;
}

@end
