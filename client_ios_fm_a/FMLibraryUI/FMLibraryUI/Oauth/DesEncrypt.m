//
//  DesEncrypt.m
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "DesEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation DesEncrypt

+ (NSString *) getEncString:(NSString *) strMing
                        key:(NSString *) key {
    NSData *data= [strMing dataUsingEncoding:NSUTF8StringEncoding];
    
    if([data length]>0){
        data = [GTMBase64 encodeData:data];//编码
    }
    
    NSString *retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return retStr;
}

+ (NSString *) getDesString:(NSString *) strMi
                        key:(NSString *) key {
    NSData *data= [strMi dataUsingEncoding:NSUTF8StringEncoding];
    
    if([data length]>0){
        data = [GTMBase64 decodeData:data];//解码
    }
    
    NSString *retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return retStr;

}

@end