//
//  DBSpotCheckContent+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSpotCheckContent+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBSpotCheckContent (CoreDataProperties)

+ (NSFetchRequest<DBSpotCheckContent *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *comment;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSNumber *contentType;
@property (nullable, nonatomic, copy) NSNumber *defaultInputValue;
@property (nullable, nonatomic, copy) NSString *defaultSelectValue;
@property (nullable, nonatomic, copy) NSNumber *deviceId;
@property (nullable, nonatomic, copy) NSString *exceptions;
@property (nullable, nonatomic, copy) NSNumber *finish;
@property (nullable, nonatomic, copy) NSNumber *finishEndDate;
@property (nullable, nonatomic, copy) NSNumber *finishStartDate;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSNumber *inputFloor;
@property (nullable, nonatomic, copy) NSNumber *inputUpper;
@property (nullable, nonatomic, copy) NSNumber *patrolTaskId;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSString *resultInput;
@property (nullable, nonatomic, copy) NSString *resultSelect;
@property (nullable, nonatomic, copy) NSNumber *resultType;
@property (nullable, nonatomic, copy) NSString *selectEnum;
@property (nullable, nonatomic, copy) NSString *selectRightValue;
@property (nullable, nonatomic, copy) NSNumber *spotCheckContentId;
@property (nullable, nonatomic, copy) NSString *spotCode;
@property (nullable, nonatomic, copy) NSNumber *spotId;
@property (nullable, nonatomic, copy) NSNumber *status;
@property (nullable, nonatomic, copy) NSString *unit;
@property (nullable, nonatomic, copy) NSNumber *userId;
@property (nullable, nonatomic, copy) NSNumber *validStatus;

@end

NS_ASSUME_NONNULL_END
