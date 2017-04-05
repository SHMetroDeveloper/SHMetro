//
//  BaseRequest.h
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : NSObject 

- (NSString *) wrapUrl: (NSString*) requestUrl;
- (NSDictionary *) toJson;
- (NSString *) getUrl;

@end

