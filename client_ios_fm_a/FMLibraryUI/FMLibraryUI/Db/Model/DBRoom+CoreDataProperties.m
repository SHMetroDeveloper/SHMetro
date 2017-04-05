//
//  DBRoom+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBRoom+CoreDataProperties.h"

@implementation DBRoom (CoreDataProperties)

+ (NSFetchRequest<DBRoom *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBRoom"];
}

@dynamic code;
@dynamic floorId;
@dynamic name;
@dynamic projectId;
@dynamic roomId;

@end
