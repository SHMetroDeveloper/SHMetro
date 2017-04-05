//
//  EnergyMissionListView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/7/11.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnergyMissionListView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithTitle:(NSString *) title
              description:(NSString *) desc
           lastSubmitTime:(NSNumber *) lastTime;

+ (CGFloat) calculateheightByLastTime:(NSNumber *) lastTime;

@end
