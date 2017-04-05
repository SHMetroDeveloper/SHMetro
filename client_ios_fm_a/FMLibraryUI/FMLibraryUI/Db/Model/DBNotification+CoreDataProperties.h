//
//  DBNotification+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBNotification+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBNotification (CoreDataProperties)

+ (NSFetchRequest<DBNotification *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *assetId;
@property (nullable, nonatomic, copy) NSNumber *bulletinId;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSNumber *deleted;
@property (nullable, nonatomic, copy) NSNumber *inventoryId;
@property (nullable, nonatomic, copy) NSNumber *patrolId;
@property (nullable, nonatomic, copy) NSNumber *pmId;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *read;
@property (nullable, nonatomic, copy) NSNumber *receiveTime;
@property (nullable, nonatomic, copy) NSNumber *recordId;
@property (nullable, nonatomic, copy) NSNumber *reservationId;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSNumber *todoId;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, copy) NSNumber *userId;
@property (nullable, nonatomic, copy) NSNumber *woId;
@property (nullable, nonatomic, copy) NSNumber *woStatus;

@end

NS_ASSUME_NONNULL_END
