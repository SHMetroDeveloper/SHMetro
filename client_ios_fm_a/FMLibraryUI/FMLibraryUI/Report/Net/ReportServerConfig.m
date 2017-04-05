//
//  ReportServerConfig.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ReportServerConfig.h"
#import "SystemConfig.h"
#import "BaseBundle.h"

// 报障上传
//NSString * const REPORT_UPLOAD_URL = @"/m/v1/servicecenter/submit";
NSString * const REPORT_UPLOAD_URL = @"/m/v2/servicecenter/submit";
//

@implementation ReportServerConfig

//获取报障工单的类型
+ (NSString *) getReportOrderTypeString:(NSInteger) orderType {
    NSString * typeStr;
    switch(orderType) {
        case REPORT_ORDER_TYPE_MAINTENANCE:
            typeStr = [[BaseBundle getInstance] getStringByKey:@"report_order_type_maintenance" inTable:nil];
            break;
        case REPORT_ORDER_TYPE_SELF_CHECK:
            typeStr = [[BaseBundle getInstance] getStringByKey:@"report_order_type_self_check" inTable:nil];
            break;
        case REPORT_ORDER_TYPE_MIX:
            typeStr = [[BaseBundle getInstance] getStringByKey:@"report_order_type_mix" inTable:nil];
            break;
    }
    return typeStr;
}

@end
