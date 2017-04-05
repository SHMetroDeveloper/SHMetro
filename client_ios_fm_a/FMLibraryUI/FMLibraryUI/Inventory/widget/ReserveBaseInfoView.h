//
//  ReserveBaseInfoView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//
//  库存预定基本信息，包括预订人，预定时间，以及备注，建议最小高度设置为 220；

#import <UIKit/UIKit.h>
#import "ResizeableView.h"
#import "OnItemClickListener.h"

//
typedef NS_ENUM(NSInteger, ReserveBaseInfoType) {
    RESERVE_BASE_INFO_TYPE_UNKNOW,
    RESERVE_BASE_INFO_TYPE_TIME     //选择时间
};

typedef NS_ENUM(NSInteger, ReserveBaseInfoViewType) {
    RESERVE_BASE_INFO_VIEW_TYPE_RESERVE,    //预定
    RESERVE_BASE_INFO_VIEW_TYPE_DELIVERY    //出库
};


@interface ReserveBaseInfoView : ResizeableView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setViewType:(ReserveBaseInfoViewType) type;

- (void) setShowBound:(BOOL) showBound;
- (void) setInfoWith:(NSString *) person
                time:(NSNumber *) time
                note:(NSString *) note;

- (void) setUserName:(NSString *) userName;
- (void) setTime:(NSNumber *) time;
- (NSString *) getNote;

- (void) setEditable:(BOOL) editable;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
@end
