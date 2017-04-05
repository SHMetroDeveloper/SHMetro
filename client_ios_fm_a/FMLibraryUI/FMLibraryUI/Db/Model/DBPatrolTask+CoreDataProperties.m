//
//  DBPatrolTask+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBPatrolTask+CoreDataProperties.h"

@implementation DBPatrolTask (CoreDataProperties)

+ (NSFetchRequest<DBPatrolTask *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBPatrolTask"];
}

@dynamic deviceNumber;
@dynamic edit;
@dynamic endDate;
@dynamic exception;
@dynamic finish;
@dynamic finishEndDate;
@dynamic finishStartDate;
@dynamic patrolTaskId;
@dynamic patrolTaskName;
@dynamic projectId;
@dynamic spotNumber;
@dynamic startDate;
@dynamic status;
@dynamic userId;
@dynamic taskType;
@dynamic spot;

@end
