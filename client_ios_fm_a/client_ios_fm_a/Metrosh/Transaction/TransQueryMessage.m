//
//  TransQueryMessage.m
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 30/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "TransQueryMessage.h"

@implementation TransQueryMessage

- (instancetype) init {
    self = [super init];
    
    _bussinessinfo = [[BussinessInfo alloc] initWithType: BUSSINESS_QUERY_MESSAGE];
    _bussinessinfo.dicBodys = [[NSMutableDictionary alloc] init];
    
    for (NSHTTPCookie *cookie in [[BussinessUserInfo getSingleton] getCookie]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie: cookie ];
    }
    return self;
};

-(void) onSuccess:(BussinessInfo *)info {
    
    if (_onFinish) {
        _onFinish();
    }
};


-(void) onError:(BussinessInfo *)info {
    if (_onFailure) {
        [self onFailure];
    }
};

- (void) request : (void (^)()) onFinish
        onFailer : (void (^)()) onFailure {
    
    self.onFinish = onFinish;
    self.onFailure = onFailure;
    
    [BussinessClient requestWithUrl:_bussinessinfo listener:self];
    
};


@end
