//
//  CommonQrcode.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/19.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "CommonQrcode.h"

NSString * const FM_QRCODE_FUNCTION_COMMON = @"BASIC";

@implementation CommonQrcode
- (BOOL) isValidQrcode {
    BOOL res = [super isValidQrcode];
    if(res) {
        res = [[self getFunction] isEqualToString:FM_QRCODE_FUNCTION_COMMON];
    }
    return res;
}
@end
