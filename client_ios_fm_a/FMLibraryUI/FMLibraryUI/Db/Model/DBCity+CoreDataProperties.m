//
//  DBCity+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBCity+CoreDataProperties.h"

@implementation DBCity (CoreDataProperties)

+ (NSFetchRequest<DBCity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBCity"];
}

@dynamic cityId;
@dynamic name;
@dynamic timeZone;
@dynamic projectId;

@end
