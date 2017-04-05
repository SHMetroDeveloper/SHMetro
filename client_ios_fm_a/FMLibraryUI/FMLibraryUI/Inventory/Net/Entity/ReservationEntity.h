
//
//  ReservationEntity.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"
#import "InventoryServerConfig.h"

//预定请求类型
typedef NS_ENUM(NSInteger, ReservationQueryType) {
    RESERVATION_QUERY_TYPE_UNKNOW = 0,      //未知
    RESERVATION_QUERY_TYPE_CHECK = 1,       //待审核
    RESERVATION_QUERY_TYPE_HISTORY = 2,     //历史审核
    RESERVATION_QUERY_TYPE_MY_REQUEST = 3,  //我的预定
    RESERVATION_QUERY_TYPE_APPROVALED = 4,  //待出库
    RESERVATION_QUERY_TYPE_REJECTED = 5,  //已驳回
    RESERVATION_QUERY_TYPE_STORAGE_OUT = 6,  //已出库
};



@interface ReservationEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber * activityId;
@property (readwrite, nonatomic, strong) NSNumber * warehouseId;
@property (readwrite, nonatomic, strong) NSString * warehouseName;
@property (readwrite, nonatomic, strong) NSString * reservationCode;
@property (readwrite, nonatomic, strong) NSString * reservationPersonName;
@property (readwrite, nonatomic, strong) NSNumber * reservationPersonId;    //预定人ID
@property (readwrite, nonatomic, strong) NSNumber * administrator;          //仓库管理员ID
@property (readwrite, nonatomic, strong) NSNumber * supervisor;             //主管ID
@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSString * woCode;
@property (readwrite, nonatomic, strong) NSNumber * reservationDate;
@property (readwrite, nonatomic, assign) ReservationStatusType status;
@end


@interface GetReservationListParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * userId;
@property (readwrite, nonatomic, assign) ReservationQueryType queryType;
@property (readwrite, nonatomic, strong) NSNumber * timeStart;
@property (readwrite, nonatomic, strong) NSNumber * timeEnd;
@property (readwrite, nonatomic, strong) NetPageParam* page;
- (instancetype) initWithUserId:(NSNumber *) userId queryType:(ReservationQueryType) queryType page:(NetPage *) page;
- (instancetype) initWithUserId:(NSNumber *) userId queryType:(ReservationQueryType) queryType page:(NetPage *) page timeStart:(NSNumber *) timeStart timeEnd:(NSNumber *) timeEnd;
- (NSString *) getUrl;
@end

@interface GetReservationListOfWorkOrderParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * woId;
- (instancetype) init;
- (NSString *) getUrl;
@end


@interface GetReservationListResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface GetReservationListResponse : BaseResponse
@property (readwrite, nonatomic, strong) GetReservationListResponseData * data;
@end

@interface GetReservationListOfWorkOrderResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
@end
