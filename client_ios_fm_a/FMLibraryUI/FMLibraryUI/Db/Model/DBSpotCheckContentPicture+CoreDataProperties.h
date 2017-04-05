//
//  DBSpotCheckContentPicture+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSpotCheckContentPicture+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBSpotCheckContentPicture (CoreDataProperties)

+ (NSFetchRequest<DBSpotCheckContentPicture *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *contentId;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSNumber *imageId;
@property (nullable, nonatomic, copy) NSNumber *projectId;
@property (nullable, nonatomic, copy) NSNumber *spotCheckContentId;
@property (nullable, nonatomic, copy) NSNumber *uploaded;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSNumber *userId;

@end

NS_ASSUME_NONNULL_END
