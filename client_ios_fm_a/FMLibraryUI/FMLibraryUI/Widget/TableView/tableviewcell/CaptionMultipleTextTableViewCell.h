//
//  CaptionMultipleTextTableViewCell.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/7.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface CaptionMultipleTextTableViewCell : UITableViewCell

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

//设置点击事件监听
- (void) setOnClickListener:(id<OnClickListener>) listener;

@end
