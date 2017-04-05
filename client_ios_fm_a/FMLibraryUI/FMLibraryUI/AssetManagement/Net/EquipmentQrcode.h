//
//  EquipmentQrcode.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/14.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetQrcode.h"

extern NSString * const FM_QRCODE_FUNCTION_ASSET_SUB_EQUIPMENT;

@interface EquipmentQrcode : AssetQrcode

/**
 判断是否为设备二维码

 @return 判断结果
 */
- (BOOL) isValidQrcode;

/**
 获取设备ID

 @return 设备ID
 */
- (NSNumber *) getEquipmentId;

/**
 获取设备名称

 @return 设备名称
 */
- (NSString *) getEquipmentName;
@end
