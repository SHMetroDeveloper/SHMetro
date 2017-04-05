//
//  BulletinFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/17/17.
//  Copyright © 2017 facilityone. All rights reserved.
//


#import "FunctionPermission.h"

extern const NSString * BULLETIN_FUNCTION;        //公告模块主键


@interface BulletinFunctionPermission : FunctionPermission

+ (instancetype) getInstance;


//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end
