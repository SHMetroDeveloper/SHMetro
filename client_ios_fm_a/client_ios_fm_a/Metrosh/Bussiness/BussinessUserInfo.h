//
//  UserInfo.h
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 27/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BussinessUserInfo : NSObject

@property (readwrite, nonatomic, strong) NSString * strToken ;
@property (readwrite, nonatomic, assign) NSString * strRoles ;

@property (readwrite, nonatomic, strong) NSString * strTrueName ;
@property (readwrite, nonatomic, strong) NSString * strUserNo ;
@property (readwrite, nonatomic, strong) NSArray<NSHTTPCookie *> * cookies;

+(instancetype)getSingleton;

+(id)allocWithZone:(NSZone *)zone;

-(void)setCookie:(NSArray<NSHTTPCookie *> *)cookies  ;

-(NSString *) getToken ;

-(NSString *) getTrueName ;

-(NSArray<NSHTTPCookie *> *)getCookie;




@end
