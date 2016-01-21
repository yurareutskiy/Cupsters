//
//  Token.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/20/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "Token.h"
#import "Server.h"
#import "Constants.h"

@interface Token ()


@end

NSUserDefaults *userDefaults;
Server *server;
NSString *token;
NSString *serverToken;

@implementation Token

-(instancetype)init {
    server = [[Server alloc] init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    return [super init];
}

- (BOOL)checkToken {
    token = [userDefaults objectForKey:@"token"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    // dispatch_semaphore_signal(sema);
    
    ServerRequest *request = [ServerRequest initRequest:ServerRequestTypePOST
                                                   With:@{@"token":[userDefaults objectForKey:@"token"],
                                                        @"user_id":[userDefaults objectForKey:@"id"]}
                                                     To:ActivityURLStrring];
    [server sentToServer:request OnSuccess:^(NSDictionary *result) {
        serverToken = result[@"token"];
        dispatch_semaphore_signal(sema);
    } OrFailure:^(NSError *error) {
        NSLog(@"%@", [error debugDescription]);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    sema = NULL;
    if ([serverToken isEqualToString:token]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)createFirstToken {
    ServerRequest *request = [ServerRequest initRequest:ServerRequestTypePOST
                                                   With:@{@"first":@"yes",
                                                             @"user_id":[userDefaults objectForKey:@"id"]}
                                                     To:ActivityURLStrring];
    [server sentToServer:request OnSuccess:^(NSDictionary *result) {
        NSLog(@"%@", result[@"token"]);
        [userDefaults setObject:result[@"token"] forKey:@"token"];
    } OrFailure:^(NSError *error) {
        NSLog(@"%@", [error debugDescription]);
    }];
}

@end
