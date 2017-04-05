//
//  MessageOperationEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 2017/2/10.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"

//消息已读
@interface MessageOperationReadAllRrequestParam : BaseRequest
@property (nonatomic, assign) NSInteger type;  //请求类型

- (NSString *)getUrl;

@end


//消息删除
@interface MessageOperationDeleteRrequestParam : BaseRequest
@property (nonatomic, assign) NSInteger type;  //请求类型

@property (nonatomic, strong) NSMutableArray *messages;  //消息ID数组 如果值不为空则表示删除指定ID的消息记录，否则删除所有满足指定条件的消息记录

- (NSString *)getUrl;

@end

