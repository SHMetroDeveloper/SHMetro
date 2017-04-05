//
//  ReservationDetailTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/18/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "ReservationDetailEntity.h"

//
typedef NS_ENUM(NSInteger, InventoryReservationDetailType) {
    INVENTORY_RESERVATION_DETAIL_TYPE_RESERVE,      //预定
    INVENTORY_RESERVATION_DETAIL_TYPE_DELIVERY,     //   出库
};

typedef NS_ENUM(NSInteger, InventoryReservationDetailEventType) {
    INVENTORY_RESERVATION_DETAIL_EVENT_UNKNOW,
    INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_MATERIAL,   //查看物料详情，编辑领用数量
    INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_ORDER,
    INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_RESERVEPERSON,  //编辑预订人
    INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_ADMINISTRATOR,  //编辑仓库管理员
    INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_SUPERVISOR,  //编辑主管
    INVENTORY_RESERVATION_DETAIL_EVENT_SELECT_RECEIVING_PERSON,  //编辑领用人
};

@interface ReservationDetailTableHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;

//设置类型
- (void) setReservationType:(InventoryReservationDetailType) type;

//设置预订人
- (void) setInfoWithReservePerson:(NSString *)reservePerson;
//设置仓库管理员
- (void) setInfoWithAdministrator:(NSString *)administrator;
//设置主管
- (void) setInfoWithSupervisor:(NSString *)supervisor;
//设置领用人
- (void) setInfoWithReceivingPerson:(NSString *)person;

- (void) setInfoWith:(ReservationDetailEntity *) entity;

- (void) setAmount:(NSNumber *) amount forMaterialAtPosition:(NSInteger) position;

- (void) setRealCost:(NSString *)cost;

- (NSNumber *) getOrderIdByPosition:(NSInteger) position;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
