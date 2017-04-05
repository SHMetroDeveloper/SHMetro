//
//  DBSignPerson+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSignPerson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBSignPerson (CoreDataProperties)

+ (NSFetchRequest<DBSignPerson *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *emId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *org;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *status;
@property (nullable, nonatomic, copy) NSNumber *type;

@end

NS_ASSUME_NONNULL_END
