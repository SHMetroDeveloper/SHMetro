//
//  RequireDetailAddContentViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/26.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ResizeableView.h"
#import "OnMessageHandleListener.h"

@interface RequireDetailAddContentViewController : BaseViewController <UITextViewDelegate, OnViewResizeListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setContent:(NSString *) content;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end