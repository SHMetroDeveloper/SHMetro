//
//  DBGroup+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBGroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBGroup (CoreDataProperties)

+ (NSFetchRequest<DBGroup *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *emId;
@property (nullable, nonatomic, copy) NSNumber *groupId;
@property (nullable, nonatomic, copy) NSString *groupName;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *recordId;

@end

NS_ASSUME_NONNULL_END
