//
//  DBOrg+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBOrg+CoreDataProperties.h"

@implementation DBOrg (CoreDataProperties)

+ (NSFetchRequest<DBOrg *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBOrg"];
}

@dynamic code;
@dynamic fullName;
@dynamic level;
@dynamic name;
@dynamic orgId;
@dynamic parentId;
@dynamic projectId;

@end
