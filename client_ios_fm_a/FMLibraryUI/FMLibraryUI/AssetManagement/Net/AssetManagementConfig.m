//
//  AssetManagementConfig.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetManagementConfig.h"
#import "SystemConfig.h"
#import "FMColor.h"
#import "BaseBundle.h"

NSString * const  ASSET_INFORMATION_URL = @"/m/v2/equipments/query";
NSString * const ASSET_EQUIPMENT_DETAIL_URL = @"/m/v1/equipments/info";
NSString * const ASSET_QRCODE_DETAIL_URL = @"/m/v1/equipments/qrcodeinfo";
NSString * const ASSET_WORK_ORDER_QUERY_URL = @"/m/v1/workorder/query";
//NSString * const ASSET_BASE_INFO_URL = @"/m/v1/equipments/summary";    //概况
NSString * const ASSET_BASE_INFO_URL = @"/m/v2/equipments/summary";    //概况summary

NSString * const ASSET_CORE_COMPONENT_LIST_URL = @"/m/v1/equipments/component/list";    //核心组件列表
NSString * const ASSET_CORE_COMPONENT_DETAIL_URL = @"/m/v1/equipments/component/detail";    //核心组件详情
NSString * const ASSET_CORE_COMPONENT_PATROL_RECORD_URL = @"/m/v2/patrol/equipment/history";    //获取设备的历史巡检记录

NSString * const ASSET_UNDO_WORK_ORDER_LIST_URL = @"/m/v1/workorder/equipment/undo";    //获取设备待处理工单列表

@implementation AssetManagementConfig


//获取设备状态描述
+ (NSString *) getEquipmentStatusStrByStatus:(EquipmentStatus) status {
    NSString * res;
    switch (status) {
        case EQUIP_STATUS_IDLE:
            res = [[BaseBundle getInstance] getStringByKey:@"asset_status_idle" inTable:nil];
            break;
        case EQUIP_STATUS_STOP:
            res = [[BaseBundle getInstance] getStringByKey:@"asset_status_stop" inTable:nil];
            break;
        case EQUIP_STATUS_USING:
            res = [[BaseBundle getInstance] getStringByKey:@"asset_status_using" inTable:nil];
            break;
        case EQUIP_STATUS_SCRAPING:  //待报废
            res = [[BaseBundle getInstance] getStringByKey:@"asset_status_scraping" inTable:nil];
            break;
        case EQUIP_STATUS_SCRAP:  //报废
            res = [[BaseBundle getInstance] getStringByKey:@"asset_status_discard" inTable:nil];
            break;
        case EQUIP_STATUS_REPAIRING:
            res = [[BaseBundle getInstance] getStringByKey:@"asset_status_repairing" inTable:nil];
            break;
        case EQUIP_STATUS_LOCKED:
            res = [[BaseBundle getInstance] getStringByKey:@"asset_status_lock" inTable:nil];
            break;
        
    }
    return res;
}

+ (UIColor *) getEquipmentStatusColorByStatus:(EquipmentStatus)status {
    UIColor * res;
    switch (status) {
        case EQUIP_STATUS_IDLE:
            res = [FMColor getInstance].mainGreen;
            break;
        case EQUIP_STATUS_STOP:
            res = [FMColor getInstance].grayLevel6;
            break;
        case EQUIP_STATUS_USING:
            res = [FMColor getInstance].mainBlue;
            break;
        case EQUIP_STATUS_SCRAPING:  //待报废
            res = [FMColor getInstance].mainRed;
            break;
        case EQUIP_STATUS_SCRAP:  //报废
            res = [FMColor getInstance].mainRed;
            break;
        case EQUIP_STATUS_REPAIRING:
            res = [FMColor getInstance].mainOrange;
            break;
        case EQUIP_STATUS_LOCKED:
            res = [FMColor getInstance].mainOrange;
            break;
    }
    return res;
}

@end





