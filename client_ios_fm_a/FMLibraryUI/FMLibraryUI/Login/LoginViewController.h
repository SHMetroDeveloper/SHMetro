//
//  LoginViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/21.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"


@interface LoginViewController : BaseViewController

- (instancetype) init;

//仪电对接token获取接口
- (void)setPrimaryToken:(NSString *)token;

@end

