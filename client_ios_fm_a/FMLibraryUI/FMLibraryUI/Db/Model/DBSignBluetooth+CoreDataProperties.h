//
//  DBSignBluetooth+CoreDataProperties.h
//  
//
//  Created by flynn.yang on 2017/3/2.
//
//

#import "DBSignBluetooth+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DBSignBluetooth (CoreDataProperties)

+ (NSFetchRequest<DBSignBluetooth *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *bluetoothId;
@property (nullable, nonatomic, copy) NSNumber *enable;
@property (nullable, nonatomic, copy) NSString *mac;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *projectId;

@end

NS_ASSUME_NONNULL_END
