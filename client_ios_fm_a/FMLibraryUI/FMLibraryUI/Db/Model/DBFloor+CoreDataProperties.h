//
//  DBFloor+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBFloor+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBFloor (CoreDataProperties)

+ (NSFetchRequest<DBFloor *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *buildingId;
@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSNumber *floorId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *projectId;

@end

NS_ASSUME_NONNULL_END
