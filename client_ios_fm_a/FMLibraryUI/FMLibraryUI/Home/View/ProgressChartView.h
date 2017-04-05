//
//  ProgressChartView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/15.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressChartView : UIView

- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame;

-(void)setFrame:(CGRect)frame;

- (void) setInfoWidthFinishenArray:(NSMutableArray *)finish andAllArray:(NSMutableArray *)all;

+ (CGFloat)calculateHeightByWidht:(CGFloat)width;

@end
