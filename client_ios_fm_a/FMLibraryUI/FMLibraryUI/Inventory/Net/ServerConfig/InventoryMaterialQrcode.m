//
//  InventoryMaterialQrcode.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/7/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryMaterialQrcode.h"

NSString * const FM_QRCODE_FUNCTION_INVENTORY_SUB_MATERIAL = @"MATERIAL";

@interface InventoryMaterialQrcode ()

@property (readwrite, nonatomic, strong) NSString * warehouseId;    //仓库ID
@property (readwrite, nonatomic, strong) NSString * materialCode;   //物料编码

@end

@implementation InventoryMaterialQrcode

- (void) analysisExtendInfo {
    NSArray * array = [self getExtandArray];
    if([array count] >= 2) {
        _warehouseId = array[0];
        _materialCode = array[1];
    }
    
}

- (BOOL) isValidQrcode {
    BOOL res = [super isValidQrcode];
    if(res) {
        NSArray * array = [self getExtandArray];
        res = [[self getSubFunction] isEqualToString:FM_QRCODE_FUNCTION_INVENTORY_SUB_MATERIAL] && [array count] >= 2;
    }
    return res;
}

//获取仓库ID字符串
- (NSString *) getWarehouseId {
    return _warehouseId;
}

//获取物料编码
- (NSString *) getMaterialCode {
    return _materialCode;
}

@end
