//
//  DBFlow+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/3.
//
//

#import "DBFlow+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBFlow (CoreDataProperties)

+ (NSFetchRequest<DBFlow *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *buildingId;
@property (nullable, nonatomic, copy) NSNumber *cityId;
@property (nullable, nonatomic, copy) NSNumber *floorId;
@property (nullable, nonatomic, copy) NSNumber *flowId;
@property (nullable, nonatomic, copy) NSNumber *orderType;
@property (nullable, nonatomic, copy) NSNumber *orgId;
@property (nullable, nonatomic, copy) NSNumber *priorityId;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *roomId;
@property (nullable, nonatomic, copy) NSNumber *siteId;
@property (nullable, nonatomic, copy) NSNumber *stypeId;
@property (nullable, nonatomic, copy) NSString *notice;

@end

NS_ASSUME_NONNULL_END
