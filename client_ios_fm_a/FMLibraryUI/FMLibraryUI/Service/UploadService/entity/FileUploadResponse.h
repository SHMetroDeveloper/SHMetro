//
//  FileUploadResponse.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseResponse.h"
#import "MJExtension.h"

@interface FileUploadResponse : BaseResponse

@property (readwrite, nonatomic, strong) NSMutableArray * data;

@end
