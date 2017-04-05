//
//  WorkOrderOperateEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"


typedef NS_ENUM(NSInteger, WorkOrderOperateType) {
    WORK_ORDER_OPERATE_TYPE_UNKNOW,    //未知类型
    WORK_ORDER_OPERATE_TYPE_BACK = 1,  //退单
    WORK_ORDER_OPERATE_TYPE_STOP_Y = 2,//暂停 继续工作
    WORK_ORDER_OPERATE_TYPE_STOP_N = 3,//暂停 不继续工作
    WORK_ORDER_OPERATE_TYPE_TERMINATE = 4, //终止
    WORK_ORDER_OPERATE_TYPE_FINISH = 5, //处理完成
    WORK_ORDER_OPERATE_TYPE_VALIDATE_PASS = 6, //验证
    WORK_ORDER_OPERATE_TYPE_VALIDATE_OUT = 7,  //验证不通过
    WORK_ORDER_OPERATE_TYPE_CLOSE = 8, //存档
    WORK_ORDER_OPERATE_TYPE_ACCEPT = 9, //接单
    WORK_ORDER_OPERATE_TYPE_CONTINUE = 10,  //继续工作
};


/**
 *  工单操作类型(接单，暂停，退单，处理完成，终止，验证，存档)
 */

@interface WorkOrderOperateRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * woId;   //工单ID
@property (readwrite, nonatomic, assign) NSInteger operateType;   //操作类型
@property (readwrite, nonatomic, strong) NSString * operateDescription;  //操作说明
- (instancetype) init;
- (NSString *)getUrl;
@end






