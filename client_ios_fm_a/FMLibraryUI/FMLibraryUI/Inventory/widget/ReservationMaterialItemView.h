//
//  ReservationMaterialItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/13/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderDetailEntity.h"
#import "OnClickListener.h"
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, ReservationMaterialActionType) {
    RESERVATION_MATERIAL_ACTION_CLICK,   //点击
    RESERVATION_MATERIAL_ACTION_DELETE,  //删除
};

@interface ReservationMaterialItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithCreateName:(NSString *) name
                         model:(NSString *) model
                         brand:(NSString *) brand
                          unit:(NSString *) unit
                         count:(CGFloat) count
                          cost:(NSString *) cost
                          desc:(NSString *) desc;

- (void) setShowBounds:(BOOL) showBounds;
//设置是否允许删除
- (void) setEditable:(BOOL)editable;

//设置点击事件监听
- (void) setOnClickListener:(id<OnClickListener>) listener;

@end


