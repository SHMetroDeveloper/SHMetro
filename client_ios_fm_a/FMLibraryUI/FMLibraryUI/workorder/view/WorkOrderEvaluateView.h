//
//  WorkOrderEvaluateView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/18.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, OrderEvaluateType) {
    ORDER_EVALUATE_TYPE_CANCEL, //取消
    ORDER_EVALUATE_TYPE_OK,     //确定
};


@interface WorkOrderEvaluateView : UIView
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
@end
