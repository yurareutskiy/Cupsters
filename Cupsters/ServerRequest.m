//
//  ServerRequest.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/19/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "ServerRequest.h"

@implementation ServerRequest

+ (instancetype)initRequest:(ServerRequestType)type With:(NSDictionary*)parameters To:(NSString*)object {
    ServerRequest *request = [[ServerRequest alloc] init];
    request.type = type;
    request.parameters = parameters;
    request.objectRequest = object;
    return request;
}

@end
