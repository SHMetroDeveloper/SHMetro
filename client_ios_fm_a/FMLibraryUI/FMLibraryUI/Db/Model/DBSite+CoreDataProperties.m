//
//  DBSite+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSite+CoreDataProperties.h"

@implementation DBSite (CoreDataProperties)

+ (NSFetchRequest<DBSite *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBSite"];
}

@dynamic cityId;
@dynamic code;
@dynamic name;
@dynamic projectId;
@dynamic siteId;

@end
