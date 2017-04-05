//
//  ApprovalWorkOrderEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"

//操作类型
typedef NS_ENUM(NSInteger, ApprovalWorkOrderOperateType) {
    ORDER_OPERATE_APPROVAL_TYPE_UNKNOW,
    ORDER_OPERATE_APPROVAL_TYPE_ACCESS  = 1,     //通过
    ORDER_OPERATE_APPROVAL_TYPE_REFUSE          //拒绝
};


@interface ApprovalWorkOrderRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSString * content;
@property (readwrite, nonatomic, assign) NSInteger operateType;
@property (readwrite, nonatomic, strong) NSNumber * approvalId;

- (instancetype) initWithOrderId:(NSNumber *) woId content:(NSString *) content operateType:(NSInteger) operateType approvalId:(NSNumber *) approvalId;
- (NSString*) getUrl;

@end
