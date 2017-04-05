//
//  DBDevice+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBDevice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBDevice (CoreDataProperties)

+ (NSFetchRequest<DBDevice *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *buildingId;
@property (nullable, nonatomic, copy) NSNumber *cityId;
@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSNumber *deviceId;
@property (nullable, nonatomic, copy) NSNumber *deviceTypeId;
@property (nullable, nonatomic, copy) NSNumber *floorId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSString *qrcode;
@property (nullable, nonatomic, copy) NSNumber *roomId;
@property (nullable, nonatomic, copy) NSNumber *siteId;

@end

NS_ASSUME_NONNULL_END
