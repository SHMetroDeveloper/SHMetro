//
//  ScannerFunctionPermission.m
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "ScannerFunctionPermission.h"

const NSString * SCANNER_FUNCTION = @"scanner";

ScannerFunctionPermission *scannerPermissionInstance;

@implementation ScannerFunctionPermission

+ (instancetype)getInstance {
    
    if(!scannerPermissionInstance) {
        
        scannerPermissionInstance = [[ScannerFunctionPermission alloc] init];
        [ScannerFunctionPermission initFunctionPermission];
    }
    return scannerPermissionInstance;
}


- (instancetype) init {
    
    self = [super initWithKey:SCANNER_FUNCTION];
    
    if (self) {
        
    }
    
    return self;
}


/**
 初始化本模块的权限配置
 */
+ (void)initFunctionPermission {
    
    //模块权限
    [scannerPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_ALL];
}

@end
