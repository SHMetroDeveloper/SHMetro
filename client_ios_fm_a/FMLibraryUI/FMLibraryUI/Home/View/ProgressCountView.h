//
//  ProgressCountView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/15.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressCountView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置完成数和总数
- (void) setInfoWithCountFinished:(NSInteger) finishedCount all:(NSInteger) allCount;
//设置标题
- (void) setDesc:(NSString *)desc andDescColor:(UIColor *)descColor;
//设置进度条颜色
- (void) setProgressColor:(UIColor *) progressColor;

@end
