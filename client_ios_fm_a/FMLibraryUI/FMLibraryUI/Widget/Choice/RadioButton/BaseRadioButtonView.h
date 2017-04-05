//
//  BaseRadioButtonView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface BaseRadioButtonView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置是否选中
- (void) setSelected:(BOOL) selected;
//设置文本提示
- (void) setDesc:(NSString *) desc;

- (void) setOnClickListener:(id<OnClickListener>) listener;

@end
