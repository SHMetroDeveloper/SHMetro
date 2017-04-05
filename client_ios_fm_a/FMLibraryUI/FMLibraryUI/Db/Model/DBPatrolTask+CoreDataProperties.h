//
//  DBPatrolTask+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBPatrolTask+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBPatrolTask (CoreDataProperties)

+ (NSFetchRequest<DBPatrolTask *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *deviceNumber;
@property (nullable, nonatomic, copy) NSNumber *edit;
@property (nullable, nonatomic, copy) NSNumber *endDate;
@property (nullable, nonatomic, copy) NSNumber *exception;
@property (nullable, nonatomic, copy) NSNumber *finish;
@property (nullable, nonatomic, copy) NSNumber *finishEndDate;
@property (nullable, nonatomic, copy) NSNumber *finishStartDate;
@property (nullable, nonatomic, copy) NSNumber *patrolTaskId;
@property (nullable, nonatomic, copy) NSString *patrolTaskName;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *spotNumber;
@property (nullable, nonatomic, copy) NSNumber *startDate;
@property (nullable, nonatomic, copy) NSNumber *status;
@property (nullable, nonatomic, copy) NSNumber *userId;
@property (nullable, nonatomic, copy) NSNumber *taskType;
@property (nullable, nonatomic, retain) NSSet<DBPatrolSpot *> *spot;

@end

@interface DBPatrolTask (CoreDataGeneratedAccessors)

- (void)addSpotObject:(DBPatrolSpot *)value;
- (void)removeSpotObject:(DBPatrolSpot *)value;
- (void)addSpot:(NSSet<DBPatrolSpot *> *)values;
- (void)removeSpot:(NSSet<DBPatrolSpot *> *)values;

@end

NS_ASSUME_NONNULL_END
