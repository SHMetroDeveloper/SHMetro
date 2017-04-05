//
//  MaintenanceDetailEquipmentModel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaintenanceDetailEquipmentModel : NSObject
@property (readwrite, nonatomic, strong) NSString * code;   //名称
@property (readwrite, nonatomic, strong) NSString * name;   //名称
@property (readwrite, nonatomic, strong) NSString * location;   //位置
@property (readwrite, nonatomic, strong) NSString * system;     //系统分类
@end
