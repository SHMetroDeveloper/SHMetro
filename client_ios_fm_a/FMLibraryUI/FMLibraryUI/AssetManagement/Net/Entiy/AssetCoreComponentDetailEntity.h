//
//  AssetCoreComponentDetailEntity.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/6.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"

@interface AssetCoreComponentDetailRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *eqCoreId;

- (NSString *)getUrl;
@end

@interface AssetCoreComponentReplaceRecord : NSObject
@property (nonatomic, strong) NSNumber *eqCoreId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *handler;
@property (nonatomic, strong) NSNumber *operateTime;
@property (nonatomic, strong) NSNumber *period;   //质保期
@property (nonatomic, strong) NSNumber *installDate;  //安装日期
@property (nonatomic, strong) NSNumber *expireDate;   //质保到期
@property (nonatomic, strong) NSNumber *replacedDate;  //被替换日期
@end

@interface AssetCoreComponentDetailEntity : NSObject
@property (nonatomic, strong) NSNumber *eqCoreId;    //组件ID
@property (nonatomic, strong) NSString *code;    //组件编码
@property (nonatomic, strong) NSString *name;    //组件名称
@property (nonatomic, strong) NSString *brand;   //品牌
@property (nonatomic, strong) NSString *model;   //型号
@property (nonatomic, strong) NSNumber *period;   //质保期
@property (nonatomic, strong) NSNumber *installDate;  //安装日期
@property (nonatomic, strong) NSNumber *expireDate;   //质保到期
@property (nonatomic, strong) NSNumber *replacedDate;  //被替换日期
@property (nonatomic, strong) NSMutableArray *history;   //该设备中该组件的更换记录列表
@end

@interface AssetCoreComponentDetailResponse : BaseResponse
@property (nonatomic, strong) AssetCoreComponentDetailEntity *data;
@end


