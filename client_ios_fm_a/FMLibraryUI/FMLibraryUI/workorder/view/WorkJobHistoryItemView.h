//
//  WorkJobHistoryItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderHistoryEntity.h"

@interface WorkJobHistoryItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;

- (void) setFrame:(CGRect)frame;

- (void) setInfoWithOrder:(WorkOrderHistory*) order;

+ (CGFloat) calculateHeightByDescription:(NSString *) desc pfmCode:(NSString *) pfmCode andWidth:(CGFloat) width;

@end
