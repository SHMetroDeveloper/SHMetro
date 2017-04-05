//
//  LoginListener.h
//  hello
//
//
//  Created by 杨帆 on 15/3/31.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@protocol LoginListener <NSObject>

@required
- (void) onLoginSuccess: (Token*) token;
- (void) onLoginError: (NSError *) error;
- (void) onLoginCancel;

@end
