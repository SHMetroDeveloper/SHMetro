//
//  ApprovalTaskAlertContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/24.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "ResizeableView.h"

typedef NS_ENUM(NSInteger, ApprovalTaskOperateType) {
    APPROVAL_TASK_APPROVAL_TYPE_UNKNOW,
    APPROVAL_TASK_APPROVAL_TYPE_ACCESS,
    APPROVAL_TASK_APPROVAL_TYPE_REFUSE
};

@interface ApprovalTaskAlertContentView : UIView<OnViewResizeListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;
- (NSString *) getApprovalDesc;

- (ApprovalTaskOperateType) getApprovalResultType;

- (void) clearInput;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;


@end
