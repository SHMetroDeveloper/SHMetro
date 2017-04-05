//
//  AssetPatrolRecordEntity.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/7.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

@interface AssetPatrolRecordRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *eqId;
@property (nonatomic, strong) NetPageParam *page;

- (NSString *)getUrl;
@end

@interface AssetPatrolRecordEntity : NSObject
@property (nonatomic, strong) NSNumber *patrolTaskId;  //巡检任务ID
@property (nonatomic, assign) NSInteger taskType;   //任务类型，0--巡检 1--巡视
@property (nonatomic, strong) NSString *patrolName;  //巡检任务名称
@property (nonatomic, strong) NSString *laborer;  //巡检人员
@property (nonatomic, strong) NSNumber *dueStartDateTime;  //预定开始时间
@property (nonatomic, strong) NSNumber *dueEndDateTime;  //预定结束时间
@property (nonatomic, assign) NSInteger leakNumber;  //漏检个数
@property (nonatomic, assign) NSInteger exceptionNumber;  //异常数量
@property (nonatomic, assign) NSInteger repairNumber;  //报修次数
@property (nonatomic, assign) NSInteger normalNumber;  //正常数量
@property (nonatomic, assign) NSInteger spotNumber;  //点位数量
@end

@interface AssetPatrolRecordResponseData : NSObject
@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic, strong) NetPage *page;
@end

@interface AssetPatrolRecordResponse : BaseResponse
@property (nonatomic, strong) AssetPatrolRecordResponseData *data;
@end
