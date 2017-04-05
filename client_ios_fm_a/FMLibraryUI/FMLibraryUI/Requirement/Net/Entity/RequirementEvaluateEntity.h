//
//  RequirementEvaluateEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"

@interface RequirementEvaluateRequestParam : BaseRequest

@property (nonatomic, strong) NSNumber *reqId;   //需求ID
@property (nonatomic, assign) NSInteger quality;  //质量评分（0 ~ 10）
@property (nonatomic, assign) NSInteger speed;  //质量评分（0 ~ 10）
@property (nonatomic, assign) NSInteger attitude;  //质量评分（0 ~ 10）
@property (nonatomic, strong) NSString *desc;    //评价描述

- (NSString *)getUrl;
@end
