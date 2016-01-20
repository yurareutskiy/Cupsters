//
//  Coffee.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/20/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Coffee : NSManagedObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *volume;
@property (strong, nonatomic) NSNumber *id;

@end
