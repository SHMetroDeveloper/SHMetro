//
//  DBSpotCheckContentPicture+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSpotCheckContentPicture+CoreDataProperties.h"

@implementation DBSpotCheckContentPicture (CoreDataProperties)

+ (NSFetchRequest<DBSpotCheckContentPicture *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBSpotCheckContentPicture"];
}

@dynamic contentId;
@dynamic id;
@dynamic imageId;
@dynamic projectId;
@dynamic spotCheckContentId;
@dynamic uploaded;
@dynamic url;
@dynamic userId;

@end
