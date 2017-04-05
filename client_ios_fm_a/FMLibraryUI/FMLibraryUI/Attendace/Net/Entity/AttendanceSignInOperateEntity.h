//
//  AttendanceSignInOperateEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"
#import "AttendanceSettingEntity.h"

//签入签出操作
@interface AttendanceOperateSignRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *emId;    //执行人ID
@property (nonatomic, strong) NSNumber *time;    //时间
@property (nonatomic, assign) BOOL signin;       //签到记录类型是否为签入
@property (nonatomic, assign) NSInteger type;    //签出操作时类型
@property (nonatomic, strong) NSNumber *typeId;  //签到方式的id 例如wifiId，bluetoothId 签出时如果是在范围内，此字段表示签到方式  ID
@property (nonatomic, strong) AttendanceLocation *location;  //签出时的地理位置

- (instancetype)init;
- (NSString *)getUrl;
@end

@interface AttendanceOperateSignResponse : BaseResponse

@end

