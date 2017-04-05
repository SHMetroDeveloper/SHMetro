//
//  ReservationTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/14/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, InventoryReservationEventType) {
    INVENTORY_RESERVATION_EVENT_UNKNOW,
    INVENTORY_RESERVATION_EVENT_SELECT_WAREHOUSE,       //选择仓库
    INVENTORY_RESERVATION_EVENT_SELECT_ADMINISTRATOR,   //选择仓库管理员
    INVENTORY_RESERVATION_EVENT_SELECT_SUPERVISOR,       //选审批主管
//    INVENTORY_RESERVATION_EVENT_SELECT_DATE,
    INVENTORY_RESERVATION_EVENT_EDIT_MATERIAL,
    INVENTORY_RESERVATION_EVENT_DELETE_MATERIAL,
};

@interface ReservationTableHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;

- (void) setDataWithArray:(NSMutableArray *) materials;

- (void) addMaterialsWithArray:(NSMutableArray *) materials;

- (void) setWarehouseName:(NSString *) warehouseName;

//设置预定人
- (void) setApplicant:(NSString *) applicant;

//设置仓库管理员
- (void) setAdministrator:(NSString *) administrator;

//设置主管
- (void) setSupervisor:(NSString *) supervisor;

- (void) setDate:(NSString *) date;

- (NSString *) getDesc;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end

