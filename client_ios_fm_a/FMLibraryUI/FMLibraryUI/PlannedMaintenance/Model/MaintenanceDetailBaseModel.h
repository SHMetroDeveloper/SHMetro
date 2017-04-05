//
//  MaintenanceDetailBaseEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaintenanceDetailBaseModel : NSObject

@property (readwrite,nonatomic,strong) NSString *name;//维保名字
@property (readwrite,nonatomic,strong) NSString *maintenanceStatus;//维保状态
@property (readwrite,nonatomic,strong) NSString *influence;//维保影响
@property (readwrite,nonatomic,strong) NSString *period;//周期
@property (readwrite,nonatomic,strong) NSString *dateFirstTodoDesc;//首次维保
@property (readwrite,nonatomic,strong) NSString *dateNextTodoDesc;//下次维保时间
@property (readwrite,nonatomic,strong) NSString *estimatedWorkingTime;//预估耗时
@property (readwrite,nonatomic,strong) NSString *genStatusDesc;//自动生成工单
@property (readwrite,nonatomic,strong) NSString *aheadDesc;//提前天数

@end
