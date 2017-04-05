//
//  OptionSelectTableViewCell.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 2017/1/22.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionSelectTableViewCell : UITableViewCell

- (void)setContentColor:(UIColor *)mColor;

- (void)setContentFont:(UIFont *)mFont;

- (void)setPlaceHolder:(NSString *)placeholder;

- (void)setContent:(NSString *)content;

+ (CGFloat)getItemHeight;

@end
