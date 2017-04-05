//
//  FMTimeLabel.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/30.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FMTimeLabel : UILabel

//设置timelabel的字体大小
@property (nonatomic, strong) UIFont *mFont;
//设置timelabel的字体颜色
@property (nonatomic, strong) UIColor *mColor;

+ (CGSize) calculateSizeByFont:(UIFont *)font;

@end
