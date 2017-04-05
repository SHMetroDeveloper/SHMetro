//
//  QuickReportBusiness.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/13.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseBusiness.h"
#import "QuickReportNetRequest.h"
#import "QuickReportCreateEntity.h"

typedef NS_ENUM(NSInteger, QuickReportBusinessType) {
    BUSINESS_QUICK_REPORT_CREATE,  //快速报障创建
    
};

@interface QuickReportBusiness : BaseBusiness

//获取工单业务的实例对象
+ (instancetype) getInstance;

//上传快速报障信息
- (void)uploadQuickReportInfo:(QuickReportCreateRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail;

@end
