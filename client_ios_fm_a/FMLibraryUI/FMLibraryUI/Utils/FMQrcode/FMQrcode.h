//
//  FMQrcode.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/7/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//  二维码
//  编码格式：{FUNCTION}|{SUB_FUNCTION}|...|{COMPANY_NAME}

#import <Foundation/Foundation.h>

@interface FMQrcode : NSObject
//初始化
- (instancetype) initWithString:(NSString *) qrcode;
- (instancetype) initWithQrcode:(FMQrcode *) code;

//是否为合法编码
- (BOOL) isValidQrcode;

//获取原码
- (NSString *) getQrcode;

//获取模块值
- (NSString *) getFunction;

//获取子模块值
- (NSString *) getSubFunction;

//获取所属公司名字
- (NSString *) getCompany;

//获取自定义信息
- (NSArray *) getExtandArray;

//解析自定义信息，子类通过重写本方法来实现自定义属性的解析过程
- (void) analysisExtendInfo;


- (instancetype) copy;
@end
