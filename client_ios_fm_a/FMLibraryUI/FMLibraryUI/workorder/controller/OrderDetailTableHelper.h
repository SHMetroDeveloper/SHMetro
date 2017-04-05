//
//  OrderDetailTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderDetailEntity.h"
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, OrderDetailEventType) {
    WO_DETAIL_EVENT_UNKNOW,
    WO_DETAIL_EVENT_TAKE_CALL,         //打电话
    WO_DETAIL_EVENT_TAKE_PHOTO,         //拍照
    WO_DETAIL_EVENT_CONTENT_ADD,      //工作内容添加
    WO_DETAIL_EVENT_CONTENT_EDIT,      //工作内容编辑
    WO_DETAIL_EVENT_SHOW_PHOTO_ORDER, //工单图片点击
    WO_DETAIL_EVENT_SHOW_PHOTO_REQUIREMENT, //需求图片点击
    WO_DETAIL_EVENT_SHOW_AUDIO_REQUIREMENT, //需求音频点击
    WO_DETAIL_EVENT_SHOW_VIDEO_REQUIREMENT, //需求视频点击
    WO_DETAIL_EVENT_SHOW_ATTACHMENT_REQUIREMENT, //需求附件点击
    WO_DETAIL_EVENT_LABORER_TIME,   //执行人实际到场时间填写
    WO_DETAIL_EVENT_EQUIPMENT_SHOW,   //故障设备展示
    WO_DETAIL_EVENT_EQUIPMENT_ADD,   //故障设备添加
    WO_DETAIL_EVENT_EQUIPMENT_EDIT,   //故障设备编辑
    WO_DETAIL_EVENT_EQUIPMENT_DELETE,   //故障设备删除
    WO_DETAIL_EVENT_TOOL_SHOW,       //工具查看
    WO_DETAIL_EVENT_TOOL_ADD,       //工具添加
    WO_DETAIL_EVENT_TOOL_EDIT,      //工具编辑
    WO_DETAIL_EVENT_TOOL_DELETE,    //工具删除
    WO_DETAIL_EVENT_MATERIAL_SHOW,       //物料查看
    WO_DETAIL_EVENT_HISTORY_RECORD_SHOW,  //历史记录查看
    WO_DETAIL_EVENT_HISTORY_RECORD_PHOTO_SHOW, //历史记录照片查看
    WO_DETAIL_EVENT_MATERIAL_ADD,       //物料添加
    WO_DETAIL_EVENT_MATERIAL_EDIT,      //物料编辑
    WO_DETAIL_EVENT_MATERIAL_DELETE,    //物料删除
    WO_DETAIL_EVENT_STEP_SHOW,      //计划性维护步骤查看
    WO_DETAIL_EVENT_STEP_EDIT,      //计划性维护步骤编辑
    WO_DETAIL_EVENT_CHARGE_SHOW,    //查看
    WO_DETAIL_EVENT_CHARGE_ADD,      //收费明细添加
    WO_DETAIL_EVENT_CHARGE_EDIT,      //收费明细编辑
    WO_DETAIL_EVENT_CHARGE_DELETE,      //收费明细删除
    WO_DETAIL_EVENT_SIGN_SHOW_CUSTOMER, //查看客户签字
    WO_DETAIL_EVENT_SIGN_EDIT_CUSTOMER, //客户签字
    WO_DETAIL_EVENT_SIGN_SHOW_SUPERVISOR, //查看主管签字
    WO_DETAIL_EVENT_SIGN_EDIT_SUPERVISOR, //主管签字
    WO_DETAIL_EVENT_EDIT_FAILURE_REASON,   //编辑故障原因
    WO_DETAIL_EVENT_SHOW_RELATED_ORDER, //查看关联工单
};

@interface OrderDetailTableHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;

//工单信息
- (void) setInfoWith:(WorkOrderDetail *) orderDetail;

//设置是否可编辑
- (void) setEditAble:(BOOL) editable;

- (void) setReadOnly:(BOOL)readOnly;
//判断是否可编辑
- (BOOL) editable;

//设置执行人ID
- (void) setLaborerId:(NSNumber *)laborerId;

//获取当前执行人信息
- (WorkOrderLaborer *) getCurrentLaborerInfo;

//工作内容
- (void) setContent:(NSString *) content;

//获取当前工作内容
- (NSString *) getContent;

//获取图片 url 地址，可以用来获取签字等图片地址
- (NSURL *) getPhotoUrl:(NSNumber *) photoId;

//增加图片
- (void) addPhoto:(NSMutableArray *) photoPath;

//获取音频 url 地址
- (NSURL *) getAudioUrl:(NSNumber *) audioId;

//获取视频 url 地址
- (NSURL *) getVideoUrl:(NSNumber *) videoId;

//获取本地新拍的工作内容图片的路径
- (NSMutableArray *) getPhotosNew;

//获取执行人到达时间
- (NSNumber *) getActualArrivalTime;

//获取执行人完成时间
- (NSNumber *) getActualFinishTime;

//设置实际到达时间---当前执行人
- (void) setActualArrivalTime:(NSNumber *) actualTime;
//设置实际完成时间
- (void) setActualFinishTime:(NSNumber *) actualTime;

//获取工单图片
- (NSMutableArray *) getOrderPhotosArray;

//获取需求图片
- (NSMutableArray *) getRequirementPhoto;

//获取指定位置的音频url
- (NSURL *) getRequirementAudioAtIndex:(NSInteger) index;

//获取指定位置的视频 url
- (NSURL *) getRequirementVideoAtIndex:(NSInteger) index;

//获取指定位置的附件
- (WorkOrderAttachmentItem *) getRequirementAttachmentAtIndex:(NSInteger) index;

//设置工具
- (void) setTools:(NSMutableArray *) tools;
//添加工具
- (void) addTool:(WorkOrderTool *) tool;

//更新工具
- (void) updateTool:(WorkOrderTool *) newTool;

//获取工具列表
- (NSArray *) getTools;

//获取指定位置的工具
- (WorkOrderTool *) getToolAtIndex:(NSInteger) position;

//删除工具
- (void) deleteToolAtIndex:(NSInteger) position;

//设置物料信息
//- (void) setMaterials:(NSMutableArray *)materials;

//设置预定单
- (void) setReservationList:(NSMutableArray *) array;

//获取计划性维护步骤信息
- (NSMutableArray *) getSteps;

//获取工单相关联系人的电话列表
- (NSArray *) getPhoneArray;

//设置收费项
- (void) setCharges:(NSMutableArray *) charges;

//添加收费项
- (void) addCharge:(WorkOrderChargeItem *) charge;

//更新收费项
- (void) updateCharge:(WorkOrderChargeItem *) charge atIndex:(NSInteger) position;

//获取收费项列表
- (NSMutableArray *) getCharges;

//获取指定位置的收费项信息
- (WorkOrderChargeItem *) getChargeAtIndex:(NSInteger) position;

//删除指定位置的收费项
- (void) deleteChargeAtIndex:(NSInteger) position;

//设置故障原因
- (void) setFailureReason:(FailureReason *) reason;

//设置客户签字
- (void) setCustomerSignImg:(UIImage *)customerSignImg;

//设置主管签字
- (void) setSupervisorSignImg:(UIImage *)supervisorSignImg;

//获取物料费用
- (NSNumber *) getMaterialCharge;

//获取总收费
- (NSNumber *) getChargeSum;

//重新加载视频数据
- (void) reloadVideos;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) listener;

@end
