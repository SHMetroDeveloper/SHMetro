//
//  DBStype+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBStype+CoreDataProperties.h"

@implementation DBStype (CoreDataProperties)

+ (NSFetchRequest<DBStype *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBStype"];
}

@dynamic desc;
@dynamic fullName;
@dynamic name;
@dynamic parentId;
@dynamic projectId;
@dynamic stypeId;

@end
