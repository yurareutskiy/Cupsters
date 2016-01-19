//
//  ServerRequest.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/19/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ServerRequestTypeGET,
    ServerRequestTypePOST,
    ServerRequestTypePUT,
    ServerRequestTypeDELETE
} ServerRequestType;

@interface ServerRequest : NSURLRequest

@property (assign, nonatomic) ServerRequestType type;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSString *objectRequest;

+ (instancetype)initRequest:(ServerRequestType)type With:(NSDictionary*)parameters To:(NSString*)object;

@end
