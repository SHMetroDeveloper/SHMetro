//
//  DBSpotCheckContent+CoreDataProperties.m
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSpotCheckContent+CoreDataProperties.h"

@implementation DBSpotCheckContent (CoreDataProperties)

+ (NSFetchRequest<DBSpotCheckContent *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DBSpotCheckContent"];
}

@dynamic comment;
@dynamic content;
@dynamic contentType;
@dynamic defaultInputValue;
@dynamic defaultSelectValue;
@dynamic deviceId;
@dynamic exceptions;
@dynamic finish;
@dynamic finishEndDate;
@dynamic finishStartDate;
@dynamic id;
@dynamic inputFloor;
@dynamic inputUpper;
@dynamic patrolTaskId;
@dynamic projectId;
@dynamic resultInput;
@dynamic resultSelect;
@dynamic resultType;
@dynamic selectEnum;
@dynamic selectRightValue;
@dynamic spotCheckContentId;
@dynamic spotCode;
@dynamic spotId;
@dynamic status;
@dynamic unit;
@dynamic userId;
@dynamic validStatus;

@end
