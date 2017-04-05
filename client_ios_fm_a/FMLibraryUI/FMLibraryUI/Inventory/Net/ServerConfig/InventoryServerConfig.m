//
//  InventoryServerConfig.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "InventoryServerConfig.h"
#import "FMTheme.h"
#import "BaseBundle.h"

NSString * const INVENTORY_MATERIAL_DETAIL_URL = @"/m/v1/stock/inventory/detail";  //物资详情
NSString * const INVENTORY_MATERIAL_DETAIL_CODE_URL = @"/m/v1/stock/inventory/qrcodeinfo";  //通过编码获取物资详情
NSString * const INVENTORY_MATERIAL_DETAIL_RECORD_URL = @"/m/v1/stock/inventory/record";  //物资记录
NSString * const INVENTORY_MATERIAL_PROVIDER_URL = @"/m/v1/stock/provider";  //获取供应商列表
NSString * const INVENTORY_MATERIAL_STORAGE_IN_URL = @"/m/v1/stock/storage";  //入库
NSString * const INVENTORY_MATERIAL_CHECK_URL = @"/m/v1/stock/check";  //盘点
NSString * const INVENTORY_MATERIAL_QUERY_URL = @"/m/v1/stock/material/query";   //仓库物资查询
NSString * const INVENTORY_WAREHOUSE_QUERY_URL = @"/m/v1/stock/warehouse/query";   //仓库列表查询


NSString * const GET_RESERVATION_LIST_URL = @"/m/v1/stock/reservations/list";   //获取预定列表，包括待审核，历史审核，我的预定
NSString * const GET_RESERVATION_LIST_OF_WORK_ORDER_URL = @"/m/v1/workorder/materialReservation";   //获取工单预订单
NSString * const GET_RESERVATION_DETAIL_URL = @"/m/v1/stock/reservations/detail"; //获取预定详情
NSString * const RESERVATION_DELIVERY_URL = @"/m/v1/stock/reservations/operation";   //出库
NSString * const RESERVATION_CANCEL_URL = @"/m/v1/stock/reservations/operation";     //取消出库
NSString * const RESERVE_INVENTORY_URL = @"/m/v2/stock/reservations/reserve";      //物料预定

NSString * const GET_WAREHOUSE_LIST_URL = @"/m/v1/stock/warehouses";      //仓库列表
NSString * const GET_MATERIAL_LIST_URL = @"/m/v2/stock/inventorys";      //物料列表

NSString * const RESERVATION_APPROVAL_URL = @"/m/v1/stock/reservation/approval";    //预定审批地址
NSString * const INVENTORY_DELIVERY_URL = @"/m/v1/stock/delivery";    //出库（直接出库，预定出库，移库）
NSString * const INVENTORY_MATERIAL_BATCH_URL = @"/m/v2/stock/batch/list";    //物料批次

NSString * const INVENTORY_RESERVATION_HANDLER_EDIT = @"/m/v1/stock/reservation/person";    //修改预定单操作人（管理员，主管等）


@implementation InventoryServerConfig
//获取预订单状态描述
+ (NSString *) getReservationStatusDescription:(ReservationStatusType) status {
    NSString * res = @"";
    switch(status) {
        case RESERVATION_STATUS_TYPE_UNCHECK:
            res =  [[BaseBundle getInstance] getStringByKey:@"inventory_approval_status_approvaling" inTable:nil];;
            break;
        case RESERVATION_STATUS_TYPE_ACCEPTED:
            res =  [[BaseBundle getInstance] getStringByKey:@"inventory_approval_status_success" inTable:nil];;
            break;
        case RESERVATION_STATUS_TYPE_REFUSE:
            res =  [[BaseBundle getInstance] getStringByKey:@"inventory_approval_status_fail" inTable:nil];;
            break;
        case RESERVATION_STATUS_TYPE_FINISH:
            res =  [[BaseBundle getInstance] getStringByKey:@"inventory_approval_status_finished" inTable:nil];;
            break;
        case RESERVATION_STATUS_TYPE_CANCEL_DELIVERY:
            res =  [[BaseBundle getInstance] getStringByKey:@"inventory_reservation_status_cancel" inTable:nil];;
            break;
        case RESERVATION_STATUS_TYPE_CANCEL_RESERVATION:
            res =  [[BaseBundle getInstance] getStringByKey:@"inventory_reservation_status_cancel_reservation" inTable:nil];;
            break;
    }
    return res;
}

//获取预订单状态颜色
+ (UIColor *) getReservationStatusColor:(ReservationStatusType) status {
    UIColor * color;
    switch(status) {
        case RESERVATION_STATUS_TYPE_UNCHECK:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
        case RESERVATION_STATUS_TYPE_ACCEPTED:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
            break;
        case RESERVATION_STATUS_TYPE_REFUSE:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
            break;
        case RESERVATION_STATUS_TYPE_FINISH:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
            break;
        case RESERVATION_STATUS_TYPE_CANCEL_DELIVERY:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
            break;
        case RESERVATION_STATUS_TYPE_CANCEL_RESERVATION:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
            break;
            
    }
    return color;
}
@end
