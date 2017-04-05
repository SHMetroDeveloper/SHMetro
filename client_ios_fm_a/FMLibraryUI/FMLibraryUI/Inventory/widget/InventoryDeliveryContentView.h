//
//  InventoryDeliveryContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/19/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, InventoryDeliveryAlertContentOperateType) {
    INVENTORY_DELIVERY_ALERT_OPERATE_TYPE_UNKNOW,
    INVENTORY_DELIVERY_ALERT_OPERATE_TYPE_CANCEL,
    INVENTORY_DELIVERY_ALERT_OPERATE_TYPE_OK
};

@interface InventoryDeliveryContentView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置标题
- (void) setTitleWithText:(NSString *) title;

//设置预定信息
- (void) setInfoWithAmount:(NSString *) amount warehouse:(NSString *) warehouse applicant:(NSString *) applicant date:(NSString *) date;

//设置提示信息
- (void) setEditLabelWithText:(NSString *) text;
//获取用户输入的信息
- (NSString *) getDesc;
//清除信息
- (void) clearInput;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
