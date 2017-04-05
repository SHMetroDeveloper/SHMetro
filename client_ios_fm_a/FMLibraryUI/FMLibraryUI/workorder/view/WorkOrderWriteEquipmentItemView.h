//
//  WorkOrderWriteEquipmentItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOrderWriteEquipmentItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithCreateCode:(NSString*) code
                          name:(NSString*) name
                      location:(NSString*) location
                        system:(NSString*) system
                          desc:(NSString*) desc
                        repair:(NSString*) repair;

//设置是否显示边框
- (void) setShowBounds:(BOOL) show;

//设置是否可编辑
- (void) setEditable:(BOOL)editable;

@end