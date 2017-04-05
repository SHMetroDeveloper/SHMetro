//
//  DBCity+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBCity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBCity (CoreDataProperties)

+ (NSFetchRequest<DBCity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *cityId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *timeZone;
@property (nullable, nonatomic, copy) NSNumber *projectId;

@end

NS_ASSUME_NONNULL_END
