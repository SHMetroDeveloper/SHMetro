//
//  WorkOrderDetailViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "BaseViewController.h"
#import "PullTableView.h"
//#import "MWPhotoBrowser.h"
#import "OnClickListener.h"
#import "OnMessageHandleListener.h"
#import "ResizeableView.h"
#import "OnListItemButtonClickListener.h"
#import "OnItemClickListener.h"
#import "FileUploadListener.h"
#import "WorkOrderServerConfig.h"

@interface WorkOrderDetailViewController : BaseViewController

- (instancetype) init;

- (void) setWorkOrderWithId:(NSNumber *) orderId;
- (void) setWorkOrderWithId:(NSNumber *) orderId approvalId:(NSNumber *) approvalId;

- (void) setReadOnly:(BOOL) readonly;


@end
