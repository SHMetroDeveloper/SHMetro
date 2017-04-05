//
//  DBSatisfactionType+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSatisfactionType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBSatisfactionType (CoreDataProperties)

+ (NSFetchRequest<DBSatisfactionType *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *degree;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *recordId;
@property (nullable, nonatomic, copy) NSNumber *sdId;
@property (nullable, nonatomic, copy) NSNumber *sdValue;

@end

NS_ASSUME_NONNULL_END
