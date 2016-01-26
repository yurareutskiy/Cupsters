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
    NSLog(@"%@", [result[@"orders"] objectAtIndex:0]);
    if (![[result[@"orders"] objectAtIndex:0] isKindOfClass:[NSString class]]) {
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
    [ud setObject:@"true" forKey:@"isLogin"];
}

- (void)loadDataWithStart:(NSArray*)data From:(NSString*)object {
    
    if (data) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:object inManagedObjectContext:context];
        request.entity = entity;
        NSError *error = nil;
        NSArray *fetchResult = [context executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"%@", [error debugDescription]);
            return;
        }
        for (NSManagedObject *object in fetchResult) {
            [context deleteObject:object];
        }
        [context save:&error];
        if (error) {
            NSLog(@"%@", [error debugDescription]);
            return;
        }
        for (NSDictionary __strong *item in data) {
            NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            if ([item objectForKey:@"cafeclose"]) {
                NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:item];
                [mutableDict setObject:[NSString stringWithFormat:@"%@\n%@", [item objectForKey:@"cafeclose"], [item objectForKey:@"cafeopen"]] forKey:@"time"];
                [mutableDict removeObjectsForKeys:@[@"cafeclose", @"cafeopen"]];
                item = mutableDict;
            }
            
            for (NSString *key in [item allKeys]) {
                if ([key isEqualToString:@"id"] || [key isEqualToString:@"volume"] || [key isEqualToString:@"price"] || [key isEqualToString:@"count"] || [key isEqualToString:@"id_cafe"]) {
                    [managedObject setValue:[NSNumber numberWithInt:[item[key] intValue]] forKey:key];
                } else if ([key isEqualToString:@"lattitude"] || [key isEqualToString:@"longitude"]) {
                    [managedObject setValue:[NSNumber numberWithDouble:[item[key] doubleValue]] forKey:key];
                } else if ([@[@"date", @"open", @"close", @"open_weekend", @"close_weekend"] containsObject:key]) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    if ([key isEqualToString:@"date"]) {
                        formatter.dateFormat = @"y-M-d H:m:s";
                    } else {
                        formatter.dateFormat = @"H:m:s";
                    }
                    NSDate *date = [formatter dateFromString:item[key]];
                    [managedObject setValue:date forKey:key];
                } else {
                    [managedObject setValue:item[key] forKey:key];
                }
            }
            [context save:&error];
        }
        
        NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
        NSLog(@"%@", fetchedObjects);

        
    }

}


- (NSArray*)getDataFromEntity:(NSString*)entityName {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

    return fetchedObjects;
}




@end








