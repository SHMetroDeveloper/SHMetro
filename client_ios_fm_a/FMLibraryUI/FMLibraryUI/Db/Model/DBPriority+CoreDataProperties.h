//
//  DBPriority+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBPriority+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBPriority (CoreDataProperties)

+ (NSFetchRequest<DBPriority *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *color;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *priorityId;
@property (nullable, nonatomic, copy) NSNumber *projectId;

@end

NS_ASSUME_NONNULL_END
