//
//  AttendanceQrCode.m
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/14.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AttendanceQrCode.h"

NSString * const FM_QRCODE_FUNCTION_COMMON_SUB_EMPLOYEE = @"EM";

@implementation AttendanceQrCode

/**
 初始化信息
 */
- (void)analysisExtendInfo {
    
    NSArray *array = [self getExtandArray];
    if(array.count >= 3) {
        
        _emId = [NSNumber numberWithInteger:[array[0] integerValue]];
        _emType = [NSNumber numberWithInteger:[array[1] integerValue]];
        _name = array[2];
    }
}


/**
 判断是否为有效二维码
 */
- (BOOL)isValidQrcode {
    
    BOOL res = [super isValidQrcode];
    if(res) {
        res = [[self getSubFunction] isEqualToString:FM_QRCODE_FUNCTION_COMMON_SUB_EMPLOYEE] && [self getExtandArray].count >= 3;
    }
    return res;
}

@end
