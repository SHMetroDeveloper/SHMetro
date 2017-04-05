//
//  BulletinFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/17/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "BulletinFunctionPermission.h"
#import "PowerManager.h"
#import "ContractQueryViewController.h"
#import "ContractStatisticsViewController.h"
#import "ContractManagementViewController.h"

const NSString * BULLETIN_FUNCTION = @"bulletin";


BulletinFunctionPermission * bulletinPermissionInstance;

@implementation BulletinFunctionPermission

+ (instancetype) getInstance {
    if(!bulletinPermissionInstance) {
        bulletinPermissionInstance = [[BulletinFunctionPermission alloc] init];
        
        [BulletinFunctionPermission initFunctionPermission];
    }
    return bulletinPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:BULLETIN_FUNCTION];
    if(self) {
    }
    return self;
}

//初始化本模块的权限配置
+ (void) initFunctionPermission {
    
    //模块权限
    [bulletinPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_NONE];
}

@end
