//
//  OAuthUserInfo.h
//  hello
//
//  Created by 杨帆 on 15/3/27.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OAuthUserType) {
    OAUTH_USER_LEADER,      //领导层
    OAUTH_USER_MANAGER,     //管理层
    OAUTH_USER_LABORER     //员工
};

@interface OAuthUserInfo : NSObject

@property (readwrite, nonatomic, assign) NSInteger userId;
@property (readwrite, nonatomic, assign) NSInteger userType;

@end
