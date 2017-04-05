//
//  PowerEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"

@interface PowerEntity : NSObject
@end

@interface PowerRequestParam : BaseRequest
- (instancetype) init;
- (NSString *) getUrl;
@end

@interface PowerRequestResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data; //字符串数组，对应模块的 key
@end
