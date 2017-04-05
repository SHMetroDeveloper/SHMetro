//
//  PatrolSpotQrcode.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/14.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "PatrolQrcode.h"

extern NSString * const FM_QRCODE_PATROL_FUNCTION_SUB_SPOT;

@interface PatrolSpotQrcode : PatrolQrcode


/**
 判断是否为点位二维码

 @return 判断结果
 */
- (BOOL) isValidQrcode;


/**
 获取点位 ID

 @return 点位 ID
 */
- (NSNumber *)getSpotId;


/**
 获取点位名称

 @return 点位名称
 */
- (NSString *)getSpotName;


/**
 获取站点 ID

 @return 站点 ID
 */
- (NSNumber *)getBuildingId;


/**
 获取站点名称

 @return 站点名称
 */
- (NSString *)getBuildingName;

@end
