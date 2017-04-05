//
//  ContractOperateContentView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 17/1/4.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, ContractOperateContentActionType) {
    CONTRACT_OPERATE_CONTENT_ACTION_UNKNOW,
    CONTRACT_OPERATE_CONTENT_ACTION_PASS,    //通过
    CONTRACT_OPERATE_CONTENT_ACTION_REFUSE,  //不通过
};

@interface ContractOperateContentView : UIView

//设置content的标题
- (void)setTitleOfContentView:(NSString *)title;

//获取描述信息
- (NSString *)getDesc;

//清楚输入记录
- (void)clearInput;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
