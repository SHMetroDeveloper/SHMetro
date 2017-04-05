//
//  WorkOrderSignatureViewController.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/8.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, WorkOrderSignatureType) {
    WO_SIGNATURE_TYPE_CUSTOMER, //客户签字
    WO_SIGNATURE_TYPE_SUPERVISOR,//主管签字
};

@interface WorkOrderSignatureViewController : BaseViewController

- (instancetype) initWithSignType:(WorkOrderSignatureType)type andOrderId:(NSNumber *)orderId;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

//设置是否可编辑
- (void) setEditable:(BOOL) editable;

//设置签字图片
- (void) setInfoWithImage:(UIImage *) img;

//设置签字图片
- (void) setInfoWithUrl:(NSURL *) url;

@end


