//
//  ContractDetailEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"
#import "ContractServerConfig.h"

//合同供应商
@interface ContractProvider : NSObject
@property (readwrite, nonatomic, strong) NSString * name;       //名字
@property (readwrite, nonatomic, strong) NSString * contact;    //联系人
@property (readwrite, nonatomic, strong) NSString * telno;      //联系方式
@end



//合同操作记录
@interface ContractOperationRecord : NSObject
@property (readwrite, nonatomic, strong) NSNumber * time;       //时间
@property (readwrite, nonatomic, strong) NSString * handler;       //名字
@property (readwrite, nonatomic, strong) NSString * operation;    //值
@property (readwrite, nonatomic, strong) NSNumber * photoId;  //头像ID
@property (readwrite, nonatomic, assign) NSInteger type;  //0-创建 1-关闭 2-恢复 3 --- 验收（不通过） 4 --- 验收（通过）5 --- 归档
@property (readwrite, nonatomic, strong) NSMutableArray *attachment;  //操作记录附件 @[ContractAttachment]
@end

//合同附件
@interface ContractAttachment : NSObject
@property (readwrite, nonatomic, strong) NSNumber *fileId;       //附件id
@property (readwrite, nonatomic, strong) NSString *fileName;       //附件名字
@end

//合同动态属性文字
@interface ContractDynamicText : NSObject
@property (readwrite, nonatomic, strong) NSString *name;       //名字
@property (readwrite, nonatomic, strong) NSString *value;    //值
@end

//合同动态属性数字
@interface ContractDynamicNumber : NSObject
@property (readwrite, nonatomic, strong) NSString *name;       //名字
@property (readwrite, nonatomic, strong) NSNumber *value;    //值
@end

//合同动态属性选项
@interface ContractDynamicOption : NSObject
@property (readwrite, nonatomic, strong) NSString *name;       //名字
@property (readwrite, nonatomic, strong) NSMutableArray *value;    //值
@property (readwrite, nonatomic, strong) NSString *select;    //选择的值
@end

//合同动态属性附件
@interface ContractDynamicAttachment : NSObject
@property (readwrite, nonatomic, strong) NSNumber *fileId;
@property (readwrite, nonatomic, strong) NSString *fileName;
@end

//合同动态属性日期
@interface ContractDynamicDate : NSObject
@property (readwrite, nonatomic, strong) NSString *name;
@property (readwrite, nonatomic, strong) NSNumber *value;
@end

//合同自定义字段
@interface ContractDynamic : NSObject
@property (readwrite, nonatomic, strong) NSMutableArray *text;
@property (readwrite, nonatomic, strong) NSMutableArray *number;
@property (readwrite, nonatomic, strong) NSMutableArray *option;
@property (readwrite, nonatomic, strong) NSMutableArray *attachment;
@property (readwrite, nonatomic, strong) NSMutableArray *date;
@end

//合同详情
@interface ContractDetailEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber * contractId; //合同ID
@property (readwrite, nonatomic, strong) NSString * code;       //合同编码
@property (readwrite, nonatomic, strong) NSString * name;       //名字
@property (readwrite, nonatomic, strong) NSString * content;    //合同内容
@property (readwrite, nonatomic, strong) NSString * type;       //合同类型
@property (readwrite, nonatomic, assign) ContractStatusType status;      //合同状态  0 --- 未开始 1 --- 执行中 2 --- 已到期 3 --- 已验收（不通过） 4 --- 已验收（通过） 5 --- 已终止 6 --- 已存档

@property (readwrite, nonatomic, strong) NSString * cost;       //合同金额
@property (readwrite, nonatomic, assign) NSInteger moneyType;   //货币类型
@property (readwrite, nonatomic, strong) NSString * contact;    //业务员
@property (readwrite, nonatomic, strong) NSString * org;        //部门
@property (readwrite, nonatomic, assign) BOOL payment;        //是否为付款
@property (readwrite, nonatomic, strong) NSNumber * createTime; //创建时间
@property (readwrite, nonatomic, strong) NSNumber * startTime;  //开始时间
@property (readwrite, nonatomic, strong) NSNumber * endTime;    //截止时间
@property (readwrite, nonatomic, assign) NSInteger costType;    //付款类型

@property (readwrite, nonatomic, strong) ContractProvider * partyA; //甲方
@property (readwrite, nonatomic, strong) ContractProvider * partyB; //乙方

@property (readwrite, nonatomic, strong) ContractDynamic * dynamic;  //自定义属性
@property (readwrite, nonatomic, strong) NSMutableArray * history;  //操作记录
@property (readwrite, nonatomic, strong) NSMutableArray * attachment;  //附件
@end

// 15.3 合同详情
@interface ContractDetailRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * contractId; //合同ID

- (instancetype) initWithContractId:(NSNumber *) contractId;
-(NSString *)getUrl;
@end


@interface ContractDetailRequestResponse : BaseResponse
@property (readwrite, nonatomic, strong) ContractDetailEntity * data;
@end


