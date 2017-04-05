//
//  WorkContentHeaderView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/16.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

@interface WorkContentHeaderView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置索要显示的名字，说明文本以及文本的展示方式
- (void) setInfoWithName:(NSString *) name;
//设置右图标的宽度
- (void) setRightImgWidth:(CGFloat)rightImgWidth;
//设置是否显示图片
- (void) setShowRightImage:(BOOL)showRightImage;
//设置是否显示左侧标签
- (void) setShowMark:(BOOL)showMark;
//设置是否显示边框
- (void) setShowBorder:(BOOL)showBorder;
//设置点击事件
- (void) setOnItemClickListener:(id<OnItemClickListener>) clickListener;

@end


