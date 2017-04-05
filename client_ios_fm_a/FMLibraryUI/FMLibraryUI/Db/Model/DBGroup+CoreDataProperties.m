//
//  DBGroup+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBGroup+CoreDataProperties.h"

@implementation DBGroup (CoreDataProperties)

+ (NSFetchRequest<DBGroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBGroup"];
}

@dynamic emId;
@dynamic groupId;
@dynamic groupName;
@dynamic projectId;
@dynamic recordId;

@end
