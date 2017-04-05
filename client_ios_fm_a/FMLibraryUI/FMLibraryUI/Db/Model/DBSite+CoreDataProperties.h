//
//  DBSite+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSite+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBSite (CoreDataProperties)

+ (NSFetchRequest<DBSite *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *cityId;
@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *siteId;

@end

NS_ASSUME_NONNULL_END
