//
//  DBOrg+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBOrg+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBOrg (CoreDataProperties)

+ (NSFetchRequest<DBOrg *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, copy) NSNumber *level;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *orgId;
@property (nullable, nonatomic, copy) NSNumber *parentId;
@property (nullable, nonatomic, copy) NSNumber *projectId;

@end

NS_ASSUME_NONNULL_END
