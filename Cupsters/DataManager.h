//
//  DataManager.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/22/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DataManager : NSFetchedResultsController

- (void)saveDataWithLogin:(NSDictionary*)result;
- (void)saveDataWithLoginInSN:(NSString*)sn WithResult:(NSDictionary *)result;
- (void)saveDataWithSignUp:(NSDictionary *)result;
- (void)saveDataWithSignUpInSN:(NSString*)sn WithResult:(NSDictionary *)result;

- (void)saveDataWithStart:(NSArray*)data From:(NSString*)object;
- (NSArray*)getDataFromEntity:(NSString*)entityName;

//- (NSArray*)dataFr

+ (instancetype)sharedManager;

@end
