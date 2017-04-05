//
//  ScannerFunctionPermission.h
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "FunctionPermission.h"

////扫一扫模块主键
extern const NSString *SCANNER_FUNCTION;

@interface ScannerFunctionPermission : FunctionPermission

+ (instancetype)getInstance;


/**
 初始化本模块的权限配置
 */
+ (void)initFunctionPermission;

@end
