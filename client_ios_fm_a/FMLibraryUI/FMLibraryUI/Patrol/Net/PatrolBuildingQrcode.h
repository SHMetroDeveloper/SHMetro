//
//  PatrolQrcode.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/14.
//  Copyright © 2017年 facility. All rights reserved.
//
//  站点二维码
//  PATROL|BUILDING|{buildingId}|{fullname}|F-ONE


#import "PatrolQrcode.h"

extern NSString * const FM_QRCODE_FUNCTION_PATROL_SUB_BUILDING;

@interface PatrolBuildingQrcode : PatrolQrcode

/**
 判断是否为站点二维码

 @return 判断结果
 */
- (BOOL) isValidQrcode;


/**
 获取车站ID

 @return 车站ID
 */
- (NSNumber *) getBuildingId;


/**
 获取车站描述

 @return 车站描述
 */
- (NSString *) getFullName;
@end
