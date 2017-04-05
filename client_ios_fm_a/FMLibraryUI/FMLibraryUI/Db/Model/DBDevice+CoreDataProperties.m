//
//  DBDevice+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBDevice+CoreDataProperties.h"

@implementation DBDevice (CoreDataProperties)

+ (NSFetchRequest<DBDevice *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBDevice"];
}

@dynamic buildingId;
@dynamic cityId;
@dynamic code;
@dynamic deviceId;
@dynamic deviceTypeId;
@dynamic floorId;
@dynamic name;
@dynamic projectId;
@dynamic qrcode;
@dynamic roomId;
@dynamic siteId;

@end
