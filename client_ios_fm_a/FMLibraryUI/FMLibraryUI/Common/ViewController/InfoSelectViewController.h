//
//  InfoSelectViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "NodeList.h"
#import "OnMessageHandleListener.h"

//请求类型
typedef NS_ENUM(NSInteger, InfoSelectRequestType) {
    REQUEST_TYPE_UNKONW_INFO_SELECT,            //选择类型未知
    REQUEST_TYPE_ORG_INFO_SELECT,               //选择部门
    REQUEST_TYPE_SERVICE_TYPE_INFO_SELECT,      //选择服务类型
    REQUEST_TYPE_ORDER_TYPE_INFO_SELECT,        //选择工单类型
    REQUEST_TYPE_LOCATION_INFO_SELECT,          //选择位置
    REQUEST_TYPE_PRIORITY_INFO_SELECT,          //选择优先级
    REQUEST_TYPE_REQUIREMENT_TYPE_INFO_SELECT,  //选择需求类型
//    REQUEST_TYPE_LABORER_INFO_SELECT,           //选择执行人
//    REQUEST_TYPE_APPROVAL_LABORER_INFO_SELECT,  //选择审批人
    REQUEST_TYPE_DEVICE_INFO_SELECT,            //选择设备
    REQUEST_TYPE_WAREHOUSE_INFO_SELECT,         //选择仓库
    REQUEST_TYPE_MATERIAL_INFO_SELECT,          //选择物料
//    REQUEST_TYPE_WORK_GROUP_SELECT,             //选择工作组
    REQUEST_TYPE_COMMON_INFO_SELECT             //自定义数据选择
};

//结果类型
typedef NS_ENUM(NSInteger, InfoSelectResultType) {
    RESULT_TYPE_OK_INFO_SELECT,
    RESULT_TYPE_CANCEL_INFO_SELECT
};

@interface InfoSelectViewController : BaseViewController < UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
//直接请求（不含参数）
- (instancetype) initWithRequestType:(InfoSelectRequestType) requestType;
//请求，(含参数)
- (instancetype) initWithRequestType:(InfoSelectRequestType) requestType andParam:(NSDictionary *) param;
- (instancetype) initWithFrame:(CGRect)frame andRequestType:(InfoSelectRequestType) requestType;

- (void) setSelectDataByArray:(nullable NSMutableArray *) dataArray;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
