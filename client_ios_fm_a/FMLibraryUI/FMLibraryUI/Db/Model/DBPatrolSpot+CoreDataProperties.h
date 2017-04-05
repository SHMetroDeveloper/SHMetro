//
//  DBPatrolSpot+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/17.
//
//

#import "DBPatrolSpot+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBPatrolSpot (CoreDataProperties)

+ (NSFetchRequest<DBPatrolSpot *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSNumber *deviceCheckNumber;
@property (nullable, nonatomic, copy) NSNumber *edit;
@property (nullable, nonatomic, copy) NSNumber *exception;
@property (nullable, nonatomic, copy) NSNumber *finish;
@property (nullable, nonatomic, copy) NSNumber *finishEndDateTime;
@property (nullable, nonatomic, copy) NSNumber *finishStartDateTime;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSNumber *markFinish;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *patrolSpotId;
@property (nullable, nonatomic, copy) NSNumber *patrolTaskId;
@property (nullable, nonatomic, copy) NSString *patrolTaskName;
@property (nullable, nonatomic, copy) NSString *place;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *spotCheckNumber;
@property (nullable, nonatomic, copy) NSNumber *spotId;
@property (nullable, nonatomic, copy) NSNumber *userId;
@property (nullable, nonatomic, copy) NSNumber *cityId;
@property (nullable, nonatomic, copy) NSNumber *siteId;
@property (nullable, nonatomic, copy) NSNumber *buildingId;
@property (nullable, nonatomic, copy) NSNumber *floorId;
@property (nullable, nonatomic, copy) NSNumber *roomId;
@property (nullable, nonatomic, retain) DBPatrolTask *patrolTask;

@end

NS_ASSUME_NONNULL_END
