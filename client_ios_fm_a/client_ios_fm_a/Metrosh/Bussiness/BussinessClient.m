//
//  HttpClient.m
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 27/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "BussinessClient.h"


@implementation BussinessClient

+ (void) analyzeUserInfo :(BussinessInfo *) bussinessInfo {
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [[BussinessUserInfo getSingleton] setCookies: cookieJar.cookies];
    
    if ([(bussinessInfo.dicResponses) valueForKey:@"token"] ) {
        ([BussinessUserInfo getSingleton]).strToken = [(bussinessInfo.dicResponses) valueForKey:@"token"];
    }

    if ([(bussinessInfo.dicResponses) valueForKey:@"trueName"] ) {
        ([BussinessUserInfo getSingleton]).strTrueName = [(bussinessInfo.dicResponses) valueForKey:@"trueName"];
    }
    
    if ([(bussinessInfo.dicResponses) valueForKey:@"userNo"] ) {
        ([BussinessUserInfo getSingleton]).strUserNo = [(bussinessInfo.dicResponses) valueForKey:@"userNo"];
    }
    
    if ([(bussinessInfo.dicResponses) valueForKey:@"roleIds"] ) {
        ([BussinessUserInfo getSingleton]).strRoles = [(bussinessInfo.dicResponses) valueForKey:@"roleIds"];
    }

};

+ (void) requestWithUrl: (BussinessInfo *) bussinessInfo
                      listener: (NSObject<BussinessListener> *)bussinesslistener {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    for(NSString * key in bussinessInfo.dicHeaders.allKeys ) {
        [manager.requestSerializer setValue: bussinessInfo.dicHeaders[key] forHTTPHeaderField:key];
    }
    
    [manager POST: bussinessInfo.strUrl parameters: bussinessInfo.dicBodys
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        bussinessInfo.afOperation = operation;
        bussinessInfo.dicResponses = responseObject;
        bussinessInfo.error = NULL;
        
        [bussinesslistener onSuccess: bussinessInfo ];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
   
        bussinessInfo.afOperation = operation;
        bussinessInfo.dicResponses = NULL;
        bussinessInfo.error = error;
        
        [bussinesslistener onError: bussinessInfo ];
    }];
};

@end
