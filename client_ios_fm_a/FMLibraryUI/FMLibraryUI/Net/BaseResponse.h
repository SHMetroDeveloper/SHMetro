//
//  BaseResponse.h
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseResponse : NSObject

@property ( nonatomic, assign) NSInteger fmcode;
@property ( nonatomic, strong) NSString* message;

//初始化， 需要在本方法中指定 data 类型（实例化）
- (instancetype) init;
@end