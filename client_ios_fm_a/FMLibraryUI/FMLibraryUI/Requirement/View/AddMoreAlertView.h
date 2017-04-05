//
//  AddMoreAlertView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/16.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, ButtonType) {
    BUTTON_TYPE_IMAGE,
    BUTTON_TYPE_CAMERA,
    BUTTON_TYPE_AUDIO,
    BUTTON_TYPE_MEDIA,
};


@interface AddMoreAlertView : UIView<UITextViewDelegate>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect) frame;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
