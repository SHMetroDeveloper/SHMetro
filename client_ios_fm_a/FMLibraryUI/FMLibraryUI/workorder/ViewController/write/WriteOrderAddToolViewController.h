//
//  WriteOrderAddToolViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "WorkOrderDetailEntity.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, WriteOrderAddToolOperateType) {
    ORDER_TOOL_OPERATE_TYPE_UNKNOW,    //未知
    ORDER_TOOL_OPERATE_TYPE_ADD,       //新增
    ORDER_TOOL_OPERATE_TYPE_EDIT       //编辑
};

@interface WriteOrderAddToolViewController : BaseViewController <UITextFieldDelegate>

- (instancetype) initWithOperateType:(WriteOrderAddToolOperateType) operateType;
- (void) setInfoWith:(WorkOrderTool *) tool;
- (void) setWorkOrderId:(NSNumber *)woId;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
