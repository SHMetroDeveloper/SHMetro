//
//  InventoryMaterialQrcode.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/7/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryQrcode.h"

extern NSString * const FM_QRCODE_FUNCTION_INVENTORY_SUB_MATERIAL;

@interface InventoryMaterialQrcode : InventoryQrcode

/**
 判断是否为物资二维码

 @return 判断结果
 */
- (BOOL) isValidQrcode;

/**
 获取仓库ID字符串

 @return 仓库ID
 */
- (NSString *) getWarehouseId;

/**
 获取物料编码

 @return 物资编码
 */
- (NSString *) getMaterialCode;
@end
