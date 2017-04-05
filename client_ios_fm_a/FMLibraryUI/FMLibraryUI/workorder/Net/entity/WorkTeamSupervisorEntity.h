//
//  WorkTeamSupervisorEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/6/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"

//工作组主管
@interface WorkTeamSupervisorEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber * supervisorId;
@property (readwrite, nonatomic, strong) NSString * name;
@end

@interface WorkTeamSupervisorRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * laborerId;
@end

@interface WorkTeamSupervisorRequestResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
@end

