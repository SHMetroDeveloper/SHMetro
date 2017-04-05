//
//  EquipmentDetailHelper.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"
#import "AssetEquipmentDetailEntity.h"
#import "AssetCoreComponentListEntity.h"



typedef NS_ENUM(NSInteger, AssetManagementDetailShowType) {
    ASSET_MANAGEMENT_DETAIL_UNKNOW,
    ASSET_MANAGEMENT_DETAIL_BASIC_INFO,     //基本信息
    ASSET_MANAGEMENT_DETAIL_MANUFACTURER,  //厂家信息
    ASSET_MANAGEMENT_DETAIL_CONTRACT,     //合同信息
    ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD,  //维保记录
    ASSET_MANAGEMENT_DETAIL_FIXED_RECORD,  //维修记录
    ASSET_MANAGEMENT_DETAIL_PATROL,   //巡检记录
    ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT,  //核心组件
};

typedef NS_ENUM(NSInteger, AssetOrderRecordType) {
    ASSET_ORDER_RECORD_TYPE_FIXED,    //维修记录
    ASSET_ORDER_RECORD_TYPE_MAINTAIN,  //维保记录
    ASSET_CONTRACT_RECORD,  //合同记录
    ASSET_PATROL_RECORD,  //巡检记录
    ASSET_CORE_COMPONENT,  //核心组件列表
};

typedef NS_ENUM(NSInteger, AssetDetailEventType) {
    ASSET_EVENT_ORDER_RECORD_FIXED,     //维修记录
    ASSET_EVENT_ORDER_RECORD_MAINTAIN,  //维保记录
    ASSET_EVENT_CONTRACT,               //合同
    ASSET_EVENT_CORE_COMPONENT,         //核心组件
    ASSET_EVENT_PATROL_HISTORY,         //查看巡检记录
    ASSET_EVENT_PATROL_UNDO,         //查看待处理巡检
    ASSET_EVENT_WORK_ORDER_UNDO,         //查看待处理工单
    ASSET_EVENT_SHOW_PHOTO,             //查看照片
    
    ASSET_EVENT_PATROL_SYC,             //同步巡检数据
    
    ASSET_EVENT_FlEX_BASEINFO,          //收缩基本信息展示页面
    ASSET_EVENT_FlEX_PAREMETER,          //收缩基本信息展示页面
    ASSET_EVENT_FlEX_SERVICEAREA,          //收缩基本信息展示页面
};


@interface EquipmentDetailHelper : NSObject <UITableViewDelegate,UITableViewDataSource,OnMessageHandleListener>

- (instancetype) initWithContext:(BaseViewController *) context;

- (void) setEquipmentDetailInfo:(AssetEquipmentDetailEntity *) entity;

- (void) addDataRecordInfo:(NSMutableArray *) dataArray andPage:(NetPage *)page byType:(AssetOrderRecordType) type;

//设置待处理巡检任务
- (void) setUndoPatrol:(NSMutableArray *)undoPatrolArray;

//设置待处理工单
- (void) setUndoWorkOder:(NSMutableArray *)undoWorkOrder;

- (AssetManagementDetailShowType) getShowType;

- (void) setShowType:(AssetManagementDetailShowType) showType;

//判断是否有数据
- (BOOL) hasData;

//判断是否有厂家信息
- (BOOL) hasFactory;

//为了下拉刷新+加载更多 新增借口
- (void) setPage:(NetPage *)page;

- (NetPage *) getPage;

- (NetPage *) resetPage;

- (BOOL) isFirstPage;

- (BOOL) hasMorePage;

- (void) removeAllOrders;

- (NSInteger) getOrderCount;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
