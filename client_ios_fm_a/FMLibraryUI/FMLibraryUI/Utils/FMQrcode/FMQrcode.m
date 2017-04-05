//
//  FMQrcode.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/7/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "FMQrcode.h"
#import "FMUtils.h"

static NSString * const FM_QRCODE_SEPERATOR = @"|"; //分隔符

@interface FMQrcode ()

@property (readwrite, nonatomic, strong) NSString * qrcode; //原码
@property (readwrite, nonatomic, strong) NSString * functionName;       //模块
@property (readwrite, nonatomic, strong) NSString * subFunctionName;    //子模块
@property (readwrite, nonatomic, strong) NSMutableArray * extandArray;  //自定义信息数组
@property (readwrite, nonatomic, strong) NSString * companyName;        //所属公司

@property (readwrite, nonatomic, assign) BOOL isValid;
@end

@implementation FMQrcode
//初始化
- (instancetype) initWithString:(NSString *) qrcode {
    self = [super init];
    if(self) {
        _qrcode = qrcode;
        [self analysis];
    }
    return self;
}

- (instancetype) initWithQrcode:(FMQrcode *) code {
    self = [super init];
    if(self) {
        _qrcode = [code.qrcode copy];
        _functionName = [code.functionName copy];
        _subFunctionName = [code.subFunctionName copy];
        _extandArray = [code.extandArray copy];
        _companyName = [code.companyName copy];
        
        _isValid = code.isValid;
        [self analysisExtendInfo];
    }
    return self;
}

//解析数据
- (void) analysis {
    if(![FMUtils isStringEmpty:_qrcode]) {
        NSArray * array = [_qrcode componentsSeparatedByString:FM_QRCODE_SEPERATOR];
        NSInteger count = [array count];
        if(count >= 4) { //一个有意义的合法字符串最低包含四组信息
            _isValid = YES;
            _functionName = array[0];
            _subFunctionName = array[1];
            _companyName = array[count-1];
            
            _extandArray = [[NSMutableArray alloc] init];
            for(NSInteger index = 0; index<count-3;index++) {
                NSString * tmp = array[index+2];
                [_extandArray addObject:[tmp copy]];
            }
            [self analysisExtendInfo];
        }
    }
}

//解析自定义信息，子类通过重写本方法来实现自定义属性的解析过程
- (void) analysisExtendInfo {
    
}

//获取原码
- (NSString *) getQrcode {
    return _qrcode;
}

//获取模块值
- (NSString *) getFunction {
    return _functionName;
}

//获取子模块值
- (NSString *) getSubFunction {
    return _subFunctionName;
}

//获取所属公司名字
- (NSString *) getCompany {
    return _companyName;
}

//获取自定义信息
- (NSArray *) getExtandArray {
    return _extandArray;
}

//是否为合法编码
- (BOOL) isValidQrcode {
    return _isValid;
}

- (instancetype) copy {
    FMQrcode * res = [[FMQrcode alloc] init];
    res.qrcode = [_qrcode copy];
    res.functionName = [_functionName copy];
    res.subFunctionName = [_subFunctionName copy];
    res.extandArray = [_extandArray copy];
    res.companyName = [_companyName copy];
    
    res.isValid = _isValid;
    return res;
}
@end
