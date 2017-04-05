//
//  WorkOrderDetailPlannedStepItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderDetailEntity.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, WorkOrderPlannedStepEventType) {
    WO_PLANNED_STEP_EVENT_UNKNOW,
    WO_PLANNED_STEP_EVENT_EDIT,         //普通点击事件
    WO_PLANNED_STEP_EVENT_SHOW_PHOTO,   //展示大图
};

@interface WorkOrderDetailPlannedStepItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;
- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithStep:(WorkOrderStep *) step;
- (void) setEditable:(BOOL) editable;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;


+ (CGFloat) calculateHeightByInfo:(WorkOrderStep *) step  andWidth:(CGFloat)width andPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;
@end


