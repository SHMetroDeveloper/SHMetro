//
//  SaveWorkOrderEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  工单保存和处理完成

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "WorkOrderDetailEntity.h"

//操作类型
typedef NS_ENUM(NSInteger, SaveWorkOrderOperateType) {
    ORDER_OPERATE_SAVE_TYPE_UNKNOW,
    ORDER_OPERATE_SAVE_TYPE_PAUSE_CONTINUE = 2,//暂停-继续工作
    ORDER_OPERATE_SAVE_TYPE_PAUSE_NOT_CONTINUE,//暂停-不继续工作
    ORDER_OPERATE_SAVE_TYPE_SAVE,           //正常保存
    ORDER_OPERATE_SAVE_TYPE_TERMINATE,      //终止
    ORDER_OPERATE_SAVE_TYPE_FINISH,        //正常完成
    ORDER_OPERATE_SAVE_TYPE_VALIDATE,        //验证
    ORDER_OPERATE_SAVE_TYPE_CLOSE,        //存档
};


@interface SaveWorkOrderEquipment : NSObject
@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSNumber * equipmentId;    //设备ID
@property (readwrite, nonatomic, strong) NSString * equipmentCode;  //设备编码
@property (readwrite, nonatomic, strong) NSString * equipmentName;  //设备名称
@property (readwrite, nonatomic, strong) NSString * location;       //设备安装位置
@property (readwrite, nonatomic, strong) NSString * equipmentSystemName;    //设备所属系统
@property (readwrite, nonatomic, strong) NSString * failureDesc;    //故障描述
@property (readwrite, nonatomic, strong) NSString * repairDesc;     //维修描述
@end

@interface SaveWorkOrderLaborer : NSObject
@property (readwrite, nonatomic, strong) NSNumber * laborerId;
@property (readwrite, nonatomic, strong) NSNumber * actualArriveDate;
@property (readwrite, nonatomic, strong) NSNumber * actualFinishDate;
@end

@interface SaveWorkOrderTool : NSObject
@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSNumber * toolId;
@property (readwrite, nonatomic, strong) NSString * name;   //工具名称
@property (readwrite, nonatomic, strong) NSString * model;  //型号规格
@property (readwrite, nonatomic, strong) NSString * unit;   //单位
@property (readwrite, nonatomic, assign) NSInteger amount;  //数量
@property (readwrite, nonatomic, strong) NSNumber * cost;   //费用
@property (readwrite, nonatomic, strong) NSString * comment;//描述
@end

@interface SaveWorkOrderCharge : NSObject
@property (readwrite, nonatomic, strong) NSNumber * chargeId;
@property (readwrite, nonatomic, strong) NSString * item;
@property (readwrite, nonatomic, strong) NSNumber * amount;
@end

@interface SaveWorkOrderRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, assign) NSInteger operateType;
@property (readwrite, nonatomic, strong) NSString * operateDescription;
@property (readwrite, nonatomic, strong) NSString * woContent;

@property (readwrite, nonatomic, strong) NSMutableArray * pictures;
@property (readwrite, nonatomic, strong) NSMutableArray * equipments;
@property (readwrite, nonatomic, strong) NSMutableArray * laborers;
@property (readwrite, nonatomic, strong) NSMutableArray * tools;
@property (readwrite, nonatomic, strong) NSMutableArray * charge;
@property (readwrite, nonatomic, assign) BOOL validatePass; //验证是否通过

- (instancetype) init;
- (NSString*) getUrl;

@end
