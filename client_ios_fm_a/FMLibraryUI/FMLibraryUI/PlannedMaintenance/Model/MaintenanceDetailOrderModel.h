//
//  MaintenanceDetailOrderModel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaintenanceDetailOrderModel : NSObject
@property (readwrite, nonatomic, strong) NSString * code;   //名称
@property (readwrite, nonatomic, assign) NSInteger status;   //
@property (readwrite, nonatomic, strong) NSString * time;     //
@property (readwrite, nonatomic, strong) NSString * applicant;     //
@property (readwrite, nonatomic, strong) NSString * location;     //
@end
