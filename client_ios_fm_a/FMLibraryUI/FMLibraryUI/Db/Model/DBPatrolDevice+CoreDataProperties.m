//
//  DBPatrolDevice+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/19.
//
//

#import "DBPatrolDevice+CoreDataProperties.h"

@implementation DBPatrolDevice (CoreDataProperties)

+ (NSFetchRequest<DBPatrolDevice *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBPatrolDevice"];
}

@dynamic checkNumber;
@dynamic code;
@dynamic deviceId;
@dynamic exception;
@dynamic exceptionDesc;
@dynamic exceptionStatus;
@dynamic finish;
@dynamic id;
@dynamic name;
@dynamic patrolTaskId;
@dynamic projectId;
@dynamic spotCode;
@dynamic spotId;
@dynamic userId;
@dynamic patrolTask;

@end
