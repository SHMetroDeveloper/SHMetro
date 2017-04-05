//
//  DBBaseDownloadRecord+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBBaseDownloadRecord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBBaseDownloadRecord (CoreDataProperties)

+ (NSFetchRequest<DBBaseDownloadRecord *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *dataType;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSNumber *preRequestDate;
@property (nullable, nonatomic, copy) NSNumber *projectId;

@end

NS_ASSUME_NONNULL_END
