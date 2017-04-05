//
//  DBRequirementType+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBRequirementType+CoreDataProperties.h"

@implementation DBRequirementType (CoreDataProperties)

+ (NSFetchRequest<DBRequirementType *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBRequirementType"];
}

@dynamic fullName;
@dynamic name;
@dynamic parentTypeId;
@dynamic projectId;
@dynamic recordId;
@dynamic typeId;

@end
