//
//  BaseRequest.m
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseRequest.h"
#import "FMUtils.h"

@implementation BaseRequest

- (NSString *) wrapUrl: (NSString*) requestUrl {
    return requestUrl;
}

- (NSDictionary *) toJson {
    NSDictionary * res = [FMUtils getObjectData:self];
    return res;
}

- (NSString *) getUrl {
    return @"";
}


@end