//
//  DBReportImage+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBReportImage+CoreDataProperties.h"

@implementation DBReportImage (CoreDataProperties)

+ (NSFetchRequest<DBReportImage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBReportImage"];
}

@dynamic path;
@dynamic reportId;
@dynamic reportImageId;

@end
