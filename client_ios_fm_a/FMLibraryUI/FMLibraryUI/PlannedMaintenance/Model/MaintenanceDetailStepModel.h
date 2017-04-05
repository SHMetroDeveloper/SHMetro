//
//  MaintenanceDetailStepModel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaintenanceDetailStepModel : NSObject
@property (readwrite,nonatomic,strong) NSString *group;//工作组
@property (readwrite,nonatomic,strong) NSString *content;//维护内容
@property (readwrite,nonatomic,strong) NSString *step;//步骤描述
@end
