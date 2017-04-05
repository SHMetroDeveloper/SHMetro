//
//  OperateReservationEntity.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"

//预定的操作类型，
typedef NS_ENUM(NSInteger, ReservationOperationType) {
    RESERVATION_OPERATION_TYPE_PASS,    //通过
    RESERVATION_OPERATION_TYPE_REFUSE,   //驳回
    RESERVATION_OPERATION_TYPE_CANCEL,   //取消出库
    RESERVATION_OPERATION_TYPE_CANCELLATION   //取消预定
};

@interface ReservationApprovalRequestParam : BaseRequest
@property (readwrite, nonatomic, assign) ReservationOperationType type; //审批结果类型
@property (readwrite, nonatomic, strong) NSNumber * activityId;         //预定单号
@property (readwrite, nonatomic, strong) NSString * desc;               //描述
@end


