//
//  DBStype+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBStype+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBStype (CoreDataProperties)

+ (NSFetchRequest<DBStype *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *parentId;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *stypeId;

@end

NS_ASSUME_NONNULL_END
