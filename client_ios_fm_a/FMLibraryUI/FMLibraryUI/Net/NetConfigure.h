//
//  NetConfigure.h
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetConfigure : NSObject

+ (NSString *) getDeviceId;

@end

extern NSString * const HEAD_DEVICE_TYPE;
extern NSString * const HEAD_DEVICE_TYPE_VALUE;
extern NSString * const HEAD_DEVICE_ID;