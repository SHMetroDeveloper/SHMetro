//
//  PatrolHistoryItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatrolTaskHistoryEntity.h"
#import "ResizeableView.h"

@interface PatrolHistoryItemView : UIView<OnViewResizeListener>

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWithPatrolTask:(PatrolTaskHistoryItem *) task;

@end
