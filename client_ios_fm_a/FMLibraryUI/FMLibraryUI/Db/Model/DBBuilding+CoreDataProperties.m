//
//  DBBuilding+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/17.
//
//

#import "DBBuilding+CoreDataProperties.h"

@implementation DBBuilding (CoreDataProperties)

+ (NSFetchRequest<DBBuilding *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBBuilding"];
}

@dynamic buildingId;
@dynamic code;
@dynamic name;
@dynamic projectId;
@dynamic siteId;
@dynamic fullName;
@dynamic type;
@dynamic relatedBuildingId;
@dynamic isThisStation;

@end
