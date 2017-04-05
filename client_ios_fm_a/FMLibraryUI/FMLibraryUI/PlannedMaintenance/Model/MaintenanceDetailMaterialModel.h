//
//  MaintenanceDetailMaterialModel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaintenanceDetailMaterialModel : NSObject
@property (readwrite,nonatomic,strong) NSString * name;     //物料名称
@property (readwrite,nonatomic,strong) NSString * model;    //型号
@property (readwrite,nonatomic,strong) NSString * brand;    //品牌
@property (readwrite,nonatomic,strong) NSString * amountDesc;    //数量
@end
