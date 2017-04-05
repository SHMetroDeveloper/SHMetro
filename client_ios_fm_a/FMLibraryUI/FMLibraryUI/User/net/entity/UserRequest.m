//
//  UserRequest.m
//  hello
//
//  Created by 杨帆 on 15/4/1.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "UserRequest.h"
#import "SystemConfig.h"
#import "UserServerConfig.h"

@implementation UserRequest

- (NSString *) getUrl {
    NSString* url = [self wrapUrl:[[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], USER_INFO_URL]];
    return url;
}

@end



@implementation UserChangePasswordRequest
- (instancetype) initWithPassword:(NSString *) password andNewPassword:(NSString *) newPassword {
    self = [super init];
    if(self) {
        _oPassword = [password copy];
        _nPassword = [newPassword copy];
    }
    return self;
}
- (NSString *) getUrl {
    NSString* url = [self wrapUrl:[[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], USER_CHANGE_PWD_URL]];
    return url;
}
@end

@implementation UserBindPhoneRequest
- (instancetype) initWithUserId:(NSNumber*) userId andPhone:(NSString *) phone {
    self = [super init];
    if(self) {
        _userId = [userId copy];
        _phone = [phone copy];
    }
    return self;
}

- (NSString *) getUrl {
    NSString* url = [self wrapUrl:[[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], USER_BIND_PHONE_URL]];
    return url;
}
@end


@implementation UserFeedbackRequest

- (instancetype) initWithContent:(NSString *) content andPictures:(NSMutableArray *) pictures{
    self = [super init];
    if(self) {
        _content = [content copy];
        _pictures = [pictures copy];
    }
    return self;
}

- (NSString *) getUrl {
    NSString* url = [self wrapUrl:[[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], USER_FEEDBACK_URL]];
    return url;
}

@end
