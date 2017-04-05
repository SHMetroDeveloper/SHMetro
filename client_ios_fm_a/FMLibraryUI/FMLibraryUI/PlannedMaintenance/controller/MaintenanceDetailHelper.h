//
//  MaintenanceDetailHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"
#import "MaintenanceDetailEntity.h"

typedef NS_ENUM(NSInteger, MaintenanceDetailShowType) {
    PM_DETAIL_UNKNOW,
    PM_DETAIL_SHOW_BASE,
    PM_DETAIL_SHOW_TARGET,
    PM_DETAIL_SHOW_ORDER,
};

typedef NS_ENUM(NSInteger, MaintenanceDetailEventType) {
    PM_DETAIL_EVENT_UNKNOW,
    PM_DETAIL_EVENT_SHOW_ORDER_DETAIL,  //查看工单详情
    PM_DETAIL_EVENT_SHOW_ATTACHMENT_DETAIL,  //查看附件详情
};

@interface MaintenanceDetailHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;

- (void) setInfoWith:(MaintenanceDetailEntity *) entity;

- (void) setShowType:(MaintenanceDetailShowType)showType;

- (MaintenanceDetailShowType) getShowType;

//判断是否有数据
- (BOOL) hasData;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end