//
//  InventoryQrcode.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/19.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "InventoryQrcode.h"

NSString * const FM_QRCODE_FUNCTION_INVENTORY_INVENTORY = @"STOCK";
@implementation InventoryQrcode

- (BOOL) isValidQrcode {
    BOOL res = [super isValidQrcode];
    if(res) {
        res = [[self getFunction] isEqualToString:FM_QRCODE_FUNCTION_INVENTORY_INVENTORY];
    }
    return res;
}

@end
