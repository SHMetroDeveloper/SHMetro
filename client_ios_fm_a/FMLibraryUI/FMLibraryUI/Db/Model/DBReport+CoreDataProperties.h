//
//  DBReport+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBReport+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBReport (CoreDataProperties)

+ (NSFetchRequest<DBReport *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *buildingId;
@property (nullable, nonatomic, copy) NSNumber *cityId;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSNumber *floorId;
@property (nullable, nonatomic, copy) NSNumber *imageCount;
@property (nullable, nonatomic, copy) NSNumber *isValidation;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *orderType;
@property (nullable, nonatomic, copy) NSNumber *orgId;
@property (nullable, nonatomic, copy) NSNumber *patrolItemDetailId;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSNumber *priorityId;
@property (nullable, nonatomic, copy) NSNumber *processId;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *reportId;
@property (nullable, nonatomic, copy) NSNumber *reqId;
@property (nullable, nonatomic, copy) NSNumber *roomId;
@property (nullable, nonatomic, copy) NSNumber *siteId;
@property (nullable, nonatomic, copy) NSNumber *stypeId;
@property (nullable, nonatomic, copy) NSNumber *userId;

@end

NS_ASSUME_NONNULL_END
