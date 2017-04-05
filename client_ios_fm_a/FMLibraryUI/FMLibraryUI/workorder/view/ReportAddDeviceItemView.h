//
//  ReportAddDeviceItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ResizeableView.h"
#import "ReportEntity.h"
#import "OnClicklistener.h"
#import "OnListItemButtonClickListener.h"


@interface ReportAddDeviceItemView : ResizeableView <OnViewResizeListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithDeviceCode:(NSString *) code name:(NSString *) name location:(NSString *) location ;

//设置内部对齐方式
- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom;
//设置是否可编辑
- (void) setEditable:(BOOL) editable;

//设置点击事件的代理
- (void) setOnClickListener:(id<OnClickListener>) listener;
//设置删除按钮的点击事件的代理
- (void) setOnDeleteListener:(id<OnListItemButtonClickListener>) listener;

//计算 view 所需要的高度
+ (CGFloat) calculateHeightByInfo:(NSDictionary *) info andWidth:(CGFloat) width andEditable:(BOOL) editable;
@end