//
//  MissionCheckView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/26.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionCheckView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setFinished:(BOOL) finished;

- (void) setEndTime:(NSString *) time;

- (void) setInfoWithMeterName:(NSString *) metername
                     location:(NSString *) location
                andFinsihTime:(NSString *) finishtime;

+ (CGFloat) calculateHeightByFinished:(BOOL) finished;

@end
