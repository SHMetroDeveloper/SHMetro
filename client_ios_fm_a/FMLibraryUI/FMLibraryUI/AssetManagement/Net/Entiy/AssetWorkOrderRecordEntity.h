//
//  AssetWorkOrderRecordEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"

typedef NS_ENUM(NSInteger, AssetRecordQueryType) {
    ASSET_WORK_ORDER_RECORD_QUERY_FIXED = 1,  //维修记录
    ASSET_WORK_ORDER_RECORD_QUERY_MAINTAIN = 2,  //维保记录
};

@interface AssetWorkOrderQueryRequestParam : BaseRequest

@property (nonatomic, strong) NSNumber * eqId;
@property (nonatomic, strong) NetPageParam * page;
@property (nonatomic, assign) BOOL isLaborers;
@property (nonatomic, assign) AssetRecordQueryType type;

- (instancetype)init;
- (instancetype)initWithQueryParams:(NSNumber *) eqId
                               page:(NetPageParam *) page
                         isLaborers:(BOOL) isLaborers
                               type:(AssetRecordQueryType) type;
- (NSString *)getUrl;
@end


@interface AssetWorkOrderFixedEntity : NSObject
@property (nonatomic, strong) NSNumber * actualCompletionDateTime;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * applicantPhone;
@property (nonatomic, strong) NSString * workContent;
@property (nonatomic, strong) NSString * applicantName;
@property (nonatomic, strong) NSNumber * woId;
@property (nonatomic, strong) NSString * serviceTypeName;
@property (nonatomic, strong) NSString * woDescription;
@property (nonatomic, strong) NSNumber * createDateTime;
@property (nonatomic, strong) NSNumber * currentLaborerStatus;
@property (nonatomic, strong) NSNumber * priorityId;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSString * laborers;
@end


@interface AssetWorkOrderMaintainEntity : NSObject
@property (nonatomic, strong) NSNumber * actualCompletionDateTime;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * applicantPhone;
@property (nonatomic, strong) NSString * workContent;
@property (nonatomic, strong) NSString * applicantName;
@property (nonatomic, strong) NSNumber * woId;
@property (nonatomic, strong) NSString * serviceTypeName;
@property (nonatomic, strong) NSString * woDescription;
@property (nonatomic, strong) NSNumber * createDateTime;
@property (nonatomic, strong) NSNumber * currentLaborerStatus;
@property (nonatomic, strong) NSNumber * priorityId;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSString * laborers;
@end


//维修记录
@interface AssetFixedRecordResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface AssetFixedRecordResponse : BaseResponse
@property (nonatomic, strong) AssetFixedRecordResponseData * data;
@end


//维保记录
@interface AssetMaintainRecordResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface AssetMaintainRecordResponse : BaseResponse
@property (nonatomic, strong) AssetMaintainRecordResponseData * data;
@end





