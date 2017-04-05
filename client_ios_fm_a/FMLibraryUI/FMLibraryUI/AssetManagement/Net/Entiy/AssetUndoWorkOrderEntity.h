//
//  AssetUndoWorkOrderEntity.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/16.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"

@interface AssetUndoWorkOrderRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *eqId;
- (NSString *)getUrl;
@end

@interface AssetUndoWorkOrderEntity : NSObject
@property (nonatomic, strong) NSNumber *woId;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) NSInteger priorityId;
@property (nonatomic, strong) NSString *woDescription;
@property (nonatomic, strong) NSNumber *createDateTime;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger currentLaborerStatus;
@property (nonatomic, strong) NSString *applicantName;
@property (nonatomic, strong) NSString *applicantPhone;
@property (nonatomic, strong) NSString *serviceTypeName;
@property (nonatomic, strong) NSString *workContent;
@property (nonatomic, strong) NSNumber *actualCompletionDateTime;
@end

@interface AssetUndoWorkOrderResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray *data;

- (instancetype)init;

@end
