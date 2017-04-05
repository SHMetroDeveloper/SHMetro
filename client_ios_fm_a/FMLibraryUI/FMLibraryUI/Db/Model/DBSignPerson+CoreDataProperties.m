//
//  DBSignPerson+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSignPerson+CoreDataProperties.h"

@implementation DBSignPerson (CoreDataProperties)

+ (NSFetchRequest<DBSignPerson *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBSignPerson"];
}

@dynamic emId;
@dynamic name;
@dynamic org;
@dynamic projectId;
@dynamic status;
@dynamic type;

@end
