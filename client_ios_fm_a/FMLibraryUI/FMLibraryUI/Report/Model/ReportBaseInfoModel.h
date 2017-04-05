//
//  ReportBaseInfoModel.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/7/27.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportBaseInfoModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *org;
@property (nonatomic, strong) NSString *stype;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *priority;
@property (nonatomic, assign) NSInteger orderType;

@end
