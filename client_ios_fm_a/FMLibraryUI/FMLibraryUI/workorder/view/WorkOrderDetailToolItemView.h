//
//  WorkOrderDetailToolItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderDetailEntity.h"
#import "OnClickListener.h"
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, OrderToolActionType) {
    WO_TOOL_ACTION_CLICK,   //点击
    WO_TOOL_ACTION_DELETE,  //删除
};

@interface WorkOrderDetailToolItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithCreateName:(NSString*) name
                         model:(NSString *) model
                         brand:(NSString *) brand
                          unit:(NSString*) unit
                         count:(NSInteger) count
                          cost:(CGFloat) cost
                          desc:(NSString *) desc;

- (void) setShowBounds:(BOOL) showBounds;
//设置是否允许删除
- (void) setEditable:(BOOL)editable;

@end

