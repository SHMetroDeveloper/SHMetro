//
//  Transaction.m
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 29/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "TransLogin.h"

@implementation TransLogin


- (instancetype) init  : (NSString * ) strUser
             strPassword : (NSString *) strPassword
{
    self = [super init];
    
    _bussinessinfo = [[BussinessInfo alloc] initWithType: BUSSINESS_LOGIN];
    _bussinessinfo.dicBodys = [[NSMutableDictionary alloc] init];
    [_bussinessinfo.dicBodys setValue: strUser forKey: @"j_username"];
    [_bussinessinfo.dicBodys setValue: strPassword forKey: @"j_password"];

    return self;
};

-(void) onSuccess:(BussinessInfo *)info {
    
    [BussinessClient analyzeUserInfo: info];

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
