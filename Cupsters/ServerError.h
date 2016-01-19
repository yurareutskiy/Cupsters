//
//  ServerError.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/19/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerError : NSError

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *serverCode;

+ (instancetype)initWithResponse:(NSDictionary*)response;

@end
