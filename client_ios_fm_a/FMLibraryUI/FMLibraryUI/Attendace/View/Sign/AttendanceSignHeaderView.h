//
//  AttendanceSignHeaderView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DateBtnActionBlock)();

@interface AttendanceSignHeaderView : UIView

@property (nonatomic, copy) DateBtnActionBlock actionBlock;

- (void) setDateTime:(NSNumber *) datetime;

+ (CGFloat) calculateHeight;

@end
