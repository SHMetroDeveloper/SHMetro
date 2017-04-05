//
//  CurrentMonthTaskView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/23.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentMonthTaskView : UIView

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;

- (void) setNumberOfTaskFinished:(NSInteger)finished
                          missed:(NSInteger)missed
                            undo:(NSInteger)undo
                      processing:(NSInteger)processing;

+ (CGFloat) calculateHeight;

@end
