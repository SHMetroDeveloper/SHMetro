//
//  DBBuilding+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/17.
//
//

#import "DBBuilding+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBBuilding (CoreDataProperties)

+ (NSFetchRequest<DBBuilding *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *buildingId;
@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *siteId;
@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, copy) NSNumber *relatedBuildingId;
@property (nullable, nonatomic, copy) NSNumber *isThisStation;

@end

NS_ASSUME_NONNULL_END
