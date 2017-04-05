//
//  DBBaseDownloadRecord+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBBaseDownloadRecord+CoreDataProperties.h"

@implementation DBBaseDownloadRecord (CoreDataProperties)

+ (NSFetchRequest<DBBaseDownloadRecord *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBBaseDownloadRecord"];
}

@dynamic dataType;
@dynamic id;
@dynamic preRequestDate;
@dynamic projectId;

@end
