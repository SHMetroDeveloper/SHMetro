//
//  Header.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResizeableView.h"
#import "OnListItemButtonClickListener.h"
#import "OnClickListener.h"
#import "WorkOrderDetailEntity.h"

@interface WorkOrderDetailEquipmentItemView : ResizeableView<OnViewResizeListener, OnListItemButtonClickListener>

- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;
- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithCreateCode:(NSString*) code
                          name:(NSString*) name
                          desc:(NSString*) desc
                        repair:(NSString*) repair
                      finished:(BOOL) finished
                      needScan:(BOOL) needScan;
//设置 button 的点击事件代理
- (void) setOnListItemButtonClickListener:(id<OnListItemButtonClickListener>) listener;

//设置 view 的点击事件代理
- (void) setOnClickListener:(id<OnClickListener>) listener;

- (void) setEditable:(BOOL) editable;
+ (CGFloat) calculateHeightByInfo:(WorkOrderEquipment *) equip  andWidth:(CGFloat)width andPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;
@end
