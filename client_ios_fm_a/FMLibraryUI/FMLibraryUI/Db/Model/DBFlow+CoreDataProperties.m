//
//  DBFlow+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/3.
//
//

#import "DBFlow+CoreDataProperties.h"

@implementation DBFlow (CoreDataProperties)

+ (NSFetchRequest<DBFlow *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBFlow"];
}

@dynamic buildingId;
@dynamic cityId;
@dynamic floorId;
@dynamic flowId;
@dynamic orderType;
@dynamic orgId;
@dynamic priorityId;
@dynamic projectId;
@dynamic roomId;
@dynamic siteId;
@dynamic stypeId;
@dynamic notice;

@end
