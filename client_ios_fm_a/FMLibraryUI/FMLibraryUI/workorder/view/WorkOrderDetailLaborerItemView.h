//
//  WorkOrderDetailLaborerView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface WorkOrderDetailLaborerItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithName:(NSString *) name
                position:(NSString *) position
                   telno:(NSString *) telno
              arriveTime:(NSString *) arriveTime
              finishTime:(NSString *) finishTime
                  status:(NSInteger) status
             responsible:(BOOL) isResponsible;

- (void) setShowBounds:(BOOL) show;
- (void) setEditable:(BOOL) editable;

- (void) setOnClickListener:(id<OnClickListener>) listener;
@end
