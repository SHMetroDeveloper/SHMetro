//
//  NotificationOperateEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseRequest.h"

@interface NotificationOperateParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * msgId;

- (instancetype) initWithMsg:(NSNumber *) msgId;

- (NSString*) getUrl;
@end
