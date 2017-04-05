//
//  DBSignBluetooth+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSignBluetooth+CoreDataProperties.h"

@implementation DBSignBluetooth (CoreDataProperties)

+ (NSFetchRequest<DBSignBluetooth *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBSignBluetooth"];
}

@dynamic bluetoothId;
@dynamic enable;
@dynamic mac;
@dynamic name;
@dynamic projectId;

@end
