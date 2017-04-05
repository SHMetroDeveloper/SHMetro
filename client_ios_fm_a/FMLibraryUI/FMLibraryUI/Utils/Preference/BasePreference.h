//
//  BasePreference.h
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasePreference : NSObject

//保存用户设置 --- 字符串
+ (void) saveUserInfoKey: (NSString*) key
             stringValue: (NSString *) value;

//获取用户设置 --- 字符串
+ (NSString*) getUserInfoString: (NSString*) key;

//保存用户设置 --- number 类型
+ (void) saveUserInfoKey: (NSString*) key
                numberValue: (NSNumber *) value;

//获取用户设置 --- number 类型
+ (NSNumber *) getUserInfoNumber: (NSString*) key;

//清除用户设置
+ (void) clearUserInfoKey:(NSString *) key;

@end
