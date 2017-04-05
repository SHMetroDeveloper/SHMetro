//
//  ContractEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

@interface ContractEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber * contractId;
@property (readwrite, nonatomic, strong) NSString * code;       //合同编码
@property (readwrite, nonatomic, strong) NSString * name;       //名字
@property (readwrite, nonatomic, strong) NSString * type;       //合同类型
@property (readwrite, nonatomic, assign) NSInteger status;      //合同状态 0 --- 未开始 1 --- 执行中 2 --- 已到期 3 --- 已验收（不通过） 4 --- 已验收（通过）5 --- 已终止 6 --- 已存档
@property (readwrite, nonatomic, assign) BOOL payment;
@property (readwrite, nonatomic, strong) NSNumber * startTime;
@property (readwrite, nonatomic, strong) NSNumber * endTime;
@end

// 15.1 合同管理 获取待处理的合同
@interface ContractManagementParam : BaseRequest
@property (readwrite, nonatomic, strong) NetPageParam * page;
- (instancetype) initWithPage:(NetPageParam *) page;
-(NSString *)getUrl;
@end


//合同查询条件
@interface ContractQueryCondition : NSObject
@property (readwrite, nonatomic, strong) NSString *code;       //工单编码
@property (readwrite, nonatomic, strong) NSMutableArray *status;       //状态数组 0--未开始 1--执行中 2--已到期
@property (readwrite, nonatomic, strong) NSMutableArray *opStatus;   //合同操作状态数组 0--验收不通过 1--验收通过 2--已终止 3--已存档
@property (readwrite, nonatomic, strong) NSMutableArray *costType;     //支付方式
@property (readwrite, nonatomic, strong) NSNumber *timeStart;
@property (readwrite, nonatomic, strong) NSNumber *timeEnd;
@property (readwrite, nonatomic, strong) NSNumber *equipmentId;    //设备ID
@end

// 15.2 合同记录查询
@interface ContractQueryParam : BaseRequest
@property (readwrite, nonatomic, strong) ContractQueryCondition * condition;
@property (readwrite, nonatomic, strong) NetPageParam * page;

- (instancetype)init;
- (instancetype) initWithCondition:(ContractQueryCondition *) condition andPage:(NetPageParam *) page;
-(NSString *)getUrl;
@end

//
@interface ContractQueryResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

//
@interface ContractQueryResponse : BaseResponse
@property (readwrite, nonatomic, strong) ContractQueryResponseData * data;
@end
