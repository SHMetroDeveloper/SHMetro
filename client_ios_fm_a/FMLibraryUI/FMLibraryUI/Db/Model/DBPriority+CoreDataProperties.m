//
//  DBPriority+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBPriority+CoreDataProperties.h"

@implementation DBPriority (CoreDataProperties)

+ (NSFetchRequest<DBPriority *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBPriority"];
}

@dynamic color;
@dynamic desc;
@dynamic name;
@dynamic priorityId;
@dynamic projectId;

@end
