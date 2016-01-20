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

@implementation Token

- (BOOL)checkToken {
    userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"token"]) {
        [self createFirstToken];
    }
    
    return YES;
}

- (void)createFirstToken {
    server = [[Server alloc] init];
    ServerRequest *request = [ServerRequest initRequest:ServerRequestTypePOST
                                                   With:@{@"first":@"yes",
                                                             @"id":[userDefaults objectForKey:@"id"]}
                                                     To:ActivityURLStrring];
    [server sentToServer:request OnSuccess:^(NSDictionary *result) {
        NSLog(@"%@", result[@"token"]);
        [userDefaults setObject:result[@"token"] forKey:@"token"];
    } OrFailure:^(NSError *error) {
        NSLog(@"%@", [error debugDescription]);
    }];
}

@end
