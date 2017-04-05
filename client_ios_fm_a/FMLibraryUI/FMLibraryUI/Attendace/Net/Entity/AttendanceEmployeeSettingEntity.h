//
//  AttendanceEmployeeSettingEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"
#import "AttendanceSettingEntity.h"


//工作组请求方式
@interface AttendanceEmployeeWorkTeamRequestParam : BaseRequest
- (NSString *)getUrl;
@end

@interface AttendanceEmployeeWorkTeamEntity : NSObject
@property (nonatomic, strong) NSNumber *wtId;     //工作组ID
@property (nonatomic, strong) NSString *name;     //工作组名称
@property (nonatomic, assign) NSInteger count;    //组内人员数量
@end

@interface AttendanceEmployeeWorkTeamResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray *data;
- (instancetype)init;
@end



//工作组人员
@interface AttendanceEmployeeWorkEmployeeRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *wtId;
- (NSString *)getUrl;
@end

@interface AttendanceEmployeeWorkEmployeeResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray *data;
- (instancetype)init;
@end





