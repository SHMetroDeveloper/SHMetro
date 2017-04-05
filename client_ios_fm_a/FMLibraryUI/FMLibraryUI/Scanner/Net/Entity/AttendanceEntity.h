//
//  AttendanceEntity.h
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseDataEntity.h"
#import "BaseResponse.h"

@interface AttendanceEntity : NSObject

@property (nonatomic, strong) NSNumber *contactId; //值班人员ID
@property (nonatomic, strong) NSString *contactName; //值班人员名字
@property (nonatomic, strong) NSString *locationName; //位置名称
@property (nonatomic, strong) Position *location; //签到位置
@property (nonatomic, strong) NSNumber *createTime; //签到时间

@end


@interface AttendanceResponse : BaseResponse

@property (nonatomic, strong) AttendanceEntity *data;

@end


/**
 签到请求实体
 */
@interface AttendanceRequest : BaseRequest

@property (nonatomic, strong) NSNumber *personId; //被签的委外人员ID
@property (nonatomic, strong) NSNumber *contactId; //值班人员ID
@property (nonatomic, strong) NSString *contactName; //值班人员名字
@property (nonatomic, strong) Position *location; //签到位置
@property (nonatomic, strong) NSNumber *createTime; //签到时间

- (instancetype)initWithPersonId:(NSNumber *)personId
                       contactId:(NSNumber *)contactId
                     contactName:(NSString *)contactName
                        location:(Position *)location
                      createTime:(NSNumber *)createTime;

- (NSString *)getUrl;

@end
