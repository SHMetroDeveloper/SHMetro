//
//  ServerAddressEditView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/8/10.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, ServerAddressEditType) {
    SERVER_ADDRESS_EDIT_CANCEL, //取消
    SERVER_ADDRESS_EDIT_OK,     //确定
};

@interface ServerAddressEditView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;


- (NSString *) getAddressInput;

- (void) setDefaultAddress:(NSString *) address;
- (void) setAddress:(NSString *) address;
- (void) clearInput;
- (void) updateViews;

//设置是否展示圆角
- (void) setShowCorner:(BOOL) showCorner;

- (void) setDelegate:(id<UITextFieldDelegate>) delegate;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end


