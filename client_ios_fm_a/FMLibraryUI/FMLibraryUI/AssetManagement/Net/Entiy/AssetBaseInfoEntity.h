//
//  AssetBaseInfoEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/11/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"

@interface AssetEquipmentCount : NSObject
@property (readwrite, nonatomic, assign) NSInteger idle;    //闲置
@property (readwrite, nonatomic, assign) NSInteger stop;    //停用
@property (readwrite, nonatomic, assign) NSInteger working; //使用中
@property (readwrite, nonatomic, assign) NSInteger repairing;//维修中
@property (readwrite, nonatomic, assign) NSInteger scraping;   //待报废
@property (readwrite, nonatomic, assign) NSInteger scraped;   //已报废
@property (readwrite, nonatomic, assign) NSInteger locked;   //已封存
@end

@interface AssetBaseInfoEntity : NSObject
@property (readwrite, nonatomic, assign) NSInteger totalCount;
@property (readwrite, nonatomic, assign) NSInteger systemCount;
@property (readwrite, nonatomic, assign) NSInteger maintainCount;
@property (readwrite, nonatomic, strong) AssetEquipmentCount*  equipment;
@end

@interface RequestAssetBaseInfoParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * postId;
@end

@interface AssetBaseInfoResponse : BaseResponse
@property (readwrite, nonatomic, strong) AssetBaseInfoEntity * data;
@end
