//
//  WorkOrderDetailCommonItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResizeableView.h"
#import "BaseViewController.h"
#import "OnItemClickListener.h"


@interface WorkOrderDetailCommonItemView : ResizeableView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setExpand:(BOOL)expand;

- (void) setInfoWithCreateTime:(NSString*) createTime
                       contact:(NSString*) contact
                         telno:(NSString*) telno
                           org:(NSString*) org
                   serviceType:(NSString*) serviceType
                      location:(NSString*) location
                  estimateTime:(NSString*) estimateTime
                   reserveTime:(NSString*) reserveTime
                          desc:(NSString*) desc
                      priority:(NSInteger) priority
                        status:(NSInteger) status;

//用来处理 打电话事件
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

//依据位置信息和问题描述来计算所需要的高度
+ (CGFloat) calculateHeightByLocation:(NSString *) location
                              andDesc:(NSString *) desc
                                  org:(NSString *) org
                          serviceType:(NSString *) serviceType
                             andWidth:(CGFloat) width
                       andPaddingLeft:(CGFloat) paddingLeft
                      andPaddingRight:(CGFloat) paddingRight
                               expand:(BOOL) expand;

@end
