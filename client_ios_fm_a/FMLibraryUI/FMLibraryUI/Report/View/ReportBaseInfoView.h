//
//  ReportBaseInfoView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "OnClickListener.h"

typedef NS_ENUM(NSInteger, ReportBaseInfoItemType) {
    REPORT_BASE_INFO_ITEM_TYPE_UNKNOW,      //未知
    REPORT_BASE_INFO_ITEM_TYPE_ORG,         //部门
    REPORT_BASE_INFO_ITEM_TYPE_SERVICE_TYPE,//服务类型
    REPORT_BASE_INFO_ITEM_TYPE_LOCATION,    //位置
    REPORT_BASE_INFO_ITEM_TYPE_PRIORITY,     //优先级
    REPORT_BASE_INFO_ITEM_TYPE_ORDER_TYPE    //工单类型
};

@interface ReportBaseInfoView : UIView<OnClickListener>


- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setInfoWithName:(NSString *) userName
                andPhone:(NSString *) phone
                  andOrg:(NSString *) orgName
          andServiceType:(NSString *) serviceType
             andLocation:(NSString *) location
             andPriority:(NSString *) priority
            andOrderType:(NSInteger) orderType;

- (void) setUserName:(NSString *) name;

- (void) setPhone:(NSString *) phone;

- (NSString *) getPhone;

- (void) setOrg:(NSString *) org;

- (NSString *) getOrg;

- (void) setServiceType:(NSString *) stype;

- (NSString *) getServiceType;

- (void) setLocation:(NSString *) location;

- (NSString *) getLocation;

- (void) setPriority:(NSString *) priority;

- (void) setOrderType:(NSInteger) orderType;

- (NSInteger) getOrderType;

- (void) setOnItemLickListener:(id<OnItemClickListener>) listener;

+ (CGFloat) calculateHeightByLocation:(NSString*) location andWidth:(CGFloat) width;

@end


