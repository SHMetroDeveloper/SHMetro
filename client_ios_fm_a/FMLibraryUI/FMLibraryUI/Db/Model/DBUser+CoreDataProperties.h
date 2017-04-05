//
//  DBUser+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBUser (CoreDataProperties)

+ (NSFetchRequest<DBUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *emDesc;
@property (nullable, nonatomic, copy) NSNumber *emId;
@property (nullable, nonatomic, copy) NSString *loginName;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *orgId;
@property (nullable, nonatomic, copy) NSString *orgName;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSNumber *pictureId;
@property (nullable, nonatomic, copy) NSString *position;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *userId;
@property (nullable, nonatomic, copy) NSString *locationName;
@property (nullable, nonatomic, copy) NSNumber *cityId;
@property (nullable, nonatomic, copy) NSNumber *siteId;
@property (nullable, nonatomic, copy) NSNumber *buildingId;
@property (nullable, nonatomic, copy) NSNumber *floorId;
@property (nullable, nonatomic, copy) NSNumber *roomId;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, copy) NSNumber *qrcodeId;

@end

NS_ASSUME_NONNULL_END
