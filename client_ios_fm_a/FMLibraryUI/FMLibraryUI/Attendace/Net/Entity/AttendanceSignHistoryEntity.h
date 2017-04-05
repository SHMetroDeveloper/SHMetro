//
//  AttendanceSignHistoryEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"


@interface AttendanceSignHistoryRequestParam : BaseRequest
@property (nonatomic, assign) NSInteger type;   //0-获取指定人在指定日期的签到记录  1-获取指定人最后一次签到记录
@property (nonatomic, strong) NSNumber *emId;   //目标执行人ID
@property (nonatomic, strong) NSNumber *time;   //签到时间
@end

@interface AttendanceSignHistoryDetailEntity : NSObject
@property (nonatomic, strong) NSNumber *recordId;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, assign) NSInteger type;   //1-wifi签到  2-蓝牙签到  3-gps签到
@property (nonatomic, assign) BOOL signin;
@property (nonatomic, strong) NSString *name;
@end

@interface AttendanceSignHistoryResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray *data;
- (instancetype)init;
@end


