//
//  WorkOrderGrabItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/3.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "WorkOrderGrabEntity.h"

typedef NS_ENUM(NSInteger, EWorkOrderItemOperateType) {
    WORK_ORDER_ITEM_OPERATE_TYPE_ORDER,     //点击view
    WORK_ORDER_ITEM_OPERATE_TYPE_GRAB       //点击抢单
};

@interface WorkOrderGrabItemView : UIView
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;
- (void) setInfoWithOrder:(WorkOrderGrab*) order;
- (void) setShowGrabButton:(BOOL) show;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

//计算所需高度
+ (CGFloat) calculateHeightByDesc:(NSString *) desc location:(NSString *) location andWidth:(CGFloat) width ;
@end
