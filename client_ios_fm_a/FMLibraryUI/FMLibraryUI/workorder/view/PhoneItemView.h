//
//  PhoneItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/8.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, PhoneActionType) {
    PHONE_ACTION_CALL,      //打电话
    PHONE_ACTION_MESSAGE,   //发短信
};


@interface PhoneItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithPhoneNumber:(NSString *) phoneNumber;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end


