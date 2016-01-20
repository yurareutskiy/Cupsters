//
//  Cafe+CoreDataProperties.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/20/16.
//  Copyright © 2016 Styleru. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Cafe.h"

NS_ASSUME_NONNULL_BEGIN

@interface Cafe (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cafeclose;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *lattitude;
@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *cafeopen;
@property (nullable, nonatomic, retain) NSSet<Menu *> *relationship;

@end

@interface Cafe (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(Menu *)value;
- (void)removeRelationshipObject:(Menu *)value;
- (void)addRelationship:(NSSet<Menu *> *)values;
- (void)removeRelationship:(NSSet<Menu *> *)values;

@end

NS_ASSUME_NONNULL_END
