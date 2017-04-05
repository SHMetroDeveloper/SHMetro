//
//  GrabOrderContentItemView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/4.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, GrabOrderContentItemOperateType) {
    GRAB_ORDER_CONTENT_ITEM_OPERATE_UNKNOW,
    GRAB_ORDER_CONTENT_ITEM_OPERATE_SELECT_TIME,     //设置时间
    GRAB_ORDER_CONTENT_ITEM_OPERATE_OK,     //抢单
    GRAB_ORDER_CONTENT_ITEM_OPERATE_CANCEL     //取消
};

@interface GrabOrderContentItemView : UIView


- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWith:(NSNumber *) time;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
@end
