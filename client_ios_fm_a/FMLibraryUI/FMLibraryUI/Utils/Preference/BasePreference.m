//
//  BasePreference.m
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "BasePreference.h"
#import "FMUtils.h"

@implementation BasePreference

+ (void) saveUserInfoKey: (NSString*) key
             stringValue: (NSString *) value {
    if(![FMUtils isStringEmpty:key]) {
        if([FMUtils isStringEmpty:value]) {
            value = @"";
        }
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject:value forKey:key];
    }
}

+ (NSString*) getUserInfoString: (NSString*) key {
    id objValue = [NSNull null];
    NSString * res = nil;
    if(key) {
        objValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if(objValue && ![objValue isKindOfClass:[NSNull class]]) {
            res = objValue;
        }
    }
    return res;
}

+ (void) saveUserInfoKey: (NSString*) key
                numberValue: (NSNumber *) value {
    if(![FMUtils isStringEmpty:key]) {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject:value forKey:key];
    }
}

+ (NSNumber *) getUserInfoNumber: (NSString*) key {
    NSNumber * res = nil;
    if(![FMUtils isStringEmpty:key]) {
        id objValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if(objValue && ![objValue isKindOfClass:[NSNull class]]) {
            res = objValue;
        }
    }
    return res;
}

+ (void) clearUserInfoKey:(NSString *) key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
