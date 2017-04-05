//
//  WriteOrderEditPlanStepViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ResizeableView.h"
#import "OnMessageHandleListener.h"
#import "WorkOrderDetailEntity.h"

@interface WriteOrderEditPlanStepViewController : BaseViewController <UITextViewDelegate, OnViewResizeListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWithStep:(WorkOrderStep *) step;
- (void) setWorkOrderId:(NSNumber *) woId;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end

