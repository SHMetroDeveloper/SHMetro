//
//  DBReportDevice+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBReportDevice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBReportDevice (CoreDataProperties)

+ (NSFetchRequest<DBReportDevice *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *deviceId;
@property (nullable, nonatomic, copy) NSNumber *reportDeviceId;
@property (nullable, nonatomic, copy) NSNumber *reportId;

@end

NS_ASSUME_NONNULL_END
