//
//  DBSignLocation+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSignLocation+CoreDataProperties.h"

@implementation DBSignLocation (CoreDataProperties)

+ (NSFetchRequest<DBSignLocation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBSignLocation"];
}

@dynamic desc;
@dynamic enable;
@dynamic lat;
@dynamic locationId;
@dynamic lon;
@dynamic name;
@dynamic projectId;

@end
