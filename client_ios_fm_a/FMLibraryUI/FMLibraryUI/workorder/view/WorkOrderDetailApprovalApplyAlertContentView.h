//
//  WorkOrderDetailApprovalApplyAlertContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/29.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "OnMessageHandleListener.h"
#import "WorkOrderApproverEntity.h"
#import "OnClickListener.h"
#import "BaseListHeaderView.h"

typedef NS_ENUM(NSInteger, ApprovalApplyOperateType) {
    APPROVAL_APPLY_ALERT_TYPE_UNKNOW,
    APPROVAL_APPLY_ALERT_TYPE_DELETE_LABORER,   //
    APPROVAL_APPLY_ALERT_TYPE_SELECT_LABORER,   //
    APPROVAL_APPLY_ALERT_TYPE_DONE,        //
};

@interface WorkOrderDetailApprovalApplyAlertContentView : UIView<UITableViewDataSource, UITableViewDelegate, OnListSectionHeaderClickListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;


- (void) addApprover:(WorkOrderApprover *) approver;
- (void) clearInput;
- (NSString *) getApprovalApplyDesc;


- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end

