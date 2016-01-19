//
//  ServerResponse.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/19/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

typedef enum {
    ServerResponseTypeSuccess,
    ServerResponseTypeError
} ServerResponseType;

#import <Foundation/Foundation.h>
#import "ServerError.h"

@interface ServerResponse : NSURLResponse

@property (assign, nonatomic) ServerResponseType type;
@property (strong, nonatomic) NSDictionary *body;
@property (strong, nonatomic) ServerError *error;

+ (instancetype)parseResponse:(NSDictionary*)response;

@end
