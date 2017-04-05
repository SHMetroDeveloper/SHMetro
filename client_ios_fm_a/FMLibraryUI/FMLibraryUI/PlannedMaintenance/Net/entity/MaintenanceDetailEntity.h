//
//  MaintenanceDetailEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"

//维护日历请求
@interface MaintenanceDetailRequestParam : BaseRequest

@property (readwrite,nonatomic,strong)NSNumber * postId;
@property (readwrite,nonatomic,strong)NSNumber * todoId;

- (instancetype)initWithPmId:(NSNumber *) postId todoId:(NSNumber *)todoId;
- (NSString*) getUrl;

@end

//维护步骤
@interface MaintenanceDetailStepEntity : NSObject
@property (readwrite,nonatomic,strong) NSString * comment;     //
@property (readwrite,nonatomic,assign) BOOL finished;     //
@property (readwrite,nonatomic,strong) NSString * step;     //步骤
@property (readwrite,nonatomic,strong) NSString * workTeamName; //工作组名称
@property (readwrite,nonatomic,assign) NSInteger sort;      //步骤序号
@property (readwrite,nonatomic,strong) NSNumber* woId;      //
@property (readwrite,nonatomic,strong) NSNumber* pmSId;      //
@end


//维护物料
@interface MaintenanceDetailMaterialEntity : NSObject
@property (readwrite,nonatomic,strong) NSNumber * pmmId;     //
@property (readwrite,nonatomic,strong) NSString * materialId;     //
@property (readwrite,nonatomic,strong) NSString * name;     //物料名称
@property (readwrite,nonatomic,strong) NSString * brand;     //品牌
@property (readwrite,nonatomic,strong) NSString * model;    //型号
@property (readwrite,nonatomic,strong) NSNumber * price;    //价格
@property (readwrite,nonatomic,strong) NSNumber * unit;    //价格
@property (readwrite,nonatomic,assign) NSInteger amount;    //数量
@property (readwrite,nonatomic,strong) NSString * comment;
@property (readwrite,nonatomic,strong) NSString * mpComment;
@end

//维护工具
@interface MaintenanceDetailToolEntity : NSObject
@property (readwrite,nonatomic,strong) NSString * pmtId;     //
@property (readwrite,nonatomic,strong) NSString * name;     //名称
@property (readwrite,nonatomic,strong) NSString * model;    //型号
@property (readwrite,nonatomic,strong) NSString* unit;    //
@property (readwrite,nonatomic,assign) NSInteger amount;    //
@property (readwrite,nonatomic,strong) NSString * comment;
@end

//维护设备
@interface MaintenanceDetailEquipmentEntity : NSObject
@property (readwrite,nonatomic,strong) NSNumber * eqId;     //
@property (readwrite,nonatomic,strong) NSString * code;     //编码
@property (readwrite,nonatomic,strong) NSString * name;    //名称
@property (readwrite,nonatomic,strong) NSString * sysType;     //编码
@property (readwrite,nonatomic, strong) NSString* eqSystemName;    //系统分类
@property (readwrite,nonatomic, strong) NSString* location; //位置
@end

//位置
@interface MaintenanceDetailLocationEntity : NSObject
@property (readwrite,nonatomic,strong) NSString * location;   //
@property (readwrite,nonatomic,strong) NSString * pmsId;    //
@end

//工单
@interface MaintenanceDetailOrderEntity : NSObject
@property (readwrite,nonatomic,strong) NSString * code;   //
@property (readwrite,nonatomic,strong) NSNumber * woId;    //
@property (readwrite,nonatomic,strong) NSNumber * priorityId;
@property (readwrite,nonatomic,strong) NSString * applicantName;
@property (readwrite,nonatomic,strong) NSString * location;
@property (readwrite,nonatomic,assign) NSInteger status;
@property (readwrite,nonatomic,strong) NSString * applicantPhone;
@property (readwrite,nonatomic,strong) NSNumber* createDateTime;
@property (readwrite,nonatomic,strong) NSNumber* actualCompletionDateTime;
@property (readwrite,nonatomic,strong) NSString* woDescription;
@property (readwrite,nonatomic,strong) NSString* workContent;;
@property (readwrite,nonatomic,strong) NSString* serviceTypeName;
@property (readwrite,nonatomic,strong) NSNumber * currentLaborerStatus;
@end

@interface MaintenanceDetailAttachmentEntity : NSObject
@property (nonatomic, strong) NSNumber *fileId;
@property (nonatomic, strong) NSString *fileName;
@end

//维护详情
@interface MaintenanceDetailEntity : NSObject
@property (readwrite,nonatomic,strong) NSNumber *pmId;//
@property (readwrite,nonatomic,strong) NSString *name;//维保名字
@property (readwrite,nonatomic,assign) NSInteger status;//状态
@property (readwrite,nonatomic,assign) NSInteger priority;//状态
@property (readwrite,nonatomic,strong) NSString *influence;//维保影响
@property (readwrite,nonatomic,strong) NSString *period;//周期
@property (readwrite,nonatomic,strong) NSNumber *dateFirstTodo;//首次维保
@property (readwrite,nonatomic,strong) NSNumber *dateNextTodo;//下次维保时间
@property (readwrite,nonatomic,strong) NSString *estimatedWorkingTime;//预估耗时
@property (readwrite,nonatomic,assign) BOOL autoGenerateOrder;//是否自动生成工单
@property (readwrite,nonatomic,assign) BOOL genStatus;//是否生成工单
@property (readwrite,nonatomic,strong) NSNumber *ahead;//提前天数

@property (readwrite,nonatomic,strong) NSMutableArray * pmSteps;     //计划步骤
@property (readwrite,nonatomic,strong) NSMutableArray * pmMaterials; //物料
@property (readwrite,nonatomic,strong) NSMutableArray * pmTools;     //工具
@property (readwrite,nonatomic,strong) NSMutableArray * equipments;  //设备
@property (readwrite,nonatomic,strong) NSMutableArray * spaces;      //位置
@property (readwrite,nonatomic,strong) NSMutableArray * workOrders;  //工单
@property (readwrite,nonatomic,strong) NSMutableArray * pictures;    //附件
//@property (readwrite,nonatomic,strong) NSMutableArray * attachment; //附件

@end


//网络请求结果
@interface MaintenanceDetailResponse : BaseResponse
@property ( nonatomic, strong) MaintenanceDetailEntity * data;
@end
