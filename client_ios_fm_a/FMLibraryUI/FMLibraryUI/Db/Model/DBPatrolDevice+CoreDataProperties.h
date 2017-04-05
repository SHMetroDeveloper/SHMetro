//
//  DBPatrolDevice+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/19.
//
//

#import "DBPatrolDevice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBPatrolDevice (CoreDataProperties)

+ (NSFetchRequest<DBPatrolDevice *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *checkNumber;
@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSNumber *deviceId;
@property (nullable, nonatomic, copy) NSNumber *exception;
@property (nullable, nonatomic, copy) NSString *exceptionDesc;
@property (nullable, nonatomic, copy) NSNumber *exceptionStatus;
@property (nullable, nonatomic, copy) NSNumber *finish;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *patrolTaskId;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSString *spotCode;
@property (nullable, nonatomic, copy) NSNumber *spotId;
@property (nullable, nonatomic, copy) NSNumber *userId;
@property (nullable, nonatomic, retain) DBPatrolTask *patrolTask;

@end

NS_ASSUME_NONNULL_END
