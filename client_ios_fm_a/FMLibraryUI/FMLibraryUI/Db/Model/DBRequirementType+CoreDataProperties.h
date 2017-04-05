//
//  DBRequirementType+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBRequirementType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBRequirementType (CoreDataProperties)

+ (NSFetchRequest<DBRequirementType *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *parentTypeId;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *recordId;
@property (nullable, nonatomic, copy) NSNumber *typeId;

@end

NS_ASSUME_NONNULL_END
