//
//  RequirementBaseInfoView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"
#import "OnItemClickListener.h"
#import "ResizeableView.h"

typedef NS_ENUM(NSInteger, RequirementBaseInfoType) {
    REQUIREMENT_BASE_INFO_ITEM_UNKNOW,      //未知
    REQUIREMENT_BASE_INFO_ITEM_DEMAND_TYPE,//需求类型
};

@interface RequirementBaseInfoView : ResizeableView <OnViewResizeListener,OnClickListener>

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;

- (void) setUserName:(NSString *) name;
- (void) setPhone:(NSString *) phone;
- (void) setInfoWithDemandType:(NSString *) demandType;

- (NSString *) getDemander;
- (NSString *) getPhoneNumber;
- (NSString *) getDemandType;
- (NSString *) getDescDetail;

- (void) clearAll;

- (void) setOnItemLickListener:(id<OnItemClickListener>) listener;

//+ (CGFloat) get

@end
