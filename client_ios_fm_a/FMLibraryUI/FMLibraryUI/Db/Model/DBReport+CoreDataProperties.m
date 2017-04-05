//
//  DBReport+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBReport+CoreDataProperties.h"

@implementation DBReport (CoreDataProperties)

+ (NSFetchRequest<DBReport *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBReport"];
}

@dynamic buildingId;
@dynamic cityId;
@dynamic desc;
@dynamic floorId;
@dynamic imageCount;
@dynamic isValidation;
@dynamic name;
@dynamic orderType;
@dynamic orgId;
@dynamic patrolItemDetailId;
@dynamic phone;
@dynamic priorityId;
@dynamic processId;
@dynamic projectId;
@dynamic reportId;
@dynamic reqId;
@dynamic roomId;
@dynamic siteId;
@dynamic stypeId;
@dynamic userId;

@end
