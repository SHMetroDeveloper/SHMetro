//
//  DBReportImage+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBReportImage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBReportImage (CoreDataProperties)

+ (NSFetchRequest<DBReportImage *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *path;
@property (nullable, nonatomic, copy) NSNumber *reportId;
@property (nullable, nonatomic, copy) NSNumber *reportImageId;

@end

NS_ASSUME_NONNULL_END
