//
//  BaseTimeLabel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/13.
//  Copyright © 2015年 flynn. All rights reserved.
//

//  用于显示日期和事件的 View

#import <UIKit/UIKit.h>

@interface BaseTimeLabel : UILabel

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置时间
- (void) setTime:(NSDate *) date;
- (void) setTimeWithNumber:(NSNumber *) timeNumber;


@end
