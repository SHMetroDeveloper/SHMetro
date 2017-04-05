//
//  NetConfigure.m
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "NetConfigure.h"

NSString * const HEAD_DEVICE_TYPE = @"Device-Type";
NSString * const HEAD_DEVICE_TYPE_VALUE = @"ios";
NSString * const HEAD_DEVICE_ID = @"Device-Id";
NSString * const DEVICE_ID = @"11111111";


@interface NetConfigure ()



@end

@implementation NetConfigure

+ (NSString *) getDeviceId {
    return DEVICE_ID;
}

@end