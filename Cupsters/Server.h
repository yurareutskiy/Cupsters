//
//  Server.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/19/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ServerRequest.h"
#import "ServerResponse.h"
#import "ServerError.h"

@interface Server : NSObject

- (void)sentToServer:(ServerRequest*)request OnSuccess:(void(^)(NSDictionary* result))success OrFailure:(void(^)(NSError*))failure;

@end
