//
//  InventoryServerConfig.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

//预定状态
typedef NS_ENUM(NSInteger, ReservationStatusType) {
    RESERVATION_STATUS_TYPE_UNCHECK = 0,    //未审核
    RESERVATION_STATUS_TYPE_ACCEPTED = 1,   //(通过)待出库
    RESERVATION_STATUS_TYPE_REFUSE = 2,     //（取消）已驳回
    RESERVATION_STATUS_TYPE_FINISH = 3,     //已出库
    RESERVATION_STATUS_TYPE_CANCEL_DELIVERY = 4,     //取消出库（仓库管理元取消）
    RESERVATION_STATUS_TYPE_CANCEL_RESERVATION = 5,     //取消预订（预订人取消）
};

@interface InventoryServerConfig : NSObject

//获取预订单状态描述
+ (NSString *) getReservationStatusDescription:(ReservationStatusType) status;

//获取预订单状态颜色
+ (UIColor *) getReservationStatusColor:(ReservationStatusType) status;
@end


extern NSString * const INVENTORY_MATERIAL_DETAIL_URL;  //通过ID查询物资详情
extern NSString * const INVENTORY_MATERIAL_DETAIL_CODE_URL; //通过编码查询物资详情
extern NSString * const INVENTORY_MATERIAL_DETAIL_RECORD_URL;  //物资记录
extern NSString * const INVENTORY_MATERIAL_PROVIDER_URL;  //获取供应商列表
extern NSString * const INVENTORY_MATERIAL_STORAGE_IN_URL;  //入库
extern NSString * const INVENTORY_MATERIAL_CHECK_URL;  //盘点
extern NSString * const INVENTORY_MATERIAL_QUERY_URL;   //仓库物资查询
extern NSString * const INVENTORY_WAREHOUSE_QUERY_URL;   //仓库列表查询

extern NSString * const GET_RESERVATION_LIST_URL;   //获取预定列表，包括待审核，历史审核，我的预定
extern NSString * const GET_RESERVATION_LIST_OF_WORK_ORDER_URL; //获取工单相关预订单列表
extern NSString * const GET_RESERVATION_DETAIL_URL; //获取预定详情
//extern NSString * const RESERVATION_DELIVERY_URL;   //出库
//extern NSString * const RESERVATION_CANCEL_URL;     //取消出库
extern NSString * const RESERVE_INVENTORY_URL;      //物料预定

extern NSString * const GET_WAREHOUSE_LIST_URL;      //获取仓库列表
extern NSString * const GET_MATERIAL_LIST_URL;      //获取物料列表

extern NSString * const RESERVATION_APPROVAL_URL;   //预定审批
extern NSString * const INVENTORY_DELIVERY_URL;   //出库（直接出库，预定出库，移库）
extern NSString * const INVENTORY_MATERIAL_BATCH_URL;   //物料批次
extern NSString * const INVENTORY_RESERVATION_HANDLER_EDIT; //修改预定单操作人（管理员，主管等）
