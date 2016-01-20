//
//  Coffee+CoreDataProperties.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/20/16.
//  Copyright © 2016 Styleru. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Coffee.h"

NS_ASSUME_NONNULL_BEGIN

@interface Coffee (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSNumber *volume;
@property (nullable, nonatomic, retain) NSSet<Menu *> *relationship;

@end

@interface Coffee (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(Menu *)value;
- (void)removeRelationshipObject:(Menu *)value;
- (void)addRelationship:(NSSet<Menu *> *)values;
- (void)removeRelationship:(NSSet<Menu *> *)values;

@end

NS_ASSUME_NONNULL_END
