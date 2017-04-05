//
//  AssetEquipmentDetailEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"
#import <UIKit/UIKit.h>


@interface AssetEquipmentDetailRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber *postId;

- (instancetype)init;
- (instancetype)initWithEquipmentId:(NSNumber *) equipmentId;
- (NSString *)getUrl;
@end

@interface AssetEquipmentDetailQrcodeRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSString * uuid;

- (instancetype) init;
- (instancetype) initWithUUID:(NSString *) uuid;
- (NSString *) getUrl;

@end


@interface AssetEquipmentManufacturer : NSObject  //制造商
@property (readwrite, nonatomic, strong) NSString * phone;  //电话
@property (readwrite, nonatomic, strong) NSString * address; //地址
@property (readwrite, nonatomic, assign) BOOL activated;
@property (readwrite, nonatomic, strong) NSString * contact; //联系人
@property (readwrite, nonatomic, strong) NSString * email;  //
@property (readwrite, nonatomic, strong) NSNumber * vId;  //
@property (readwrite, nonatomic, strong) NSString * name;
@end

@interface AssetEquipmentInstaller : NSObject  //安装商
@property (readwrite, nonatomic, strong) NSString * phone;  //电话
@property (readwrite, nonatomic, strong) NSString * address; //地址
@property (readwrite, nonatomic, assign) BOOL activated;
@property (readwrite, nonatomic, strong) NSString * contact; //联系人
@property (readwrite, nonatomic, strong) NSString * email;  //
@property (readwrite, nonatomic, strong) NSNumber * vId;  //
@property (readwrite, nonatomic, strong) NSString * name;
@end

@interface AssetEquipmentProvider : NSObject  //供应商
@property (readwrite, nonatomic, strong) NSString * phone;  //电话
@property (readwrite, nonatomic, strong) NSString * address; //地址
@property (readwrite, nonatomic, assign) BOOL activated;
@property (readwrite, nonatomic, strong) NSString * contact; //联系人
@property (readwrite, nonatomic, strong) NSString * email;  //
@property (readwrite, nonatomic, strong) NSNumber * vId;  //
@property (readwrite, nonatomic, strong) NSString * name;
@end

@interface AssetEquipmentParams : NSObject
@property (readwrite, nonatomic, strong) NSString * unit;
@property (readwrite, nonatomic, strong) NSString * value;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSNumber * pid;
@property (readwrite, nonatomic, strong) NSString * pDescription;
@end

@interface AssetEquipmentServiceZone : NSObject
@property (readwrite, nonatomic, strong) NSString * zone;
@property (readwrite, nonatomic, strong) NSString * target;
@property (readwrite, nonatomic, strong) NSNumber * szId;
@end

@interface AssetEquipmentCWContract : NSObject   //维修合同
@property (readwrite, nonatomic, strong) NSString * cDescription;
@property (readwrite, nonatomic, strong) NSNumber * startDate;  //开始时间
@property (readwrite, nonatomic, strong) NSString * code;  //合同编码
@property (readwrite, nonatomic, strong) NSNumber * cId;
@property (readwrite, nonatomic, strong) NSString * mVendorName;
@property (readwrite, nonatomic, strong) NSNumber * dueDate; //到期时间
@property (readwrite, nonatomic, strong) NSString * amounts;  //收费
@property (readwrite, nonatomic, strong) NSMutableArray * pictures;  //附件照片
- (instancetype)init;
@end

@interface AssetEquipmentCMContract : NSObject   //维保合同
@property (readwrite, nonatomic, strong) NSString * cDescription;
@property (readwrite, nonatomic, strong) NSNumber * startDate;  //开始时间
@property (readwrite, nonatomic, strong) NSString * code;  //合同编码
@property (readwrite, nonatomic, strong) NSNumber * cId;
@property (readwrite, nonatomic, strong) NSString * mVendorName;
@property (readwrite, nonatomic, strong) NSNumber * dueDate; //到期时间
@property (readwrite, nonatomic, strong) NSString * amounts;  //收费
@property (readwrite, nonatomic, strong) NSMutableArray * pictures;  //附件照片
- (instancetype)init;
@end

@interface AssetEquipmentOtherContract : NSObject  //其他合同
@property (readwrite, nonatomic, strong) NSString * cDescription;
@property (readwrite, nonatomic, strong) NSNumber * startDate;  //开始时间
@property (readwrite, nonatomic, strong) NSString * code;  //合同编码
@property (readwrite, nonatomic, strong) NSNumber * cId;
@property (readwrite, nonatomic, strong) NSString * mVendorName;
@property (readwrite, nonatomic, strong) NSNumber * dueDate; //到期时间
@property (readwrite, nonatomic, strong) NSString * amounts;  //收费
@property (readwrite, nonatomic, strong) NSMutableArray * pictures;  //附件照片
- (instancetype)init;
@end

@interface AssetEquipmentOtherInfo : NSObject
//@property (readwrite, nonatomic, strong) NSString * classify;   //系统分类
@property (readwrite, nonatomic, strong) NSString * productLocation; //产地
@property (readwrite, nonatomic, strong) NSString * count;  //数量
@property (readwrite, nonatomic, strong) NSString * unit;  //单位
@property (readwrite, nonatomic, strong) NSString * desc;  //描述
@property (readwrite, nonatomic, strong) NSString * brandLocation;   //铭牌位置
@property (readwrite, nonatomic, strong) NSNumber * manufactDate;   //出厂日期
@property (readwrite, nonatomic, strong) NSNumber * installDate;  //安装日期
@property (readwrite, nonatomic, strong) NSNumber * startDate;  //启用日期
@property (readwrite, nonatomic, strong) NSNumber * transferDate;  //移交日期
@property (readwrite, nonatomic, strong) NSNumber * deathDate;  //报废时间
@property (readwrite, nonatomic, strong) NSString * designLife;  //设计年限
@property (readwrite, nonatomic, strong) NSString * expectLife;  //预期年限
@property (readwrite, nonatomic, strong) NSString * list;  //设备清单

@end


@interface AssetEquipmentDetailEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber * projectId;  //项目ID
@property (readwrite, nonatomic, strong) NSNumber * eqId;         //设备号
@property (readwrite, nonatomic, strong) NSString * name;   //设备名称
@property (readwrite, nonatomic, strong) NSString * location;  //安装位置
@property (readwrite, nonatomic, strong) AssetEquipmentOtherInfo *otherInfo;  //其他信息
@property (readwrite, nonatomic, strong) NSString * weight;    //重量
@property (readwrite, nonatomic, strong) NSNumber * dateManufactured; //制造日期
@property (readwrite, nonatomic, strong) NSString * code;  //设备编号
@property (readwrite, nonatomic, strong) NSString * life; //使用年限
@property (readwrite, nonatomic, strong) NSString * status;  //状态
@property (readwrite, nonatomic, strong) NSNumber * dateInstalled;  //安装时间
@property (readwrite, nonatomic, strong) NSNumber * dateInService;  //服役时间
@property (readwrite, nonatomic, strong) NSString * brand;   //品牌
@property (readwrite, nonatomic, strong) NSString * qrCodeContent; //二维码内容
@property (readwrite, nonatomic, strong) NSString * eqDescription; //描述
@property (readwrite, nonatomic, strong) NSString * assetCode;  //
@property (readwrite, nonatomic, strong) NSString * sysType;    //
@property (readwrite, nonatomic, strong) NSString * serialNumber; //序列号
@property (readwrite, nonatomic, strong) NSString * model;    //型号
@property (readwrite, nonatomic, strong) NSString * equipmentSystemName; //系统分类名称
@property (readwrite, nonatomic, strong) NSString * bimID;
@property (readwrite, nonatomic, strong) AssetEquipmentManufacturer * manufacturer; //制造商
@property (readwrite, nonatomic, strong) AssetEquipmentInstaller * installer;  //安装商
@property (readwrite, nonatomic, strong) AssetEquipmentProvider * provider; //供应商


@property (readwrite, nonatomic, strong) AssetEquipmentCWContract * cwCntract;  //维修合同
@property (readwrite, nonatomic, strong) NSMutableArray * cmContract;  //维保合同
@property (readwrite, nonatomic, strong) NSMutableArray * otherContract;  //其他合同
@property (readwrite, nonatomic, strong) NSMutableArray * pictureIds; //图片
@property (readwrite, nonatomic, strong) NSMutableArray * params;  //参数
@property (readwrite, nonatomic, strong) NSMutableArray * serviceZones;  //服务区域
@property (readwrite, nonatomic, strong) NSMutableArray * attachmentIds; //附件

- (instancetype)init;

@end


@interface AssetEquipmentResponse : BaseResponse

@property (readwrite, nonatomic, strong) AssetEquipmentDetailEntity * data;

- (instancetype)init;

@end



