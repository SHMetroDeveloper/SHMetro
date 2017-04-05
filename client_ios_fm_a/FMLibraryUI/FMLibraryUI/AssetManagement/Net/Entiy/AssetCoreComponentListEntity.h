//
//  AssetCoreComponentListEntity.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/7.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

@interface AssetCoreComponentListParam : BaseRequest
@property (nonatomic, strong) NSNumber *eqId;  //设备id

- (instancetype)init;

- (NSString *)getUrl;

@end

@interface AssetCoreComponentListEntity : NSObject
@property (nonatomic, strong) NSNumber *eqCoreId;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@end

@interface AssetCoreComponentListResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray *data;
@end
