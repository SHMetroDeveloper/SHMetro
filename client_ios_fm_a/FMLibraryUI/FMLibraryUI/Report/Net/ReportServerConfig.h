//
//  ReportServerConfig.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ReportOrderType) {
    REPORT_ORDER_TYPE_SELF_CHECK = 0,    //自检
    REPORT_ORDER_TYPE_MAINTENANCE,  //计划性维护
    REPORT_ORDER_TYPE_MIX = 3  //混合类型，自检(优先) + 计划性维护
    
};


@interface ReportServerConfig : NSObject
//获取报障工单的类型
+ (NSString *) getReportOrderTypeString:(NSInteger) orderType;
@end

extern NSString * const REPORT_UPLOAD_URL;
