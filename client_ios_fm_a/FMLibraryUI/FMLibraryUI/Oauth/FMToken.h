//
//  FMToken.h
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Token.h"

@interface FMToken : Token

- (instancetype) initWithJsonObject:(NSDictionary *) object;

@end
