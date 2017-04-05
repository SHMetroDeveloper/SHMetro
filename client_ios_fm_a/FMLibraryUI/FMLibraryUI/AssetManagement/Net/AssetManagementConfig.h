//
//  AssetManagementConfig.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AssetManagementConfig.h"


typedef NS_ENUM(NSInteger, EquipmentStatus) {
    EQUIP_STATUS_IDLE,      //闲置
    EQUIP_STATUS_STOP,      //停运
    EQUIP_STATUS_USING,     //使用中
    EQUIP_STATUS_SCRAPING,      //待报废
    EQUIP_STATUS_SCRAP,      //报废
    EQUIP_STATUS_REPAIRING, //维修中
    EQUIP_STATUS_LOCKED,      //封存
};

@interface AssetManagementConfig : NSObject

//获取设备状态
+ (NSString *) getEquipmentStatusStrByStatus:(EquipmentStatus) status;

//获取设备状态的颜色
+ (UIColor *) getEquipmentStatusColorByStatus:(EquipmentStatus) status;


@end


extern NSString * const ASSET_INFORMATION_URL;
extern NSString * const ASSET_EQUIPMENT_DETAIL_URL;
extern NSString * const ASSET_QRCODE_DETAIL_URL;
extern NSString * const ASSET_WORK_ORDER_QUERY_URL;
extern NSString * const ASSET_BASE_INFO_URL;    //概况

extern NSString * const ASSET_CORE_COMPONENT_LIST_URL;    //核心组件列表
extern NSString * const ASSET_CORE_COMPONENT_DETAIL_URL;    //核心组件详情
extern NSString * const ASSET_CORE_COMPONENT_PATROL_RECORD_URL;    //获取设备的历史巡检记录
extern NSString * const ASSET_UNDO_WORK_ORDER_LIST_URL;  //获取设备待处理工单列表

