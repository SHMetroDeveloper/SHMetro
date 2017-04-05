//
//  AssetManagementBusiness.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseBusiness.h"
#import "AssetManagementEntity.h"
#import "AssetEquipmentDetailEntity.h"
#import "AssetWorkOrderRecordEntity.h"
#import "AssetBaseInfoEntity.h"
#import "ContractEntity.h"
#import "AssetCoreComponentDetailEntity.h"
#import "AssetCoreComponentListEntity.h"
#import "AssetPatrolRecordEntity.h"
#import "AssetUndoWorkOrderEntity.h"



typedef NS_ENUM(NSInteger, AssetManagementBussinessType){
    BUSINESS_ASSET_UNKNOW,  //
    BUSINESS_ASSET_EQUIPMENT_LIST, //获取、查询设备列表
    BUSINESS_ASSET_EQUIPMENT_PATROL_RECORD, //获取设备巡检记录
    BUSINESS_ASSET_EQUIPMENT_DETAIL,  //获取设备详情
    BUSINESS_ASSET_EQUIPMENT_ORDER_RECORD,  //设备工单记录
    BUSINESS_ASSET_CONTRACT,    //合同
    BUSINESS_ASSET_BASE_INFO,  //资产概况
    BUSINESS_ASSET_CORE_COMPONENT_DETAIL,  //核心组件详情
    BUSINESS_ASSET_CORE_COMPONENT_LIST,  //核心组件列表
    BUSINESS_ASSET_UNDO_WORKORDER_LIST,  //待处理工单列表
};


@interface AssetManagementBusiness : BaseBusiness

//获取工单业务的实例对象
+ (instancetype) getInstance;

//查询资产概况
- (void) getBaseInfoOfAsset:(RequestAssetBaseInfoParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//获取设备详情
- (void) getEquipmentDetail:(AssetEquipmentDetailRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//根据二维码扫描结果获取设备详情
- (void) getEquipmentDetailByQrCode:(AssetEquipmentDetailQrcodeRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//查询设备绑定的合同
- (void) getEquipmentContract:(ContractQueryParam *)param Success:(business_success_block) success fail:(business_failure_block) fail;

//查询工单列表
- (void) getAssetOrderRecord:(AssetWorkOrderQueryRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//获取设备列表或者筛选设备
- (void) getEquipmentsListDataByParam:(AssetManagementEquipmentsRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//获取设备巡检记录
- (void) getEquipmentPatrolRecordByParam:(AssetPatrolRecordRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//获取核心组件详情
- (void) getCoreComponentDetailByParam:(AssetCoreComponentDetailRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//获取核心组件列表
- (void) getCoreComponentListByParam:(AssetCoreComponentListParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//获取待处理工单列表
- (void) getUndoWorkOrderListByParam:(AssetUndoWorkOrderRequestParam *)param Success:(business_success_block) success fail:(business_failure_block) fail;

@end


