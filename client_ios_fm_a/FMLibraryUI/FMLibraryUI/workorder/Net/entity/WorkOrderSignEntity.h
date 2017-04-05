//
//  WorkOrderSignEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"


typedef NS_ENUM(NSInteger, SignatureType) {
    
    WORK_ORDER_SIGNATURE_CUSTOMER = 1,  //客户签字
    WORK_ORDER_SIGNATURE_SUPERVISOR,  //主管签字
};

/**
 *  签字操作
 */
@interface WorkOrderSignRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * woId;   //工单ID
@property (readwrite, nonatomic, assign) SignatureType operateType; //操作类型
@property (readwrite, nonatomic, strong) NSNumber * signImg;   //签字图片ID
@property (readwrite, nonatomic, strong) NSNumber * time;   //签字时间

- (instancetype) initWithWoId:(NSNumber *) woId
                     signType:(SignatureType) operateType
                        imgId:(NSNumber *) imgId
                         time:(NSNumber *) time;
-(NSString *)getUrl;
@end

