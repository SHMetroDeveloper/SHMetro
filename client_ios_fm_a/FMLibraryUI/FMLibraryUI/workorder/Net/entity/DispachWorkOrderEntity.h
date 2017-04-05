//
//  DispachWorkOrderEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"

@interface DispachWorkOrderLaborer : NSObject
@property (readwrite, nonatomic, strong) NSNumber * laborerId;
@property (readwrite, nonatomic, assign) BOOL responsible;
@end

@interface DispachWorkOrderRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSNumber * estimatedArrivalDate;
@property (readwrite, nonatomic, strong) NSNumber * estimatedCompletionDate;
@property (readwrite, nonatomic, strong) NSNumber * estimatedWorkingTime;
@property (readwrite, nonatomic, strong) NSMutableArray * laborers;

- (instancetype) init;
- (NSString*) getUrl;

@end

