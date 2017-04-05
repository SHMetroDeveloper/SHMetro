//
//  TotalCountView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/18.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalCountView : UIView

- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setFrame:(CGRect)frame;

- (void) setInfoWithFinished:(NSInteger)finished andAll:(NSInteger)all;

+ (CGFloat)calculateHeightByWidth:(CGFloat)width;

@end
