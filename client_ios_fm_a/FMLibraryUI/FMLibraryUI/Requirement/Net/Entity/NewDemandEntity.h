//
//  NewDemandEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseDataEntity.h"

@interface NewDemandRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSString * requester;
@property (readwrite, nonatomic, strong) NSString * contact;
@property (readwrite, nonatomic, strong) NSString * desc;
@property (readwrite, nonatomic, strong) NSNumber * typeId;
@property (readwrite, nonatomic, strong) NSMutableArray * photoIds;
@property (readwrite, nonatomic, strong) NSMutableArray * audioIds;
@property (readwrite, nonatomic, strong) NSMutableArray * videoIds;

- (instancetype) init;
- (NSString *) getUrl;

@end

@interface NewDemandImage : NSObject

@property (readwrite, nonatomic, strong) NSNumber * imageId;
@property (readwrite, nonatomic, strong) NSString * imageUrl;

@end


@interface NewDemandDetail : NSObject

@property (readwrite, nonatomic, strong) NSString * userName;
@property (readwrite, nonatomic, strong) NSString * phoneNumber;
@property (readwrite, nonatomic, strong) NSString * descDetail;
@property (readwrite, nonatomic, strong) NSNumber * typeId;

@property (readwrite, nonatomic, strong) NSMutableArray * imgs; //图片地址
@property (readwrite, nonatomic, strong) NSMutableArray * pictures;
@property (readwrite, nonatomic, strong) NSMutableArray * audios;
@property (readwrite, nonatomic, strong) NSMutableArray * medias;

- (instancetype)init;
@end
