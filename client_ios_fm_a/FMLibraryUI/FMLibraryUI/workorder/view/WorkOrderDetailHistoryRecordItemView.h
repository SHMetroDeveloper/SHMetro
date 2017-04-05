//
//  WorkOrderDetailHistoryRecordItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/28.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResizeableView.h"
#import "OnListItemButtonClickListener.h"
#import "OnClickListener.h"
#import "WorkOrderDetailEntity.h"

@interface WorkOrderDetailHistoryRecordItemView : ResizeableView<OnViewResizeListener, OnListItemButtonClickListener>

- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;
- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithIndex:(NSInteger) index
                     time:(NSNumber*) time
                 operater:(NSString*) operater
                     step:(NSInteger) step
                  content:(NSString *) content;


+ (CGFloat) calculateHeightByInfo:(NSString *) content  andWidth:(CGFloat)width andPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;
@end

