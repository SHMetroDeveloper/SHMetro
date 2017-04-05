//
//  ChartsViewController.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/10.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, ProjectBackType) {   //跳转方式
    PROJECT_BACK_TYPE_NEW = 0,   //新建
    PROJECT_BACK_TYPE_BACK = 1,//返回
};

@interface ProjectsViewController : BaseViewController 

- (instancetype) initWithType:(ProjectBackType) type;

@end
