//
//  FMSignView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/14.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMSignView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//获取签字截图
- (UIImage *) getSignImage;

//设置是否显示边框
- (void) setShowBounds:(BOOL) show;

@end
