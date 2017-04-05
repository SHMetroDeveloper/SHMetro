//
//  WorkOrderWriteToolItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOrderWriteToolItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithCreateName:(NSString*) name
                          unit:(NSString*) unit
                         count:(NSInteger) count
                          cost:(NSString*) cost
                          desc:(NSString *) desc;

@end
