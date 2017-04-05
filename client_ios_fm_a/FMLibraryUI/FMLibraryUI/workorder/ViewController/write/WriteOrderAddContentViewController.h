//
//  WriteOrderAddContentViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ResizeableView.h"
#import "OnMessageHandleListener.h"
#import "WorkOrderDetailEntity.h"
#import "FileUploadService.h"

@interface WriteOrderAddContentViewController : BaseViewController <UITextViewDelegate,OnViewResizeListener,FileUploadListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setContent:(NSString *) content;
- (void) setWorkOrderId:(NSNumber *)woId;
- (void) setWorkOrderDetail:(WorkOrderDetail *)orderDetail andWorkOrderId:(NSNumber *)orderId;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) listener;
@end
