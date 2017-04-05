//
//  DBSignWifi+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSignWifi+CoreDataProperties.h"

@implementation DBSignWifi (CoreDataProperties)

+ (NSFetchRequest<DBSignWifi *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBSignWifi"];
}

@dynamic enable;
@dynamic mac;
@dynamic name;
@dynamic projectId;
@dynamic wifiId;

@end
