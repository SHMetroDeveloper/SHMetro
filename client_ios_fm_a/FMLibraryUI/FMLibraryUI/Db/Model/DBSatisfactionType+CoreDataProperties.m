//
//  DBSatisfactionType+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSatisfactionType+CoreDataProperties.h"

@implementation DBSatisfactionType (CoreDataProperties)

+ (NSFetchRequest<DBSatisfactionType *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBSatisfactionType"];
}

@dynamic degree;
@dynamic projectId;
@dynamic recordId;
@dynamic sdId;
@dynamic sdValue;

@end
