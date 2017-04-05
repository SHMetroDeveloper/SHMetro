//
//  AttendanceQrCode.h
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/14.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "CommonQrcode.h"

extern NSString * const FM_QRCODE_FUNCTION_COMMON_SUB_EMPLOYEE;

@interface AttendanceQrCode : CommonQrcode

//委外人员ID
@property (nonatomic, strong) NSNumber *emId;

//委外人员Type
@property (nonatomic, strong) NSNumber *emType;

//委外人员名字
@property (nonatomic, strong) NSString *name;


/**
 判断是否为用户二维码

 @return 判断结果
 */
- (BOOL) isValidQrcode;

@end
