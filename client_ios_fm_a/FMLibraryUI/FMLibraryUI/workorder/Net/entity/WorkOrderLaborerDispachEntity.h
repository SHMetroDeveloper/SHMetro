//
//  WorkOrderLaborerEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

@interface WorkOrderLaborerDispachRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * userId;
@property (readwrite, nonatomic, strong) NSNumber * woId;

- (instancetype) initWithUserId:(NSNumber *) userId andOrderId:(NSNumber *) woId;
- (NSString*) getUrl;

@end


@interface WorkOrderLaborerDispach : NSObject
@property (readwrite, nonatomic, strong) NSNumber * emId;    //执行人ID
@property (readwrite, nonatomic, strong) NSString * name;       //名字
@property (readwrite, nonatomic, strong) NSString * phone;      //联系电话
@property (readwrite, nonatomic, assign) NSInteger woNumber; //该执行人未完成的工单数量
@property (readwrite, nonatomic, assign) NSInteger grabStatus;//抢单状态
@property (readwrite, nonatomic, assign) NSInteger score;//个人积分
@property (readwrite, nonatomic, strong) NSNumber * estimateArriveTime; //预估到达时间
@property (readwrite, nonatomic, strong) NSNumber * status; //员工在岗状态，nil --- 没有参与签到；0 --- 离岗；1 --- 在岗
@end

@interface WorkOrderLaborerGroupDispach : NSObject
@property (readwrite, nonatomic, strong) NSNumber * wtId;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSMutableArray * members;
- (instancetype) init;
@end



@interface WorkOrderLaborerResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
@end
