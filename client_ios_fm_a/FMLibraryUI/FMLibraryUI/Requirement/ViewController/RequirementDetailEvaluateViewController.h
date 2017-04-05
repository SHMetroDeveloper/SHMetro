//
//  RequirementDetailEvaluateViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 10/25/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//  需求评价
//
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface RequirementDetailEvaluateViewController : BaseViewController

- (instancetype) init;
- (void) setInfoWithRequirementId:(NSNumber *) reqId;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
