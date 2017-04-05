//
//  CaptionTextTableViewCell.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/13/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface CaptionTextTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

//设置标题
- (void) setTitle:(NSString *) title;

//设置默认提示
- (void) setPlaceholder:(NSString *) placeholder;

//设置内容
- (void) setText:(NSString *) text;

- (NSString *) text;

//设置是否显示描述信息
- (void) setDesc:(NSString *) desc;

//设置是否显示必填标记
- (void) setShowMark:(BOOL) showMark;

//设置只读
- (void) setReadonly:(BOOL) readonly;

//设置只显示一行
- (void) setShowOneLine:(BOOL) isOneLine;

//设置点击事件监听
- (void) setOnClickListener:(id<OnClickListener>) listener;
@end
