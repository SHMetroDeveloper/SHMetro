//
//  TaskWorkOrderItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/21.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskWorkOrderItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;
- (void) setInfoWithCode:(NSString*) code
                    desc:(NSString*) desc
                    time:(NSString*) time
                location:(NSString*) location
                priority:(NSString*) priority
                opration:(NSInteger) opration;

@end

extern NSInteger const TASK_WORK_ORDER_STATUS_RECEIVE;       //接单
extern NSInteger const TASK_WORK_ORDER_STATUS_HANDLE;       //处理工单