//
//  PasswordUtils.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/6/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface PasswordUtils : NSObject

+ (NSString *) encode:(NSString *) orginString;



@end

