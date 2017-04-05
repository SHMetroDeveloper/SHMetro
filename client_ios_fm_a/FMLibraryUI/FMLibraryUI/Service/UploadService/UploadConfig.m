//
//  UploadConfig.m
//  hello
//
//  Created by 杨帆 on 15/4/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "UploadConfig.h"
#import "SystemConfig.h"


NSString* const FILE_UPLOAD_PATH_WORKORDER = @"WorkOrder";


@implementation UploadConfig

+ (NSString*) getFileUploadUrl: (NSInteger) orderId
                         token: (NSString*) accessToken {
    NSString * url = [[NSString alloc] initWithFormat:@"%@/m/v1/files/upload/picture/%@/%ld/img/?access_token=%@", [SystemConfig getServerAddress], FILE_UPLOAD_PATH_WORKORDER, orderId, accessToken];
    return url;
}

@end
