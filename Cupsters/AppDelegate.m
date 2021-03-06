//
//  AppDelegate.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/5/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "Server.h"
#import "DataManager.h"
#import <RKDropdownAlert/RKDropdownAlert.h>
@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [GMSServices provideAPIKey:@"AIzaSyCHauzaNT7DhutAtVOw5qldV2OzD3Z3YWU"];
    // Override point for customization after application launch.
    
//    NSLog(@"token - %@",  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
    
    ServerRequest *request = [ServerRequest initRequest:ServerRequestTypeGET With:nil To:CafeURLStrring];
    Server *server = [[Server alloc] init];
    [server sentToServer:request OnSuccess:^(id result) {
        [[DataManager sharedManager] loadDataWithStart:result From:@"Cafes"];
        NSLog(@"%@", result);
    } OrFailure:nil];
    request.objectRequest = CoffeeURLStrring;
    [server sentToServer:request OnSuccess:^(id result) {
        [[DataManager sharedManager] loadDataWithStart:result From:@"Coffees"];
        NSLog(@"%@", result);
    } OrFailure:nil];
    request.objectRequest = TariffURLStrring;
    [server sentToServer:request OnSuccess:^(id result) {
        NSLog(@"%@", result);
        [[DataManager sharedManager] loadDataWithStart:result From:@"Tariffs"];
    } OrFailure:^(NSError *error) {
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if (!status) {
            NSString* title = @"Отсутствует интернет соединение";
//            NSString* message = @"Для работы с приложением необходимо соединение с интернетом";
            [RKDropdownAlert title:title message:nil backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil time:1000];
        }
    }];
    

    
    return YES;
}

- (void)checkToken {

}

- (void)saveCafeData:(NSDictionary*)dict {
    NSEntityDescription *cafeEntity = [NSEntityDescription entityForName:@"Cafes" inManagedObjectContext:self.managedObjectContext];
    
    for (int i = 0; i < [dict count]; i++) {
        NSDictionary *data = [(NSArray*)dict objectAtIndex:i];
        NSManagedObject *cafe = [[NSManagedObject alloc] initWithEntity:cafeEntity insertIntoManagedObjectContext:self.managedObjectContext];
        for (NSString *key in [data allKeys]) {
            if ([key isEqualToString:@"id"]) {
                [cafe setValue:[NSNumber numberWithInt:[data[key] intValue]] forKey:key];
            } else {
                [cafe setValue:data[key] forKey:key];
            }
        }
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"%@", [error debugDescription]);
        }
    }
}

- (void)saveMenuData:(NSDictionary*)dict {
    NSEntityDescription *cafeEntity = [NSEntityDescription entityForName:@"Cafes" inManagedObjectContext:self.managedObjectContext];
    
    for (int i = 0; i < [dict count]; i++) {
        NSDictionary *data = [(NSArray*)dict objectAtIndex:i];
        NSManagedObject *cafe = [[NSManagedObject alloc] initWithEntity:cafeEntity insertIntoManagedObjectContext:self.managedObjectContext];
        for (NSString *key in [data allKeys]) {
            if ([key isEqualToString:@"id"]) {
                [cafe setValue:[NSNumber numberWithInt:[data[key] intValue]] forKey:key];
            } else {
                [cafe setValue:data[key] forKey:key];
            }
        }
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"%@", [error debugDescription]);
        }
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.reutskiy.Cupsters" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Cupsters" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Cupsters.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
