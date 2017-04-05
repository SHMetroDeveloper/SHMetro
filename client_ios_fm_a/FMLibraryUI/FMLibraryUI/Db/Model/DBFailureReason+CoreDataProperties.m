//
//  DBFailureReason+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBFailureReason+CoreDataProperties.h"

@implementation DBFailureReason (CoreDataProperties)

+ (NSFetchRequest<DBFailureReason *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBFailureReason"];
}

@dynamic reasonId;
@dynamic reasonCode;
@dynamic name;
@dynamic parentId;

@end
