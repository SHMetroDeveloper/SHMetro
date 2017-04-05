//
//  UploadConfig.h
//  hello
//
//  Created by 杨帆 on 15/4/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadConfig : NSObject

+ (NSString*) getFileUploadUrl: (NSInteger) orderId token: (NSString*) accessToken;

@end
