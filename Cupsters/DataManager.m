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
    
//    Plan *plan = nil;
    NSDictionary *plan = nil;
    if (![result[@"plan"] isKindOfClass:[NSString class]]) {
//        plan = [Plan initWithParams:result[@"plan"]];
        plan = result[@"plan"];
    }
    User *user = [User initUserWithFirstName:result[@"user"][@"first_name"] LastName:result[@"user"][@"last_name"] userID:result[@"user"][@"id"] UserPlan:plan];
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [ud setObject:userData forKey:@"user"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    if (![result[@"orders"] isKindOfClass:[NSString class]]) {
//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Orders" inManagedObjectContext:context];
        for (int i = 0; i < [((NSArray*)result[@"orders"]) count]; i++) {
            NSDictionary *tempDict = result[@"orders"][i];
            NSManagedObject *order = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            [order setValue:tempDict[@"cafe"] forKey:@"cafe"];
            [order setValue:tempDict[@"coffee"] forKey:@"coffee"];
            [order setValue:tempDict[@"volume"] forKey:@"volume"];
            [order setValue:tempDict[@"date_accept"] forKey:@"date"];
            [order setValue:[NSNumber numberWithInt:((NSString*)tempDict[@"id"]).intValue] forKey:@"id"];
            NSError *error = nil;
            [context save:&error];
            if (error) {
                NSLog(@"%@", [error debugDescription]);
            }
        }
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
////        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Orders" inManagedObjectContext:context];
//        [fetchRequest setEntity:entity];
//        NSError *error = nil;
//        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//        NSLog(@"%@", fetchedObjects);
    }
}


- (NSArray*)getData {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Orders" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    for (NSManagedObject *object in fetchedObjects) {
//        NSLog(@"%@", [object valueForKey:@"cafe"]);
//    }
    return fetchedObjects;
}


@end








