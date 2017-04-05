//
//  SimpleUserEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/13/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "BaseRequest.h"
#import "BaseResponse.h"

@interface SimpleUserEntity : NSObject

@property (readwrite, nonatomic, strong) NSNumber * userId;
@property (readwrite, nonatomic, strong) NSNumber * emId;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSNumber * pictureId;

@end

@interface SimpleUserRequestParam : BaseRequest
- (NSString *) getUrl;
@end

@interface SimpleUserRequestResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
@end
