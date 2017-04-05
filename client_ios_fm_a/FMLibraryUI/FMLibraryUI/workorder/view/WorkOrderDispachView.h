//
//  WorkOrderDispachView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/22.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "OnClickListener.h"
#import "BaseListHeaderView.h"
#import "OnListItemButtonClickListener.h"
#import "BaseViewController.h"
#import "WorkOrderLaborerDispachEntity.h"

typedef NS_ENUM(NSInteger, DispachOrderOperationSectionType) {
    DISPACH_ORDER_SECTION_TYPE_UNKNOW,            //未知
    DISPACH_ORDER_SECTION_TYPE_LABORER = 100,           //执行人
    DISPACH_ORDER_SECTION_TYPE_LABORERTIME = 200        //预估完成时间
};

typedef NS_ENUM(NSInteger, DispachOrderOperationType) {
    DISPACH_ORDER_OPERATION_TYPE_UNKNOW,            //未知
    DISPACH_ORDER_OPERATION_TYPE_LABORER_SELECT = 100,     //选择执行人
    DISPACH_ORDER_OPERATION_TYPE_LABORER_DELETE,           //删除执行人
    DISPACH_ORDER_OPERATION_TYPE_LABORER_LEADER_CHANGE,         //负责人改变
    DISPACH_ORDER_OPERATION_TYPE_LABORERTIME_START_SELECT = 200,//选择预估开始时间
    DISPACH_ORDER_OPERATION_TYPE_LABORERTIME_END_SELECT        //选择预估完成时间
};

@interface WorkOrderDispachView : UIView<UITableViewDataSource, UITableViewDelegate,  OnClickListener, OnListSectionHeaderClickListener, OnListItemButtonClickListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) addLaborer:(WorkOrderLaborerDispach *) laborer;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
