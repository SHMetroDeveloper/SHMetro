//
//  WorkOrderTodayEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/5.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "BaseResponse.h"


/**
 *
 *  今日工单概况
 *
 */
@interface WorkOrderChartTodayParam : BaseRequest
//无请求参数
- (instancetype)init;
- (NSString *)getUrl;
@end

@interface WorkOrderChartToday : NSObject
@property (readwrite, nonatomic, assign) NSInteger type;  //数据类型
@property (readwrite, nonatomic, assign) NSInteger finishedAmount;  //指定类型的工单完成的数量
@property (readwrite, nonatomic, assign) NSInteger allAmount;   //制定类型的工单所有的数量
@end

@interface WorkOrderChartTodayResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
- (instancetype)init;
@end




/**
 *
 *  近七日工单完成情况
 *
 */
@interface WorkOrderChartCurrentDaysParam : BaseRequest
//无请求参数
- (instancetype)init;
- (NSString *)getUrl;
@end

@interface WorkOrderChartCurrentDays : NSObject
@property (readwrite, nonatomic, strong) NSNumber * date;  //时间戳
@property (readwrite, nonatomic, assign) NSInteger finishedAmount;  //指定日期的工单已处理的数量
@property (readwrite, nonatomic, assign) NSInteger newAmount;   //指定日期的工单生成的数量
- (instancetype)init;
@end

@interface WorkOrderChartCurrentDaysResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
- (instancetype)init;
@end




/**
 *
 *  工单总数
 *
 */
@interface WorkOrderChartStatisticsParam : BaseRequest
//无请求参数
- (instancetype)init;
- (NSString *)getUrl;
@end

@interface WorkOrderChartStatistics : NSObject
@property (readwrite, nonatomic, assign) NSInteger finishedAmount;  //已处理的工单数量
@property (readwrite, nonatomic, assign) NSInteger allAmount;   //工单的总量
- (instancetype)init;
@end

@interface WorkOrderChartStatisticsResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
- (instancetype)init;
@end





/**
 *
 *  每月工单数
 *
 */
@interface WorkOrderChartMonthlyParam : BaseRequest
@property (readwrite, nonatomic, strong) NSMutableArray * month;
- (instancetype)init;
- (NSString *)getUrl;
@end

@interface WorkOrderChartMonthly : NSObject
@property (readwrite, nonatomic, assign) NSInteger finishedAmmount;  //衣橱里的工单数量
@property (readwrite, nonatomic, assign) NSInteger allAmount;  //工单的总数
- (instancetype)init;
@end

@interface WorkOrderChartMonthlyResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
- (instancetype)init;
@end














