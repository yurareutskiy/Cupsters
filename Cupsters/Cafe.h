//
//  Cafe.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/20/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Cafe : NSManagedObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *lattitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *cafeopen;
@property (strong, nonatomic) NSString *cafeclose;
@property (strong, nonatomic) NSNumber *id;


@end
