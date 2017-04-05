//
//  GrabWorkOrderEntity.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/4.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

//抢单
@interface GrabWorkOrderParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber* userId;
@property (readwrite, nonatomic, strong) NSNumber* woId;
@property (readwrite, nonatomic, strong) NSNumber* arrivalDateTime;

- (instancetype) init;
- (NSString*) getUrl;

@end
