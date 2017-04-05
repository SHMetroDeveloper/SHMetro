//
//  BaseStarRatingView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 10/25/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseStarRatingView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置名称
- (void) setName:(NSString *) name;

//设置进度 (0 ~ 10) 整数
- (void) setRating:(NSInteger) rating;

//获取当前评级
- (CGFloat) getRateValue;

@end
