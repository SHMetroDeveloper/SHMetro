//
//  WorkOrderFilterItemTimeView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/31.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

typedef NS_ENUM(NSInteger, WorkOrderFilterItemViewType) {
    ORDER_FILTER_ITEM_VIEW_TAG_UNKNOW,        //未知
    ORDER_FILTER_ITEM_VIEW_TAG_START,         //开始时间
    ORDER_FILTER_ITEM_VIEW_TAG_END,            //结束时间
    ORDER_FILTER_ITEM_VIEW_TAG_USED            //耗时
};

@interface WorkOrderFilterItemTimeView : UIView<UITextFieldDelegate>

- (instancetype) initWithFrame:(CGRect)frame;

//设置数据
- (void) setInfoWithTimeStart:(NSString*) startTime
                          end:(NSString*) endTime
                         used:(NSString *) usedTime;

//获取耗时
- (NSNumber *) getTimeUsed;

//设置文本对齐距离
- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;


- (void) setOnClickListener:(id<OnClickListener>) listener;
@end

