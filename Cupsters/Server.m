//
//  Server.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/19/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "Server.h"
#import "Constants.h"
#import "User.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@implementation Server

- (void)sentToServer:(ServerRequest*)request OnSuccess:(void(^)(NSDictionary* result))success OrFailure:(void(^)(NSError* error))failure {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseURLString, request.objectRequest];
    
    switch (request.type) {
        case ServerRequestTypeGET: {
            [manager GET:url parameters:request.parameters progress:nil success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
                NSLog(@"JSON: %@", responseObject);
                ServerResponse *response = [ServerResponse parseResponse:responseObject];
                if (response.type == ServerResponseTypeSuccess) {
                    if (success) {
                        success(response.body);
                    }
                } else {
                    if (failure) {
                        failure(response.error);
                    }
                }
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case ServerRequestTypePOST: {
            [manager POST:url parameters:request.parameters progress:nil success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
                NSLog(@"JSON: %@", responseObject);
                ServerResponse *response = [ServerResponse parseResponse:responseObject];
                if (response.type == ServerResponseTypeSuccess) {
                    if (success) {
                        success(response.body);
                    }
                } else {
                    if (failure) {
                        failure(response.error);
                    }
                }
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case ServerRequestTypePUT: {
            [manager PUT:url parameters:request.parameters success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
                NSLog(@"JSON: %@", responseObject);
                ServerResponse *response = [ServerResponse parseResponse:responseObject];
                if (response.type == ServerResponseTypeSuccess) {
                    if (success) {
                        success(response.body);
                    }
                } else {
                    if (failure) {
                        failure(response.error);
                    }
                }
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case ServerRequestTypeDELETE: {
            [manager DELETE:url parameters:request.parameters success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
                NSLog(@"JSON: %@", responseObject);
                ServerResponse *response = [ServerResponse parseResponse:responseObject];
                if (response.type == ServerResponseTypeSuccess) {
                    if (success) {
                        success(response.body);
                    }
                } else {
                    if (failure) {
                        failure(response.error);
                    }
                }
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        default:
            return;
    }
}


#pragma mark - Saving data

- (void)saveDataWithLogin:(NSDictionary*)result {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:@"true" forKey:@"isLogin"];
    
    [ud setObject:@"token" forKey:result[@"token"]];

    Plan *plan = nil;
    if (![result[@"plan"] isKindOfClass:[NSString class]]) {
        Plan *plan = [Plan initWithParams:result[@"plan"]];
    }
    User *user = [User initUserWithFirstName:result[@"user"][@"first_name"] LastName:result[@"user"][@"last_name"] userID:result[@"user"][@"id"] UserPlan:plan];
    [ud setObject:user forKey:@"user"];
    

    if ([result[@"orders"] isKindOfClass:[NSDictionary class]]) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
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
    }
}




@end
