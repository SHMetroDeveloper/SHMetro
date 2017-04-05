//
//  MaintenanceDetailToolModel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaintenanceDetailToolModel : NSObject
@property (readwrite,nonatomic,strong) NSString * name;     //名称
@property (readwrite,nonatomic,strong) NSString * model;    //型号
@property (readwrite,nonatomic, strong) NSString* amountDesc;    //数量
@end
