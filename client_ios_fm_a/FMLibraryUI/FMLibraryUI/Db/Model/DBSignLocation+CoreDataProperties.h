//
//  DBSignLocation+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSignLocation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBSignLocation (CoreDataProperties)

+ (NSFetchRequest<DBSignLocation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSNumber *enable;
@property (nullable, nonatomic, copy) NSString *lat;
@property (nullable, nonatomic, copy) NSNumber *locationId;
@property (nullable, nonatomic, copy) NSString *lon;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *projectId;

@end

NS_ASSUME_NONNULL_END
