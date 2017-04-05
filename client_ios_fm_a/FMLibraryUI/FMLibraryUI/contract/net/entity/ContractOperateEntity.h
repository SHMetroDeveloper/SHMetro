//
//  ContractOperateEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/30.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"

// 15.6 合同操作（关闭，恢复，验收，存档）
@interface ContractOperateRequestParam: BaseRequest
@property (nonatomic, strong) NSNumber *contractId;
@property (nonatomic, assign) NSInteger type;  //0-关闭 1-恢复 2-验收(不通过) 3-验收(通过) 4-存档
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSMutableArray *photos;  //在验收时会用到图片

- (instancetype)init;
- (NSString *)getUrl;
@end


