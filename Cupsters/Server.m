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

@implementation Server


- (void)sentToServer:(ServerRequest*)request OnSuccess:(void(^)(NSDictionary* result))success OrFailure:(void(^)(NSError* error))failure {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSLog(@"%@", request.objectRequest);
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseURLString, request.objectRequest];
    
    switch (request.type) {
        case ServerRequestTypeGET: {
            [manager GET:url parameters:request.parameters progress:nil success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
                NSLog(@"Code - %d", ((NSHTTPURLResponse*)task.response).statusCode);
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






@end
