//
//  ContractStatisticsEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

//合同分类
@interface ContractTypeAmount : NSObject
@property (readwrite, nonatomic, strong) NSString * name;   //分类名称
@property (readwrite, nonatomic, assign) NSInteger total;  //总数
@property (readwrite, nonatomic, assign) NSInteger undo;   //未开始数量
@property (readwrite, nonatomic, assign) NSInteger expired;  //已过期合同数量
@property (readwrite, nonatomic, assign) NSInteger process;//执行中数量
@property (readwrite, nonatomic, assign) NSInteger terminated; //已终止数量
@property (readwrite, nonatomic, assign) NSInteger unPassed;   //已验收不通过
@property (readwrite, nonatomic, assign) NSInteger passed;   //已验收通过
@property (readwrite, nonatomic, assign) NSInteger closed;     //已关闭数量
@end

//合同统计信息
@interface ContractStatisticsEntity : NSObject
@property (readwrite, nonatomic, assign) NSInteger total;       //合同总数
@property (readwrite, nonatomic, assign) NSInteger receipt;     //收款合同总数
@property (readwrite, nonatomic, strong) NSString * receiptCost;//收款合同金额
@property (readwrite, nonatomic, assign) NSInteger payment;     //付款合同总数
@property (readwrite, nonatomic, strong) NSString * paymentCost;//付款合同金额
@property (readwrite, nonatomic, strong) NSMutableArray * amount;//合同分类数量
@end

// 15.5 合同信息统计
@interface ContractStatisticsRequestParam : BaseRequest
-(NSString *)getUrl;
@end

//合同统计信息结果
@interface ContractStatisticsResponse : BaseResponse
@property (readwrite, nonatomic, strong) ContractStatisticsEntity * data;
@end
