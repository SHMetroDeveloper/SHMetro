//
//  DBPatrolSpot+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/17.
//
//

#import "DBPatrolSpot+CoreDataProperties.h"

@implementation DBPatrolSpot (CoreDataProperties)

+ (NSFetchRequest<DBPatrolSpot *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBPatrolSpot"];
}

@dynamic code;
@dynamic deviceCheckNumber;
@dynamic edit;
@dynamic exception;
@dynamic finish;
@dynamic finishEndDateTime;
@dynamic finishStartDateTime;
@dynamic id;
@dynamic markFinish;
@dynamic name;
@dynamic patrolSpotId;
@dynamic patrolTaskId;
@dynamic patrolTaskName;
@dynamic place;
@dynamic projectId;
@dynamic spotCheckNumber;
@dynamic spotId;
@dynamic userId;
@dynamic cityId;
@dynamic siteId;
@dynamic buildingId;
@dynamic floorId;
@dynamic roomId;
@dynamic patrolTask;

@end
