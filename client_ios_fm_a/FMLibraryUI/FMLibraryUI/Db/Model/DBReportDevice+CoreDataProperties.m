//
//  DBReportDevice+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBReportDevice+CoreDataProperties.h"

@implementation DBReportDevice (CoreDataProperties)

+ (NSFetchRequest<DBReportDevice *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBReportDevice"];
}

@dynamic deviceId;
@dynamic reportDeviceId;
@dynamic reportId;

@end
