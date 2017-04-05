//
//  PatrolHistoryDetailBaseInfoView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatrolHistoryDetailBaseInfoView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置信息
- (void) setInfoWithName:(NSString *) userName andCycle:(NSString *) cycle andEstimateTime:(NSString *) estimateTime andActualTime:(NSString *) actualTime;

+ (CGFloat) getBaseInfoHeight;

@end
