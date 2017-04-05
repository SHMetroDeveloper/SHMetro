//
//  DBFailureReason+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBFailureReason+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBFailureReason (CoreDataProperties)

+ (NSFetchRequest<DBFailureReason *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *reasonId;
@property (nullable, nonatomic, copy) NSString *reasonCode;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *parentId;

@end

NS_ASSUME_NONNULL_END
