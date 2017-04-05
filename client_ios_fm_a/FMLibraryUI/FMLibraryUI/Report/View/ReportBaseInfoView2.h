//
//  ReportBaseInfoView2.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "OnClickListener.h"

typedef NS_ENUM(NSInteger, ReportBaseItemType) {
    REPORT_BASE_ITEM_TYPE_ORG,         //部门
    REPORT_BASE_ITEM_TYPE_SERVICE_TYPE,//服务类型
    REPORT_BASE_ITEM_TYPE_LOCATION,    //位置
    REPORT_BASE_ITEM_TYPE_PRIORITY,     //优先级
    REPORT_BASE_ITEM_TYPE_ORDER_TYPE    //工单类型
};

@interface ReportBaseInfoView2 : UIView <OnClickListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

#pragma mark - Setter赋值方法
- (void) setUserName:(NSString *) name;
- (void) setPhone:(NSString *) phone;
- (void) setOrg:(NSString *) org;
- (void) setServiceType:(NSString *) stype;
- (void) setLocation:(NSString *) location;
- (void) setPriority:(NSString *) priority;
- (void) setOrderType:(NSInteger) orderType;

#pragma mark - Getter取值方法
- (NSString *) getName;
- (NSString *) getPhone;
- (NSString *) getOrg;
- (NSString *) getServiceType;
- (NSString *) getLocation;
- (NSString *) getPriority;
- (NSInteger) getOrderType;

//计算高度
+ (CGFloat) calculateHeightByItemCount:(NSInteger)count;

- (void) setOnItemLickListener:(id<OnItemClickListener>) listener;

@end



