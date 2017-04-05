//
//  DBNotification+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBNotification+CoreDataProperties.h"

@implementation DBNotification (CoreDataProperties)

+ (NSFetchRequest<DBNotification *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBNotification"];
}

@dynamic assetId;
@dynamic bulletinId;
@dynamic content;
@dynamic deleted;
@dynamic inventoryId;
@dynamic patrolId;
@dynamic pmId;
@dynamic projectId;
@dynamic read;
@dynamic receiveTime;
@dynamic recordId;
@dynamic reservationId;
@dynamic title;
@dynamic todoId;
@dynamic type;
@dynamic userId;
@dynamic woId;
@dynamic woStatus;

@end
