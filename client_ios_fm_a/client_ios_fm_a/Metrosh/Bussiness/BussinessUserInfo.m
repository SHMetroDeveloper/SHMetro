//
//  UserInfo.m
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 27/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "BussinessUserInfo.h"

static BussinessUserInfo * _instance = nil;

@implementation BussinessUserInfo

+(instancetype)getSingleton {
    @synchronized(self){  //为了确保多线程情况下，仍然确保实体的唯一性
        if (_instance == NULL) {
            _instance = [[self alloc] init]; //该方法会调用 allocWithZone
        }
    }
    return _instance;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (!_instance) {
            _instance = [super allocWithZone:zone]; //确保使用同一块内存地址
            return _instance;
        }
    }
    return nil;
}



-(NSString *) getToken  {
    return self.strToken;
};


-(NSString *) getTrueName {
    return self.strTrueName;
};



-(void)setCookie:(NSArray<NSHTTPCookie *> *)cookies {
    self.cookies = cookies;
};

-(NSArray<NSHTTPCookie *> *)getCookie {
    return self.cookies;
};

@end
