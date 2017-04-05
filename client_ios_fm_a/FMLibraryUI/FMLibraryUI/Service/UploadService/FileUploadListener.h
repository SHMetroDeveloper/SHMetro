//
//  FileUploadListener.h
//  hello
//
//  Created by 杨帆 on 15/4/8.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileUploadListener <NSObject>

- (void) onUploadFileError: (NSURLResponse *) response error: (NSError *) error;
- (void) onUploadFileFinished: (NSURLResponse *) response object: (id) responseObject;

@end
