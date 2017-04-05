//
//  ApplyApprovalWorkOrderEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/30.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"

@interface ApplyApprovalParamItem : NSObject
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * value;
@end

@interface ApplyApprovalContent : NSObject
@property (readwrite, nonatomic, strong) NSNumber * templateId;
@property (readwrite, nonatomic, assign) NSInteger approvalType;
@property (readwrite, nonatomic, strong) NSMutableArray * parameters;
- (instancetype) init;
@end


@interface ApplyApprovalWorkOrderParam : BaseRequest

@property (readwrite, nonatomic, strong) NSMutableArray * approverIds;
@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) ApplyApprovalContent * approval;

- (instancetype) init;
- (NSString*) getUrl;

@end

@interface ApplyApprovalWorkOrderResponse : BaseResponse

@end


