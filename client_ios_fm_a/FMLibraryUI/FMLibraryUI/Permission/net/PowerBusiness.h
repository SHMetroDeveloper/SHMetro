//
//  PowerBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseBusiness.h"


typedef NS_ENUM(NSInteger, PowerBusinessType) {
    BUSINESS_POWER_UNKNOW,   //
    BUSINESS_POWER_GET_PERMISSION,       //获取模块权限列表
};

@interface PowerBusiness : BaseBusiness

//获取业务的实例对象
+ (instancetype) getInstance;

//获取模块权限列表
- (void) requestPermissionListSuccess:(business_success_block) success fail:(business_failure_block) fail;

@end
