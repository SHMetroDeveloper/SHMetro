//
//  EquipmentQrcode.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/14.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "EquipmentQrcode.h"
#import "FMUtils.h"

NSString * const FM_QRCODE_FUNCTION_ASSET_SUB_EQUIPMENT = @"EQUIPMENT";

@interface EquipmentQrcode ()
    
@property (readwrite, nonatomic, strong) NSNumber * eqId;    //设备ID
@property (readwrite, nonatomic, strong) NSString * eqName;//设备名称
    
@end

@implementation EquipmentQrcode
    
- (void) analysisExtendInfo {
    NSArray * array = [self getExtandArray];
    if([array count] >= 2) {
        NSString * tmp = array[0];
        _eqId = [FMUtils stringToNumber:tmp];
        _eqName = array[1];
    }
}
    
- (BOOL) isValidQrcode {
    BOOL res = [super isValidQrcode];
    if(res) {
        NSArray * array = [self getExtandArray];
        res = [[self getSubFunction] isEqualToString:FM_QRCODE_FUNCTION_ASSET_SUB_EQUIPMENT] && [array count] >= 2;
    }
    return res;
}
    
    //获取设备ID
- (NSNumber *) getEquipmentId {
    return _eqId;
}
    
    //获取设备名称
- (NSString *) getEquipmentName {
    return _eqName;
}
    
@end
