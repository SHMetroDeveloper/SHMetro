//
//  PatrolHistoryCountView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

//

#import <UIKit/UIKit.h>

@interface PatrolHistoryCountView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithReportCount:(NSInteger) reportCount
                 andIgnoreCount:(NSInteger) ignoreCount
              andExceptionCount:(NSInteger) exceptionCount;

+ (CGFloat) getCountViewHeight;

@end
