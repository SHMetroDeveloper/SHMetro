//
//  OutLineDownloadViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"
#import "BaseDataEntity.h"

@interface OutlineDownloadViewController : BaseViewController<OnMessageHandleListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;

- (void) setUpdateInfoWith:(UpdateRecord *) record;

@end
