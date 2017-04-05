//
//  DBDeviceType+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBDeviceType+CoreDataProperties.h"

@implementation DBDeviceType (CoreDataProperties)

+ (NSFetchRequest<DBDeviceType *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBDeviceType"];
}

@dynamic code;
@dynamic desc;
@dynamic deviceTypeId;
@dynamic fullName;
@dynamic level;
@dynamic name;
@dynamic parentId;
@dynamic projectId;

@end
