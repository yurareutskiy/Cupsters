//
//  Menu+CoreDataProperties.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/20/16.
//  Copyright © 2016 Styleru. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Menu.h"

NS_ASSUME_NONNULL_BEGIN

@interface Menu (CoreDataProperties)

@property (nullable, nonatomic, retain) Cafe *id_cafe;
@property (nullable, nonatomic, retain) Coffee *id_coffee;

@end

NS_ASSUME_NONNULL_END
