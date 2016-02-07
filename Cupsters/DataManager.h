//
//  DataManager.h
//  Cupsters
//
//  Created by Reutskiy Jury on 1/22/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <CoreData/CoreData.h>

@protocol DataManagerDelegate <NSObject>
@optional
- (void)finishLoadingDataFromEntity:(NSString*)entity;

@end

@interface DataManager : NSFetchedResultsController

@property (weak, nonatomic) id <DataManagerDelegate> delegate;

//- (void)saveDataWithLogin:(NSDictionary*)result;
//- (void)saveDataWithLoginInSN:(NSString*)sn WithResult:(NSDictionary *)result;
//- (void)saveDataWithSignUp:(NSDictionary *)result;
//- (void)saveDataWithSignUpInSN:(NSString*)sn WithResult:(NSDictionary *)result;
//
//- (void)saveDataWithStart:(NSArray*)data From:(NSString*)object;
//- (NSArray*)getDataFromEntity:(NSString*)entityName;

- (void)saveDataWithLogin:(NSDictionary*)result;
- (void)loadDataWithStart:(NSArray*)data From:(NSString*)object;
- (NSArray*)getDataFromEntity:(NSString*)entityName;
- (NSArray*)getOrders:(NSArray*)raw_data;

+ (instancetype)sharedManager;

@end
