//
//  BasePicker.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/30/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"


typedef NS_ENUM(NSInteger, BasePickerActionType) {
    BASE_PICKER_ACTION_CANCEL, //取消
    BASE_PICKER_ACTION_OK,     //确定
};

@interface BasePicker : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置数据数组, 参数是字符串数组
- (void) setDataByArray:(NSArray *) array;
//设置字体大小
- (void) setRowFont:(UIFont *) font;
//设置选中数据位置
- (void) setCenterIndex:(NSInteger) index;
//设置选中数据
- (void) setCenterData:(NSString *) data;

//获取选中的数据
- (id) getSelectedData;
//获取选中的位置
- (NSInteger) getSelectedIndex;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end

