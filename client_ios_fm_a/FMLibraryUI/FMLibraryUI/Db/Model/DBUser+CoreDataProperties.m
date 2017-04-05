//
//  DBUser+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBUser+CoreDataProperties.h"

@implementation DBUser (CoreDataProperties)

+ (NSFetchRequest<DBUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBUser"];
}

@dynamic email;
@dynamic emDesc;
@dynamic emId;
@dynamic loginName;
@dynamic name;
@dynamic orgId;
@dynamic orgName;
@dynamic password;
@dynamic phone;
@dynamic pictureId;
@dynamic position;
@dynamic projectId;
@dynamic userId;
@dynamic locationName;
@dynamic cityId;
@dynamic siteId;
@dynamic buildingId;
@dynamic floorId;
@dynamic roomId;
@dynamic type;
@dynamic qrcodeId;

@end
