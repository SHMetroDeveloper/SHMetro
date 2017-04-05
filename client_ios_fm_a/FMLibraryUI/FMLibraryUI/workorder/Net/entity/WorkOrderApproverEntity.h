//
//  WorkOrderApproverEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/30.
//  Copyright © 2015年 flynn. All rights reserved.
//
//  工单审批人

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"

@interface WorkOrderApproverRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * postId;

- (instancetype) initWithPostId:(NSNumber *) postId;
- (NSString*) getUrl;

@end


@interface WorkOrderApprover : NSObject
@property (readwrite, nonatomic, strong) NSNumber * approverId;    //执行人ID
@property (readwrite, nonatomic, strong) NSString * name;           //名字
@end

@interface WorkOrderApproverResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
@end
