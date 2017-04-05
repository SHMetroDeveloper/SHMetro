//
//  PatrolHistoryFilterItemTimeView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

typedef NS_ENUM(NSInteger, FilterItemViewType) {
    FILTER_ITEM_VIEW_TAG_UNKNOW,        //未知
    FILTER_ITEM_VIEW_TAG_START,         //开始时间
    FILTER_ITEM_VIEW_TAG_END            //结束时间
};

@interface PatrolHistoryFilterItemTimeView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置数据
- (void) setInfoWithTimeStart:(NSString*) startTime
                          end:(NSString*) endTime;

//设置文本对齐距离
- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;


- (void) setOnClickListener:(id<OnClickListener>) listener;
@end
