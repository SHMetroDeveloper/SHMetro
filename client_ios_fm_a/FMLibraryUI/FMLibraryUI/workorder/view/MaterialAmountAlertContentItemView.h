//
//  MaterialAmountSelectContentItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/22.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "OnClickListener.h"
#import "BaseDataEntity.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, MaterialAmountOperateType) {
    MATERIAL_AMOUNT_TYPE_UNKNOW,
    MATERIAL_AMOUNT_TYPE_BATCH_SELECT,
    MATERIAL_AMOUNT_TYPE_OK
};

@interface MaterialAmountAlertContentItemView : UIView<OnClickListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//获取预定数量
- (NSInteger) getReserveAmount;

//设置物料名
- (void) setMaterialName:(NSString *) name;

//设置过期事件和批次数量
- (void) setDueDate:(NSNumber *) dueDate batchAmount:(NSInteger) batchAmount;

//设置预定数量
- (void) setReserveAmount:(NSInteger) amount;

- (void) clearInput;

//- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
- (void) setInputDelegate:(id<UITextFieldDelegate>) delegate;
@end
