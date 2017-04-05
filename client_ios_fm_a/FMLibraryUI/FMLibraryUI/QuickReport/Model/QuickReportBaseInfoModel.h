//
//  QuickReportBaseInfoModel.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/10.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataEntity.h"

@interface QuickReportBaseInfoModel : NSObject

@property (nonatomic, strong) NSString *applicant; //申请人
@property (nonatomic, strong) NSString *phoneNumber;  //电话号码
@property (nonatomic, strong) ServiceType *serviceType;  //服务类型
@property (nonatomic, strong) Position *location;  //站点
@property (nonatomic, strong) NSString *desc;

@end
