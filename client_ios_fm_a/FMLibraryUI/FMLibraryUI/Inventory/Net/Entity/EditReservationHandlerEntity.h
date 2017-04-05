//
//  EditReservationHandlerEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/18/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"

@interface EditReservationHandlerParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * activityId;         //预定单号
@property (readwrite, nonatomic, strong) NSNumber * administrator;      //仓库管理员
@property (readwrite, nonatomic, strong) NSNumber * supervisor;         //主管
@property (readwrite, nonatomic, strong) NSNumber * reservePerson;      //预定人
@end
