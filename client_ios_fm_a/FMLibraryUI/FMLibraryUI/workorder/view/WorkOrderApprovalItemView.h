//
//  WorkOrderApprovalItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "ExpandableView.h"
#import "WorkOrderApprovalEntity.h"

@interface WorkOrderApprovalItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;
- (instancetype) init;
- (void) setFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithWorkJobDetail:(WorkOrderApproval *) jobDetail;


- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

//计算所需高度
+ (CGFloat) calculateHeightByApprovalContent:(NSString *) approvalContent andDesc:(NSString *) desc pfmCode:(NSString *) pfmCode  andWidth:(CGFloat) width;
@end
