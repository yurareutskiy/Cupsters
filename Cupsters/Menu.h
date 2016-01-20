//
//  Menu.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/20/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <CoreData/CoreData.h>
@class Cafe, Coffee;

@interface Menu : NSManagedObject

@property (weak, nonatomic) Cafe *cafe;
@property (weak, nonatomic) Coffee *coffee;

@end
