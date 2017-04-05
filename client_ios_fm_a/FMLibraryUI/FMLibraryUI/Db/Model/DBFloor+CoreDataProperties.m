//
//  DBFloor+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBFloor+CoreDataProperties.h"

@implementation DBFloor (CoreDataProperties)

+ (NSFetchRequest<DBFloor *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBFloor"];
}

@dynamic buildingId;
@dynamic code;
@dynamic floorId;
@dynamic name;
@dynamic projectId;

@end
