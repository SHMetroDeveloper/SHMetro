//
//  Token.h
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Token: NSObject

@property (readwrite, nonatomic, assign) NSInteger mExpiresTime;
@property (readwrite, nonatomic, assign) NSInteger mExpiresIn;
@property (readwrite, nonatomic, strong) NSString * mAccessToken;
@property (readwrite, nonatomic, strong) NSString * mRefreshToken;
@property (readwrite, nonatomic, strong) NSString * mUid;

- (BOOL) isSessionValid;
- (NSString *) toString;

@end
