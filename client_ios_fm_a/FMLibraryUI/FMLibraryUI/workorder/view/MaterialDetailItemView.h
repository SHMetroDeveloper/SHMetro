//
//  MaterialDetailItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/22.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "OnClickListener.h"
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, MaterialDetailItemOperateType) {
    MATERIAL_DETAIL_ITEM_OPERATE_TYPE_UNKNOW,    //未知
    MATERIAL_DETAIL_ITEM_OPERATE_TYPE_NAME,       //名字
    MATERIAL_DETAIL_ITEM_OPERATE_TYPE_DATE,       //时间
    MATERIAL_DETAIL_ITEM_OPERATE_TYPE_DELETE       //删除
};

@interface MaterialDetailItemView : UIView <OnClickListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置基本信息
- (void) setInfoWithName:(NSString *) name brand:(NSString *) brand model:(NSString *) model amount:(NSInteger) amount unit:(NSString *) unit;
//设置批次时间和批次数量
- (void) setDueDate:(NSNumber *) dueDate andBatchAmount:(NSInteger) batchAmount;
//设置预定数量
- (void) setReserveAmount:(NSInteger) reserveAmount;


//获取预定的数量
- (NSInteger) getReserveAmount;

//清除所有输入的信息
- (void) clearInfo;

//设置点击事件监听器
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

//计算所需的高度
+ (CGFloat) calculateHeightByInfo;

@end