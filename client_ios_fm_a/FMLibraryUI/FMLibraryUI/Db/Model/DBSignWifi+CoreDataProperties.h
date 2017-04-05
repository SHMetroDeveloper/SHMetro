//
//  DBSignWifi+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSignWifi+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBSignWifi (CoreDataProperties)

+ (NSFetchRequest<DBSignWifi *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *enable;
@property (nullable, nonatomic, copy) NSString *mac;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *wifiId;

@end

NS_ASSUME_NONNULL_END
