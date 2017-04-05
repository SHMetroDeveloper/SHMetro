//
//  ReservationDetailEntity.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import <UIKit/UIKit.h>

//物料
@interface ReservationMaterial : NSObject
@property (readwrite, nonatomic, strong) NSNumber * inventoryId;            //库存ID
@property (readwrite, nonatomic, strong) NSNumber * materialBatchId;        //物料批次ID
@property (readwrite, nonatomic, strong) NSNumber * materialBatchChangeId;  //
@property (readwrite, nonatomic, strong) NSString * materialCode;           //物料编码
@property (readwrite, nonatomic, strong) NSString * materialName;           //物料名称
@property (readwrite, nonatomic, strong) NSString * materialBrand;          //品牌
@property (readwrite, nonatomic, strong) NSString * materialModel;          //型号
@property (readwrite, nonatomic, strong) NSString * materialUnit;           //单位
@property (readwrite, nonatomic, strong) NSNumber * amount;                  //库存数量
@property (readwrite, nonatomic, strong) NSNumber * bookAmount;              //预定数量
@property (readwrite, nonatomic, strong) NSNumber * receiveAmount;           //领用数量
@property (readwrite, nonatomic, strong) NSString * cost;              //单价
@end


//预定详情
@interface ReservationDetailEntity : NSObject

@property (readwrite, nonatomic, strong) NSNumber * activityId;             //预定ID
@property (readwrite, nonatomic, strong) NSString * reservationCode;        //预定编号
@property (readwrite, nonatomic, strong) NSNumber * reservationPersonId;    //预定者编号
@property (readwrite, nonatomic, strong) NSString * reservationPersonName;  //预定者名称
@property (readwrite, nonatomic, strong) NSString * reservationNote;        //预定说明
@property (readwrite, nonatomic, strong) NSNumber * woId;                   //工单ID
@property (readwrite, nonatomic, strong) NSString * woCode;                 //工单编号
@property (readwrite, nonatomic, strong) NSNumber * reservationDate;        //预定日期
@property (readwrite, nonatomic, assign) NSInteger status;                  //预定状态，0-未审核；1-通过（待出库）；2-取消（已驳回） 3已出库 4取消预订
@property (readwrite, nonatomic, strong) NSNumber * warehouseId;            //仓库ID
@property (readwrite, nonatomic, strong) NSString * warehouseName;          //仓库名称
@property (readwrite, nonatomic, strong) NSMutableArray * materials;        //物料列表

@property (readwrite, nonatomic, strong) NSString * receivingPersonName;    //领用者名称
@property (readwrite, nonatomic, strong) NSNumber * receivingDate;          //领用时间
@property (readwrite, nonatomic, strong) NSString * receivingNote;          //领用说明

//仓库管理员
@property (readwrite, nonatomic, strong) NSNumber * administrator;          //仓库管理员
@property (readwrite, nonatomic, strong) NSString * administratorName;      //管理员ID
//主管
@property (readwrite, nonatomic, strong) NSNumber * supervisor;             //主管
@property (readwrite, nonatomic, strong) NSString * supervisorName;         //主管ID

- (instancetype) init;

@end


@interface GetReservationDetailRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * requestId;
- (instancetype) initWith:(NSNumber *) requestId;
- (NSString *) getUrl;
@end


@interface GetReservationDetailResponse : BaseResponse
@property (readwrite, nonatomic, strong) ReservationDetailEntity * data;
@end


