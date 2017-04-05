//
//  WorkOrderDetailMaterialItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/8.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderDetailEntity.h"
#import "OnItemClickListener.h"


@interface WorkOrderDetailMaterialItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;


- (void) setInfoWithCreateName:(NSString*) name
                         model:(NSString *) model
                         brand:(NSString *) brand
                          unit:(NSString*) unit
                         count:(NSInteger) count;

- (void) setShowBounds:(BOOL) showBounds;

@end


