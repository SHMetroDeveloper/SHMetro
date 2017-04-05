//
//  DemandCommentEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"

typedef NS_ENUM(NSInteger, RequirementOperationType) {
    REQUIREMENT_OPERAITON_TYPE_PASS,      //审核通过
    REQUIREMENT_OPERAITON_TYPE_REJECT,    //审核拒绝
    REQUIREMENT_OPERAITON_TYPE_SAVE,      //保存
    REQUIREMENT_OPERAITON_TYPE_FINISH,    //处理完成
    REQUIREMENT_OPERAITON_TYPE_SATISFACTION,   //满意度操作
} ;

@interface RequirementOperateRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * reqId;   //需求ID
@property (readwrite, nonatomic, strong) NSNumber * gradeId;   //满意度ID
@property (readwrite, nonatomic, strong) NSString * desc;  //待审核时为需求描述；待处理时为处理内容；待评价时为评价内容（评价时不能操作处理内容）
@property (readwrite, nonatomic, assign) NSInteger operateType; // 操作类型

- (instancetype)initWithReqId:(NSNumber *) reqId
                        grade:(NSNumber *) gradeId
                         desc:(NSString *) desc
                  operateType:(NSInteger ) operateType;

- (NSString*) getUrl;

@end




