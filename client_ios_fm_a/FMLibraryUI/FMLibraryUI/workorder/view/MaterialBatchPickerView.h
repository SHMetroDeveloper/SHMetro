//
//  MaterialBatchPickerView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/15.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MaterialBatchPickerView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setPickerDelegate:(id<UIPickerViewDelegate>) delegate;
- (void) setPickerDataSource:(id<UIPickerViewDataSource>) dataSource;
//刷新列表
- (void) update;
//获取所选的行数
- (NSInteger) getSelectedRowIndex;

//设置选中行数
- (void) setSelectRow:(NSInteger) row;
@end
