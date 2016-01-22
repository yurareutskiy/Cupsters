//
//  DataManager.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/22/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "DataManager.h"
#import "Plan.h"
#import "User.h"
#import "AppDelegate.h"

@implementation DataManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}


#pragma mark - Saving data

- (void)saveDataWithLogin:(NSDictionary*)result {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:@"true" forKey:@"isLogin"];
    
    [ud setObject:result[@"token"] forKey:@"token"];
    
    Plan *plan = nil;
    if (![result[@"plan"] isKindOfClass:[NSString class]]) {
        plan = [Plan initWithParams:result[@"plan"]];
    }
    User *user = [User initUserWithFirstName:result[@"user"][@"first_name"] LastName:result[@"user"][@"last_name"] userID:result[@"user"][@"id"] UserPlan:plan];
    [ud setObject:user forKey:@"user"];
    
    
    if ([result[@"orders"] isKindOfClass:[NSDictionary class]]) {
//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Orders" inManagedObjectContext:self.managedObjectContext];
        for (int i = 0; i < [((NSArray*)result[@"orders"]) count]; i++) {
            NSDictionary *tempDict = result[@"orders"][i];
            NSManagedObject *order = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
            [order setValue:tempDict[@"cafe"] forKey:@"cafe"];
            [order setValue:tempDict[@"coffee"] forKey:@"coffee"];
            [order setValue:tempDict[@"volume"] forKey:@"volume"];
            [order setValue:tempDict[@"date_accept"] forKey:@"date"];
            [order setValue:[NSNumber numberWithInt:((NSString*)tempDict[@"id"]).intValue] forKey:@"id"];
            NSError *error = nil;
            [self.managedObjectContext save:&error];
            if (error) {
                NSLog(@"%@", [error debugDescription]);
            }
        }
    }
}

@end
