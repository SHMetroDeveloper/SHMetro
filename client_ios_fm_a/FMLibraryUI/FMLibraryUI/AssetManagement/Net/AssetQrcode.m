//
//  AssetQrcode.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/19.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetQrcode.h"

NSString * const FM_QRCODE_FUNCTION_ASSET = @"ASSET";

@implementation AssetQrcode
- (BOOL) isValidQrcode {
    BOOL res = [super isValidQrcode];
    if(res) {
        res = [[self getFunction] isEqualToString:FM_QRCODE_FUNCTION_ASSET];
    }
    return res;
}
@end
