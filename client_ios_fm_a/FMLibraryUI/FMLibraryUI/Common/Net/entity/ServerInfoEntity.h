//
//  ServerInfoEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"

@interface ServerInfoRequestParam : BaseRequest
- (instancetype) initWith:(NSNumber *) userId;
- (NSString*) getUrl;
@end

@interface ServerInfoEntity : NSObject
@property (readwrite, nonatomic, strong) NSString * serverId;
@end
