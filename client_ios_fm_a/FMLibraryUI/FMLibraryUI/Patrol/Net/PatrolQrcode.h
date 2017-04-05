//
//  PatrolQrcode.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/19.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "FMQrcode.h"

extern NSString * const FM_QRCODE_FUNCTION_PATROL;

@interface PatrolQrcode : FMQrcode

/**
 判断是否为巡检二维码

 @return 判断结果
 */
- (BOOL) isValidQrcode;
@end
