//
//  WorkOrderValidateView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/14.
//  Copyright © 2016年 flynn. All rights reserved.
//
//  工单验证弹出框

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, WorkOrderValidateContentActionType) {
    WO_VALIDATE_CONTENT_ACTION_UNKNOW,
    WO_VALIDATE_CONTENT_ACTION_SIGN,    //签字
    WO_VALIDATE_CONTENT_ACTION_PASS,    //验证通过
    WO_VALIDATE_CONTENT_ACTION_REFUSE,  //不通过
};

@interface WorkOrderValidateContentView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;

- (void) setFrame:(CGRect) frame;

//获取描述信息
- (NSString *) getDesc;

////获取签字图片
//- (UIImage *) getSignImage;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
