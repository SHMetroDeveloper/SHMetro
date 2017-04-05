//
//  DBRoom+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBRoom+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBRoom (CoreDataProperties)

+ (NSFetchRequest<DBRoom *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSNumber *floorId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *roomId;

@end

NS_ASSUME_NONNULL_END
