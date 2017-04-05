//
//  UserRequest.h
//  hello
//
//  Created by 杨帆 on 15/4/1.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

//用户信息请求
@interface UserRequest : BaseRequest
- (NSString *) getUrl;
@end


//修改密码请求
@interface UserChangePasswordRequest : BaseRequest
@property (readwrite, nonatomic, strong) NSString * oPassword;   //旧密码
@property (readwrite, nonatomic, strong) NSString * nPassword;  //新密码
- (instancetype) initWithPassword:(NSString *) password andNewPassword:(NSString *) newPassword;
- (NSString *) getUrl;
@end

//绑定手机号请求
@interface UserBindPhoneRequest : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber* userId;
@property (readwrite, nonatomic, strong) NSString * phone;
- (instancetype) initWithUserId:(NSNumber*) userId andPhone:(NSString *) phone;
- (NSString *) getUrl;
@end

//用户反馈
@interface UserFeedbackRequest : BaseRequest
@property (readwrite, nonatomic, strong) NSString * content;
@property (readwrite, nonatomic, strong) NSMutableArray* pictures;
- (instancetype) initWithContent:(NSString *) content andPictures:(NSMutableArray *) pictures;
- (NSString *) getUrl;
@end
