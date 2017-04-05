//
//  OrderEquipmentEditTableHelper.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/3.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "AssetManagementConfig.h"
#import "WorkOrderServerConfig.h"

typedef NS_ENUM(NSInteger, OrderEquipmentEditEventType) {
    WO_EQUIPMENT_EDIT_EVENT_UNKNOW,
    WO_EQUIPMENT_EDIT_EVENT_SELECT_EQUIPMENT,       //选择设备
    WO_EQUIPMENT_EDIT_EVENT_SELECT_STATUS,          //选择状态
    WO_EQUIPMENT_EDIT_EVENT_SELECT_REPAIR_TYPE,     //选择维修类型
    WO_EQUIPMENT_EDIT_EVENT_SHOW_COMPONENT_DETAIL,  //查看组件详情
    WO_EQUIPMENT_EDIT_EVENT_SHOW_COMPONENT_REPAIR,  //组件修复
};

@interface OrderEquipmentEditTableHelper : NSObject <UITableViewDataSource, UITableViewDelegate>
- (instancetype) init;
//设置名称
- (void) setInfoWithName:(NSString *) name;
//设置编码
- (void) setInfoWithCode:(NSString *) code;
//设置状态
- (void) setInfoWithStatus:(EquipmentStatus) status;
//设置维修类型
- (void) setInfoWithRepairType:(OrderEquipmentRepairType) repairType;

//设置故障描述
- (void) setInfoWithFailureDesc:(NSString *) failureDesc;

//获取故障描述
- (NSString *) getFailureDesc;

//获取维修描述
- (NSString *) getRepairDesc;

//设置维修说明
- (void) setInfoWithRepairDesc:(NSString *) repairDesc;

//设置核心组件
- (void) setInfoWithComponents:(NSMutableArray *) array;

- (void) setNeedShowNameAndCode:(BOOL) needShowNameAndCode;


- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
