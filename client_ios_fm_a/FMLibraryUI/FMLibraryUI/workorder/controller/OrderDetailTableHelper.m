//
//  OrderDetailTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "OrderDetailTableHelper.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "WorkOrderDetailCommonItemView.h"
#import "WorkOrderDetailContentItemView.h"
#import "WorkOrderDetailEquipmentItemView.h"
#import "WorkOrderDetailToolItemView.h"
#import "WorkOrderDetailPlannedStepItemView.h"

#import "WorkOrderDetailHistoryRecordItemView.h"  //设置历史记录
#import "WorkOrderDetailHistoryRecordView.h"

#import "BaseLabelView.h"
#import "WorkOrderDetailLaborerItemView.h"
#import "WorkOrderDetailMaterialItemView.h"
#import "SeperatorView.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "PhotoItem.h"
#import "GrabOrderContentItemView.h"
#import "FMTheme.h"
#import "MarkedListHeaderView.h"
#import "WorkOrderDetailSignItemView.h"
#import "WorkContentHeaderView.h"
#import "FMFont.h"
#import "BasePhotoView.h"
#import "BaseDataDbHelper.h"

#import "WorkOrderDetailChargeItemView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "HorizontalFlowLayout.h"
#import "BaseItemView.h"

typedef enum {
    SECTION_TYPE_UNKNOW,
    SECTION_TYPE_APPROVAL_CONTENT,//审批内容
    SECTION_TYPE_COMMON,    //基本信息
    SECTION_TYPE_CONTENT,   //工作内容
    SECTION_TYPE_WORK_HISTORY,   //工作历史
    SECTION_TYPE_LABORER,   //执行人
    SECTION_TYPE_DEVICE,    //设备
    SECTION_TYPE_FAILURE_REASON,    //故障原因
    SECTION_TYPE_TOOL,      //工具
    SECTION_TYPE_PLAN_STEP, //计划性维护步骤
    SECTION_TYPE_ATTACHMENT,   //附件
    SECTION_TYPE_HISTORY,   //历史记录
    SECTION_TYPE_MATERIAL,  //物料
    SECTION_TYPE_CHARGE,     //收费明细
    SECTION_TYPE_SIGN_CUSTOMER,       //车站值班员签字
    SECTION_TYPE_SIGN_SUPERVISOR,       //主管签字
    SECTION_TYPE_RELATED_ORDER       //关联工单
} WorkJobListSection;

//工单详情图片类型
typedef NS_ENUM(NSInteger, WorkOrderDetailImageType) {
    WO_DETAIL_IMAGE_UNKNOW,      //
    WO_DETAIL_IMAGE_PHOTO_ORDER,      //工单图片
    WO_DETAIL_IMAGE_PHOTO,      //图片
    WO_DETAIL_IMAGE_AUDIO,      //音频
    WO_DETAIL_IMAGE_VIDEO,      //视频
    WO_DETAIL_IMAGE_ATTACHMENT, //附件
};


@interface OrderDetailTableHelper () <OnItemClickListener, OnClickListener, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) WorkOrderDetailContentItemView * contentItemView;
@property (readwrite, nonatomic, strong) WorkOrderDetailContentItemView * historyItemView;

@property (readwrite, nonatomic, strong) GrabOrderContentItemView * grabContentView;

@property (readwrite, nonatomic, strong) BasePhotoView * picItemView;//工单图片

@property (readwrite, nonatomic, strong) BasePhotoView * photoItemView; //需求图片
@property (readwrite, nonatomic, strong) BasePhotoView * audioItemView; //需求音频
@property (readwrite, nonatomic, strong) BasePhotoView * videoItemView; //需求视频


@property (readwrite, nonatomic, strong) NSNumber * orderId;
@property (readwrite, nonatomic, strong) NSNumber * approvalId; //审批ID，供审核工单使用
@property (readwrite, nonatomic, strong) NSNumber * laborerId;
@property (readwrite, nonatomic, assign) NSInteger currentLaborerIndex; //当前执行人位置

@property (readwrite, nonatomic, strong) WorkOrderDetail * jobDetail;
//@property (readwrite, nonatomic, strong) NSMutableArray * materials;
@property (readwrite, nonatomic, strong) NSMutableArray * reservationArray;
@property (readwrite, nonatomic, strong) NSString * desc;   //操作说明
@property (readwrite, nonatomic, strong) UIImage * customerSignImg;   //值班人员签字    //本地签字
@property (readwrite, nonatomic, strong) UIImage * supervisorSignImg;   //主管签字

@property (readwrite, nonatomic, assign) CGFloat approvalContentItemHeight;
@property (readwrite, nonatomic, assign) CGFloat commonItemHeight;
@property (readwrite, nonatomic, assign) CGFloat historyItemHeight;
@property (readwrite, nonatomic, assign) CGFloat contentItemHeight;
@property (readwrite, nonatomic, assign) CGFloat photoItemHeight;
@property (readwrite, nonatomic, assign) CGFloat expandItemHeight;  //展开按钮高度
@property (readwrite, nonatomic, assign) CGFloat laborerItemHeight;
@property (readwrite, nonatomic, assign) CGFloat audioItemHeight;  //展开按钮高度
@property (readwrite, nonatomic, assign) CGFloat videoItemHeight;  //展开按钮高度

@property (readwrite, nonatomic, assign) CGFloat toolItemHeight;
@property (readwrite, nonatomic, assign) CGFloat materialItemHeight;
@property (readwrite, nonatomic, assign) CGFloat chargeItemHeight;
@property (readwrite, nonatomic, assign) CGFloat signItemHeight;


@property (readwrite, nonatomic, strong) NSString * workContent;    //工作内容

@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat footerHeight;
@property (readwrite, nonatomic, assign) CGFloat cameraItemHeight;
@property (readwrite, nonatomic, assign) CGFloat orderItemHeight;
@property (readwrite, nonatomic, strong) NSMutableArray * tmpImgPathArray;
@property (readwrite, nonatomic, strong) NSMutableArray * tmpImgArray;

@property (readwrite, nonatomic, strong) NSMutableArray * thumbPhotos;  //图片缩略图
@property (readwrite, nonatomic, strong) NSMutableArray * audioThumbPhotos;  //录音缩略图
@property (readwrite, nonatomic, strong) NSMutableArray * videoThumbPhotos;  //视频缩略图

@property (readwrite, nonatomic, strong) NSMutableArray * tmpApprovalContentArray;

@property (readwrite, nonatomic, strong) NSMutableArray *attachmentArray;

@property (readwrite, nonatomic, assign) NSInteger curToolIndex;    //当前正在编辑的工具的位置
@property (readwrite, nonatomic, assign) NSInteger curStepIndex;    //当前正在编辑的步骤的位置

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;   //列表项中分割线的边距
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL editable; //是否可以添加删除数据
@property (readwrite, nonatomic, assign) BOOL readOnly; //只读，历史记录
@property (readwrite, nonatomic, assign) BOOL expand; //是否展开基本数据
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation OrderDetailTableHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        
        _approvalContentItemHeight = 50;
        _commonItemHeight = 240;
        _historyItemHeight = 100;
        _contentItemHeight = 100;
        _laborerItemHeight = 90;
        _toolItemHeight = 140;
        _materialItemHeight = 140;
        _photoItemHeight = 132;
        _audioItemHeight = 132;
        _videoItemHeight = 132;
        
        _cameraItemHeight = 40;
        _chargeItemHeight = 90;
        _signItemHeight = 60;
        _expandItemHeight = 40;
        _orderItemHeight = 50;
        
        _editable = NO;
        
        _headerHeight = [FMSize getInstance].listHeaderHeight;
        _footerHeight = [FMSize getInstance].listFooterHeight;
        _tmpImgPathArray = [[NSMutableArray alloc] init];
        _tmpImgArray = [[NSMutableArray alloc] init];
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
        _tmpApprovalContentArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//是否显示待审批内容
- (BOOL) needShowApproval {
    BOOL res = NO;
    if(_jobDetail.status == ORDER_STATUS_APPROVE) { //待审核的工单
        res = YES;
    }
    return res;
}

//是否需要显示执行人
- (BOOL) needShowLaborer {
    BOOL res = NO;
    if([_jobDetail.workOrderLaborers count] > 0) { //
        res = YES;
    }
    return res;
}

//是否显示故障设备
- (BOOL) needShowEquipment {
    BOOL res = NO;
    if([_jobDetail.workOrderEquipments count] > 0 || _jobDetail.status == ORDER_STATUS_PROCESS) {  //有故障设备或者处理中的工单
        res = YES;
    }
    return res;
}
//是否显示故障原因
- (BOOL) needShowFailureReason {
    BOOL res = NO;
    if(![FMUtils isStringEmpty:_jobDetail.failueDescription] || _jobDetail.status == ORDER_STATUS_PROCESS) {  //有故障原因或者处理中的工单
        res = YES;
    }
    return res;
}

//是否显示计划性维护步骤
- (BOOL) needShowStep {
    BOOL res = NO;
    if([_jobDetail.steps count] > 0) {  //有维护步骤的工单
        res = YES;
    }
    return res;
}

//是否显示工作历史
- (BOOL) needShowWorkHistory {
    BOOL res = NO;
    return res;
}

//是否显示工具信息
- (BOOL) needShowTool {
    BOOL res = NO;
    if(_editable || [_jobDetail.workOrderTools count] > 0) {
        res = YES;
    }
    return res;
}

//是否显示工具信息
- (BOOL) needShowMaterial {
    BOOL res = NO;
    if(_editable || [_reservationArray count] > 0) {
        res = YES;
    }
    return res;
}

//是否显示收费明细信息
- (BOOL) needShowCharge {
    BOOL res = NO;
    if(_editable || [_jobDetail.charges count] > 0) {
        res = YES;
    }
    return res;
}

//是否显示客户签字
- (BOOL) needShowSignCustomer {
    BOOL res = NO;
    if(_editable || _jobDetail.customerSignImgId) {//已签，或者处于处理中的工单需要展示
        res = YES;
    }
    return res;
}

//是否显示主管签字
- (BOOL) needShowSignSupervisor {
    BOOL res = NO;
    if(_jobDetail.supervisorSignImgId || (!_readOnly && (_jobDetail.status == ORDER_STATUS_TERMINATE || _jobDetail.status == ORDER_STATUS_FINISH))) { //已签或者处理完成和终止状态的工单需要展示
        res = YES;
    }
    return res;
}

//是否显示附件栏
- (BOOL) needShowAttachment {
    BOOL res = NO;
    if(_jobDetail.attachment && _jobDetail.attachment.count > 0) {
        res = YES;
    } else if (_jobDetail.histories) {
        for (WorkOrderHistoryItem *hitoryItem in _jobDetail.histories) {
            if (hitoryItem.attachment && hitoryItem.attachment.count > 0) {
                res = YES;
                break;
            }
        }
    }
    return res;
}

//是否需要展示关联工单
- (BOOL) needShowRelatedOrder {
    BOOL res = NO;
    if(_jobDetail.relatedOrder && [_jobDetail.relatedOrder count] > 0) {
        res = YES;
    }
    return res;
}

//初始化附件内容信息
- (void) initAttachmentDetail {
    if (!_attachmentArray) {
        _attachmentArray = [NSMutableArray new];
    } else {
        [_attachmentArray removeAllObjects];
    }
    
    if (_jobDetail.attachment && _jobDetail.attachment.count > 0) {
        [_attachmentArray addObjectsFromArray:_jobDetail.attachment];
    }
    if (_jobDetail.histories && _jobDetail.histories.count > 0) {
        for (WorkOrderHistoryItem *historyItem in _jobDetail.histories) {
            if (historyItem.attachment && historyItem.attachment.count > 0) {
                [_attachmentArray addObjectsFromArray:historyItem.attachment];
            }
        }
    }
}

//初始化审批内容信息
- (void) initApprovalContent {
    if(!_tmpApprovalContentArray) {
        _tmpApprovalContentArray = [[NSMutableArray alloc] init];
    } else {
        [_tmpApprovalContentArray removeAllObjects];
    }
    
    BOOL isOK = NO;
    if(_jobDetail.approvals && [_jobDetail.approvals count] > 0) {
        for(WorkOrderApprovalItem * dic in _jobDetail.approvals) {
            isOK = NO;
            NSArray * approvalResults = dic.approvalResults;
            NSNumber * dicResult;
            for(ApprovalResult * tmpresult in approvalResults) {
                dicResult = tmpresult.result;
                if(!dicResult) {
                    isOK = YES;
                    break;
                }
            }
            if(!isOK) { //如果对应的审批结果不为空的话就是曾经审批过的内容，不用显示
                continue;
            }
            NSMutableArray * contents = dic.approvalContent;
            for(ApprovalContentItem * item in contents) {
                ApprovalContentItem * content = [[ApprovalContentItem alloc] init];
                content.name = [item valueForKeyPath:@"name"];
                content.value = [item valueForKeyPath:@"value"];
                [_tmpApprovalContentArray addObject:content];
            }
        }
        
    }
}

- (void) initVideos {
    [self getVideoPhotosArray];
}

//重新加载视频数据
- (void) reloadVideos {
    [self initVideos];
}

- (void) setInfoWith:(WorkOrderDetail *) orderDetail {
    _jobDetail = orderDetail;
    [self initApprovalContent];
    [self initAttachmentDetail];
    [self initVideos];
}


//设置是否可编辑
- (void) setEditAble:(BOOL) editable {
    _editable = editable;
}

- (void) setReadOnly:(BOOL)readOnly {
    _readOnly = readOnly;
}

//判断是否可编辑
- (BOOL) editable {
    return _editable;
}

- (void) setLaborerId:(NSNumber *)laborerId {
    _laborerId = laborerId;
}

//工作内容
- (void) setContent:(NSString *) content {
    _workContent = content;
}

//获取当前工作内容
- (NSString *) getContent {
    return _workContent;
}

//增加图片
- (void) addPhoto:(NSMutableArray *) photoPath {
    if(photoPath) {
        [_tmpImgPathArray addObjectsFromArray:photoPath];
    }
}


//获取本地新拍的工作内容图片
- (NSMutableArray *) getPhotosNew {
    return _tmpImgPathArray;
}

//获取当前执行人信息
- (WorkOrderLaborer *) getCurrentLaborerInfo {
    WorkOrderLaborer * laborer;
    if(_laborerId && _jobDetail) {
        if(_currentLaborerIndex >=0 && _currentLaborerIndex < [_jobDetail.workOrderLaborers count]) {
            laborer = _jobDetail.workOrderLaborers[_currentLaborerIndex];
        } else {
            NSInteger index = 0;
            for(WorkOrderLaborer * obj in _jobDetail.workOrderLaborers) {
                if(obj.laborerId && [obj.laborerId isEqualToNumber:_laborerId]) {
                    _currentLaborerIndex = index;
                    laborer = obj;
                    break;
                }
                index++;
            }
        }
    }
    return laborer;
}

//获取执行人到达时间
- (NSNumber *) getActualArrivalTime {
    WorkOrderLaborer * laborer = [self getCurrentLaborerInfo];
    NSNumber * time = laborer.actualArrivalDateTime;
    return time;
}

//设置实际到达时间---当前执行人
- (void) setActualArrivalTime:(NSNumber *) actualTime {
    WorkOrderLaborer * laborer = [self getCurrentLaborerInfo];
    laborer.actualArrivalDateTime = actualTime;
}

//获取执行人完成时间
- (NSNumber *) getActualFinishTime {
    WorkOrderLaborer * laborer = [self getCurrentLaborerInfo];
    NSNumber * time = laborer.actualCompletionDateTime;
    return time;
}

//设置实际完成时间
- (void) setActualFinishTime:(NSNumber *) actualTime {
    WorkOrderLaborer * laborer = [self getCurrentLaborerInfo];
    laborer.actualCompletionDateTime = actualTime;
}

//设置工具
- (void) setTools:(NSMutableArray *) tools {
    _jobDetail.workOrderTools = tools;
}

//添加工具
- (void) addTool:(WorkOrderTool *) tool {
    [_jobDetail.workOrderTools addObject:tool];
}


- (void) updateTool:(WorkOrderTool *) newTool {
    if(_curToolIndex >= 0 && _curToolIndex < [_jobDetail.workOrderTools count]) {
        _jobDetail.workOrderTools[_curToolIndex] = newTool;
    }
}

//获取工具列表
- (NSArray *) getTools {
    NSMutableArray * array = _jobDetail.workOrderTools;
    return array;
}

//获取指定位置的工具
- (WorkOrderTool *) getToolAtIndex:(NSInteger) position {
    WorkOrderTool * tool;
    if(position >= 0 && position < [_jobDetail.workOrderTools count]) {
        tool = _jobDetail.workOrderTools[position];
    }
    return tool;
}

//删除工具
- (void) deleteToolAtIndex:(NSInteger) position {
    if(position >= 0 && position < [_jobDetail.workOrderTools count]) {
        [_jobDetail.workOrderTools removeObjectAtIndex:position];
    }
}

//- (void) setMaterials:(NSMutableArray *)materials {
//    _materials = materials;
//}

- (void) setReservationList:(NSMutableArray *) array {
    _reservationArray = array;
}

//获取计划性维护步骤信息
- (NSMutableArray *) getSteps {
    return _jobDetail.steps;
}

//获取工单相关联系人的电话列表
- (NSArray *) getPhoneArray {
    NSString * strPhone = _jobDetail.applicantPhone;
    NSArray * tmpArray = [strPhone componentsSeparatedByString:@"/"];
    NSMutableArray * phones = [[NSMutableArray alloc] init];
    for(NSString * item in tmpArray) {
        if(![FMUtils isStringEmpty:item]) {
            NSString * strItem = [item stringByReplacingOccurrencesOfString:@" " withString:@""];
            [phones addObject:strItem];
        }
    }
    return phones;
}

//设置收费项
- (void) setCharges:(NSMutableArray *) charges {
    _jobDetail.charges =  charges;
}

//添加收费项
- (void) addCharge:(WorkOrderChargeItem *) charge {
    [_jobDetail.charges addObject:charge];
}

//更新收费项
- (void) updateCharge:(WorkOrderChargeItem *) charge atIndex:(NSInteger) position {
    if(position >= 0 && position < [_jobDetail.charges count]) {
        _jobDetail.charges[position] = charge;
    }
}

//获取收费项列表
- (NSMutableArray *) getCharges {
    NSMutableArray * array = _jobDetail.charges;
    return array;
}

//获取指定位置的收费项信息
- (WorkOrderChargeItem *) getChargeAtIndex:(NSInteger) position {
    WorkOrderChargeItem * charge;
    if(position >= 0 && position < [_jobDetail.charges count]) {
        charge = _jobDetail.charges[position];
    }
    return charge;
}

//删除指定位置的收费项
- (void) deleteChargeAtIndex:(NSInteger) position {
    if(position >= 0 && position < [_jobDetail.charges count]) {
        [_jobDetail.charges removeObjectAtIndex:position];
    }
}

- (void) setFailureReason:(FailureReason *) reason {
    _jobDetail.failueDescription = reason.name;
}

- (WorkOrderDetailImageType) getImageTypeOfCommonSectionInPosition:(NSInteger) position {
    WorkOrderDetailImageType type = WO_DETAIL_IMAGE_UNKNOW;
    if(position >= 1 && [self getOrderImageCount] == 0) {
        position += 1;
    }
    if(position >= 2 && [self getThumbImageCount] == 0) {
        position += 1;
    }
    if(position >= 3 && [self getAudioThumbImageCount] == 0) {
        position += 1;
    }
    if(position >= 4 && [self getVideoThumbImageCount] == 0) {
        position += 1;
    }
    switch (position) {
        case 1:
            type = WO_DETAIL_IMAGE_PHOTO_ORDER;
            break;
        case 2:
            type = WO_DETAIL_IMAGE_PHOTO;
            break;
        case 3:
            type = WO_DETAIL_IMAGE_AUDIO;
            break;
        case 4:
            type = WO_DETAIL_IMAGE_VIDEO;
            break;
        default:
            break;
    }
    return type;
};

//获取需求图片
- (NSMutableArray *) getRequirementPhoto {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(NSNumber * photoId in _jobDetail.requirementPictures) {
        NSURL * url = [self getPhotoUrl:photoId];
        [array addObject:url];
    }
    return array;
}

- (NSURL *) getRequirementAudioAtIndex:(NSInteger) index {
    NSURL * url;
    if(index >= 0 && index < [self getAudioThumbImageCount]) {
        NSNumber * audioId = _jobDetail.requirementAudios[index];
        url = [self getAudioUrl:audioId];
    }
    return url;
}

- (NSURL *) getRequirementVideoAtIndex:(NSInteger) index {
    NSURL * url;
    if(index >= 0 && index < [self getVideoThumbImageCount]) {
        NSNumber * videoId = _jobDetail.requirementVideos[index];
        url = [self getVideoUrl:videoId];
    }
    return url;
}

- (WorkOrderAttachmentItem *) getRequirementAttachmentAtIndex:(NSInteger) index {
    WorkOrderAttachmentItem *attachment;
    if(index >= 0 && index < [self getAttachmentCount]) {
        attachment = _attachmentArray[index];
    }
    return attachment;
}

//设置客户签字
- (void) setCustomerSignImg:(UIImage *)customerSignImg {
//    _customerSignImg = customerSignImg;
}

//设置主管签字
- (void) setSupervisorSignImg:(UIImage *)supervisorSignImg {
//    _supervisorSignImg = supervisorSignImg;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)listener {
    _handler = listener;
}

- (void) notifyEvent:(OrderDetailEventType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithInteger:type] forKeyPath:@"eventType"];
        [result setValue:data forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

- (NSURL *) getPhotoUrl:(NSNumber *) photoId {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * strUrl = [WorkOrderServerConfig wrapPictureUrlById:accessToken photoId:photoId];
    NSURL * url = [NSURL URLWithString:strUrl];
    return url;
}

- (NSURL *) getVideoUrl:(NSNumber *) videoId {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * strUrl = [WorkOrderServerConfig wrapVideoUrlById:accessToken videoId:videoId];
    NSURL * url = [NSURL URLWithString:strUrl];
    return url;
}

- (NSURL *) getAudioUrl:(NSNumber *) audioId {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * strUrl = [WorkOrderServerConfig wrapAudioUrlById:accessToken audioId:audioId];
    NSURL * url = [NSURL URLWithString:strUrl];
    return url;
}


- (NSInteger) getPhotoCount {
    NSInteger count = 0;
    if(_jobDetail) {
//        count += [_jobDetail.pictures count];
    }
    count += [_tmpImgPathArray count];
    return count;
}


- (NSMutableArray *) getPhotoArray {
    NSMutableArray * photoArray = [[NSMutableArray alloc] init];
    if(_tmpImgPathArray) {
        for(NSString * path in _tmpImgPathArray) {
            [photoArray addObject:(path)];
        }
    }
    
    return photoArray;
}


////获取需求图片
//- (NSMutableArray *) getRequirementPhotosArray {
//    NSMutableArray * photoArray = [[NSMutableArray alloc] init];
//    if(_jobDetail) {
//        for(NSNumber * videoId in _jobDetail.requirementAudios) {
//            NSURL * url = [self getAudioUrl:videoId];
//            UIImage * img = [UIImage imageNamed:@"file_audio"];
//            PhotoItem * item = [[PhotoItem alloc] init];
//            [item setImage:img];
//            [item setOrigin:PHOTO_ORIGIN_AUDIO];
//            [item setOriginUrl:url];
//            [photoArray addObject:item];
//        }
//        for(NSNumber * videoId in _jobDetail.requirementVideos) {
//            NSURL * url = [self getVideoUrl:videoId];
//            UIImage * img = [FMUtils thumbnailWithAssetUrl:url time:1];
//            PhotoItem * item = [[PhotoItem alloc] init];
//            [item setImage:img];
//            [item setOrigin:PHOTO_ORIGIN_VIDEO];
//            [item setOriginUrl:url];
//            [photoArray addObject:item];
//        }
//        
//        for(NSNumber * videoId in _jobDetail.requirementShortVideos) {
//            NSURL * url = [self getVideoUrl:videoId];
//            UIImage * img = [FMUtils thumbnailWithAssetUrl:url time:1];
//            PhotoItem * item = [[PhotoItem alloc] init];
//            [item setImage:img];
//            [item setOrigin:PHOTO_ORIGIN_VIDEO];
//            [item setOriginUrl:url];
//            if(img) {
//                [photoArray addObject:item];
//            }
//            
//        }
//        
//        for(NSNumber * photoId in _jobDetail.requirementPictures) {
//            NSURL * url = [self getPhotoUrl:photoId];
//            PhotoItem * item = [[PhotoItem alloc] init];
//            [item setUrl:url];
//            [item setOrigin:PHOTO_ORIGIN_IMAGE];
//            [item setOriginUrl:url];
//            [photoArray addObject:item];
//        }
//    }
//    return photoArray;
//}

- (NSInteger) getOrderImageCount {
    NSInteger count = 0;
    if(_jobDetail) {
        count += [_jobDetail.pictures count];
    }
    return count;
}

//获取缩略图数量，包括音视频
- (NSInteger) getThumbImageCount {
    NSInteger count = 0;
    if(_jobDetail) {
        count += [_jobDetail.requirementPictures count];
    }
    return count;
}

- (NSInteger) getAudioThumbImageCount {
    NSInteger count = 0;
    if (_jobDetail) {
        count += [_jobDetail.requirementAudios count];
    }
    return count;
}

- (NSInteger) getVideoThumbImageCount {
    NSInteger count = 0;
    if (_jobDetail) {
        count += [_jobDetail.requirementVideos count];
    }
    return count;
}

//获取工单图片
- (NSMutableArray *) getOrderPhotosArray {
    NSMutableArray * photoArray = [[NSMutableArray alloc] init];
    if(_jobDetail) {
        NSInteger tag = 0;
        for(NSNumber * photoId in _jobDetail.pictures) {
            NSURL * url = [self getPhotoUrl:photoId];
            PhotoItem * item = [[PhotoItem alloc] init];
            [item setUrl:url];
            [item setOrigin:PHOTO_ORIGIN_IMAGE];
            [item setOriginUrl:url];
            [photoArray addObject:item];
            tag++;
        }
    }
    return photoArray;
}

//获取需求图片
- (NSMutableArray *) getRequirementPhotosArray {
    NSMutableArray * photoArray = [[NSMutableArray alloc] init];
    if(_jobDetail) {
        NSInteger tag = 0;
        for(NSNumber * photoId in _jobDetail.requirementPictures) {
            NSURL * url = [self getPhotoUrl:photoId];
            PhotoItem * item = [[PhotoItem alloc] init];
            [item setUrl:url];
            [item setOrigin:PHOTO_ORIGIN_IMAGE];
            [item setOriginUrl:url];
            [photoArray addObject:item];
            tag++;
        }
    }
    return photoArray;
}

- (NSMutableArray *) getAudioPhotosArray {
    NSMutableArray * photoArray = [[NSMutableArray alloc] init];
    if(_jobDetail) {
        NSInteger tag = 0;
        for(NSNumber * audioId in _jobDetail.requirementAudios) {
            //            NSURL * url = [self getAudioUrl:videoId];
            UIImage * img = [[FMTheme getInstance] getImageByName:@"audio_icon_sep"];
            PhotoItem * item = [[PhotoItem alloc] init];
            [item setImage:img];
            [item setOrigin:PHOTO_ORIGIN_AUDIO];
            //            [item setOriginUrl:url];
//            if(img) {
//                [photoArray addObject:img];
//            }
            [photoArray addObject:item];
            tag++;
        }
    }
    return photoArray;
}

- (NSMutableArray *) getVideoPhotosArray {
    if(!_videoThumbPhotos) {
        _videoThumbPhotos = [[NSMutableArray alloc] init];
    } else {
        [_videoThumbPhotos removeAllObjects];
    }
    if(_jobDetail) {
        NSInteger tag = 0;
        for(NSNumber * videoId in _jobDetail.requirementVideos) {
            NSURL * url = [self getVideoUrl:videoId];
            //                        UIImage * img = [FMUtils thumbnailWithAssetUrl:url time:1];
            PhotoItem * item = [[PhotoItem alloc] init];
            //                        [item setImage:img];
            [self getVideoImageAsyn:url time:1 tag:tag];
            [item setOrigin:PHOTO_ORIGIN_VIDEO];
            [item setOriginUrl:url];
            [_videoThumbPhotos addObject:item];
            tag++;
        }
    }
    return _videoThumbPhotos;
}

- (void) getVideoImageAsyn:(NSURL *) url time:(CGFloat) time tag:(NSInteger) tag{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        CMTime thumbTime = CMTimeMakeWithSeconds(time,600);
        
        AVAssetImageGeneratorCompletionHandler handler =
        ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
            if (result != AVAssetImageGeneratorSucceeded) {
                NSLog(@"截取图片失败。");
            } else {
                NSLog(@"截取图片成功。");
                UIImage *thumbImg = [UIImage imageWithCGImage:im];
                if(thumbImg) {
                    [self getVideoImageSuccess:thumbImg tag:tag];
                }
            }
        };
        
        [generator generateCGImagesAsynchronouslyForTimes:
         [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    });
}

- (void) getVideoImageSuccess:(UIImage *) image tag:(NSInteger) tag {
    if(!_videoThumbPhotos) {
        _videoThumbPhotos = [[NSMutableArray alloc] init];
    }
    if(tag > 0 && tag > [_videoThumbPhotos count]) {
        NSInteger index = [_videoThumbPhotos count];
        for(; index<tag; index++) {
            PhotoItem * item = [[PhotoItem alloc] init];
            [_videoThumbPhotos addObject:item];
        }
    }
    PhotoItem * item = _videoThumbPhotos[tag];
    [item setImage:image];
    [self performSelectorOnMainThread:@selector(updateVideoPhotos) withObject:nil waitUntilDone:NO];
}

- (void) updateVideoPhotos {
    [_videoItemView setPhotosWithArray:_videoThumbPhotos];
}


//获取签名个数
- (NSInteger) getSignCount {
    NSInteger count = 0;
    if([self customerSigned]) {
        count += 1;
    }
    if([self supervisorSigned]) {
        count += 1;
    }
    return count;
}

//判断客户是否签字
- (BOOL) customerSigned {
    BOOL res = NO;
    if(_jobDetail.customerSignImgId) {
        res = YES;
    }
    return res;
}

//判断主管是否签字
- (BOOL) supervisorSigned {
    BOOL res = NO;
    if(_jobDetail.supervisorSignImgId) {
        res = YES;
    }
    return res;
}


//获取物料费用
- (NSNumber *) getToolCharge {
    NSNumber * charge;
    
    CGFloat amount = 0;
    NSNumber * tmpNumber;
    if([_jobDetail.workOrderTools count] > 0) {
        for(WorkOrderTool * tool in _jobDetail.workOrderTools) {
            if(tool.cost) {
                tmpNumber = [FMUtils stringToNumber:tool.amount];
                amount += (tool.cost.floatValue * tmpNumber.floatValue);
            }
        }
    }
    charge = [NSNumber numberWithFloat:amount];
    return charge;
}

//获取物料费用
- (NSNumber *) getMaterialCharge {
    NSNumber * charge;
    
    CGFloat amount = 0;
    NSNumber * tmpNumber;
    
    if([_jobDetail.workOrderTools count] > 0) {
        for(WorkOrderTool * tool in _jobDetail.workOrderTools) {
            if(tool.cost) {
                tmpNumber = [FMUtils stringToNumber:tool.amount];
                amount += (tool.cost.floatValue * tmpNumber.floatValue);
            }
        }
    }
    charge = [NSNumber numberWithFloat:amount];
    return charge;
}

//获取总收费
- (NSNumber *) getChargeSum {
    NSNumber * sum;
    
    CGFloat amount = 0;
    if([_jobDetail.charges count] > 0) {
        for(WorkOrderChargeItem * charge in _jobDetail.charges) {
            if(charge.amount) {
                amount += charge.amount.floatValue;
            }
        }
    }
    sum = [NSNumber numberWithFloat:amount];
    return sum;
}

- (NSString *) getLocationDesc {
    NSString * res = @"";
    if(_jobDetail) {
        res = [[BaseDataDbHelper getInstance] getLocationBy:_jobDetail.locationId];
        if([FMUtils isStringEmpty:res]) {
            res = _jobDetail.location;
        }
    }
    return res;
}

//注意此方法不能随意修改，除非了解计算思想
- (WorkJobListSection) getSectionType:(NSInteger) section {
    WorkJobListSection sectionType = SECTION_TYPE_UNKNOW;
    if(section >=1 && ![self needShowApproval]) {   //如果不需要显示审批内容，则忽略
        section += 1;
    }
    if (section >= 2 && ![self needShowWorkHistory]) {//如果不需要显示工作历史则忽略
        section += 1;
    }
    if(section >= 3 && ![self needShowLaborer]) {   //如果不需要显示执行人则忽略
        section += 1;
    }
    if(section >= 4 && ![self needShowEquipment]) { //如果不需要显示故障设备则忽略
        section += 1;
    }
    if(section >= 5 && ![self needShowFailureReason]) {//如果不需要故障原因
        section += 1;
    }
    if(section >= 6 && ![self needShowStep]) { //如果不需要维护步骤
        section += 1;
    }
    if(section >= 7 && ![self needShowMaterial]) {//如果不需要展示物料则忽略
        section += 1;
    }
    if(section >= 8 && ![self needShowTool]) {//如果不需要展示工具则忽略
        section += 1;
    }
    if(section >= 9 && ![self needShowCharge]) {//如果不需要展示收费明细则忽略
        section += 1;
    }
    if(section >= 10 && ![self needShowSignCustomer]) {//如果不需要展示客户签字则忽略
        section += 1;
    }
    if(section >= 11 && ![self needShowSignSupervisor]) {//如果不需要展示主管签字则忽略
        section += 1;
    }
    if(section >= 12 && ![self needShowAttachment]) {//如果不需要展示附件则忽略
        section += 1;
    }
    if(section >= 13 && ![self needShowRelatedOrder]) {//如果不需要展示关联工单
        section += 1;
    }
    
    switch(section) {   //如果所有的项全部都显示则按下面的顺序展示
        case 0:
            sectionType = SECTION_TYPE_COMMON;
            break;
        case 1:
            sectionType = SECTION_TYPE_APPROVAL_CONTENT;
            break;
        case 2:
            sectionType = SECTION_TYPE_WORK_HISTORY;
            break;
        case 3:
            sectionType = SECTION_TYPE_LABORER;
            break;
        case 4:
            sectionType = SECTION_TYPE_DEVICE;
            break;
        case 5:
            sectionType = SECTION_TYPE_FAILURE_REASON;
            break;
        case 6:
            sectionType = SECTION_TYPE_PLAN_STEP;
            break;
        case 7:
            sectionType = SECTION_TYPE_MATERIAL;
            break;
        case 8:
            sectionType = SECTION_TYPE_TOOL;
            break;
        case 9:
            sectionType = SECTION_TYPE_CHARGE;
            break;
        case 10:
            sectionType = SECTION_TYPE_SIGN_CUSTOMER;
            break;
        case 11:
            sectionType = SECTION_TYPE_SIGN_SUPERVISOR;
            break;
        case 12:
            sectionType = SECTION_TYPE_ATTACHMENT;
            break;
        case 13:
            sectionType = SECTION_TYPE_RELATED_ORDER;
            break;
        case 14:
            sectionType = SECTION_TYPE_HISTORY;
            break;

        default:
            sectionType = SECTION_TYPE_UNKNOW;
            break;
    }
    return sectionType;
}

- (NSInteger) getCommonItemCount {
    NSInteger count = 2;    //基本信息和展开按钮
    if(_expand && [self getOrderImageCount] > 0) {
        count += 1;
    }
    if(_expand && [self getThumbImageCount] > 0) {
        count += 1;
    }
    if(_expand && [self getAudioThumbImageCount] > 0) {
        count += 1;
    }
    if(_expand && [self getVideoThumbImageCount] > 0) {
        count += 1;
    }
    return count;
}

- (NSInteger) getAttachmentCount {
    NSInteger count = 0;
    if(_jobDetail.attachment && _jobDetail.attachment.count > 0) {
        count += _jobDetail.attachment.count;
    }
    if (_jobDetail.histories && _jobDetail.histories.count > 0) {
        for (WorkOrderHistoryItem *hitoryItem in _jobDetail.histories) {
            if (hitoryItem.attachment && hitoryItem.attachment.count > 0) {
                count += hitoryItem.attachment.count;
            }
        }
    }
    
    return count;
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    NSInteger count = 2; //基本信息，历史记录
    if([self needShowApproval]) {   //审批内容
        count += 1;
    }
    if([self needShowLaborer]) {
        count += 1;
    }
    if([self needShowWorkHistory]) {//工作历史
        count += 1;
    }
    if([self needShowEquipment]) {  //故障设备
        count += 1;
    }
    if([self needShowFailureReason]) {//故障原因
        count += 1;
    }
    if([self needShowStep]) {   //维护步骤
        count += 1;
    }
    if([self needShowTool]) {   //工具
        count += 1;
    }
    if([self needShowMaterial]) {   //物料
        count += 1;
    }
    if([self needShowCharge]) { //收费明细
        count += 1;
    }
    if([self needShowSignCustomer]) {   //客户签字
        count += 1;
    }
    if([self needShowAttachment]) {   //附件
        count += 1;
    }
    if([self needShowSignSupervisor]) { //主管签字
        count += 1;
    }
    if([self needShowRelatedOrder]) {//关联工单
        count += 1;
    }
    return count;
}


- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    WorkJobListSection sectionType = [self getSectionType:section];
    switch(sectionType) {
        case SECTION_TYPE_APPROVAL_CONTENT:
            count = [_tmpApprovalContentArray count] + 1;
            break;
        case SECTION_TYPE_COMMON:
            count = [self getCommonItemCount];
            count += 1; //footer
            break;
        case SECTION_TYPE_CONTENT:
            count = 1;  //footer
            if(![FMUtils isStringEmpty:_workContent]) {
                count += 1;
            }
            if([self getPhotoCount] > 0) {
                count += 1;
            }
            break;
        case SECTION_TYPE_WORK_HISTORY:
            count = 1;
            //            if(![FMUtils isStringEmpty:_jobDetail.workContent]) {
            //                count += 1;
            //            }
            break;
        case SECTION_TYPE_LABORER:
            count = [_jobDetail.workOrderLaborers count] + 1;
            break;
        case SECTION_TYPE_DEVICE:
            count = 1;
            break;
        case SECTION_TYPE_FAILURE_REASON:
            count = 1;
            break;
        case SECTION_TYPE_TOOL:
            count = 1;
            if([self needShowCharge]) { //跟收费明细相邻的时候不要分隔
                count = 0;
            }
            break;
        case SECTION_TYPE_PLAN_STEP:
            count = 1;
            break;
        case SECTION_TYPE_MATERIAL:
            count = 1;
            break;
        case SECTION_TYPE_HISTORY:
            count = 1;  //1个footer
            if([_jobDetail.histories count] > 0) {
                count += 2; //1个view、1个立即查看
            }
            break;
        case SECTION_TYPE_CHARGE:
            count = 1;
            break;
        case SECTION_TYPE_SIGN_CUSTOMER:
            count = 1;
            if([self needShowSignSupervisor]) {
                count = 0;
            }
            break;
            
        case SECTION_TYPE_SIGN_SUPERVISOR:
            count = 1;
            break;
            
        case SECTION_TYPE_ATTACHMENT:
            count = [self getAttachmentCount];
            count += 1;
            break;
        case SECTION_TYPE_RELATED_ORDER:
            count = [_jobDetail.relatedOrder count] + 1;
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    CGFloat width = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    width = CGRectGetWidth(tableView.frame);
    CGFloat paddingLeft = [FMSize getInstance].listItemPaddingLeft;
    WorkJobListSection sectionType = [self getSectionType:section];
    NSString * approvalContent;
    if([self needShowApproval]) {
        approvalContent = [_jobDetail getApprovalContent];
        if(!approvalContent) {
            approvalContent = @"";
        }
    }
    switch(sectionType) {
        case SECTION_TYPE_APPROVAL_CONTENT:
            height = _footerHeight;
            if(position >=0 && position < [_tmpApprovalContentArray count]) {
                ApprovalContentItem *item = _tmpApprovalContentArray[position];
                NSString *name = item.name;
                NSString *value = item.value;
                if(!name) {
                    name = @"";
                }
                if(!value) {
                    value = @"";
                }
                NSString *content = [[NSString alloc] initWithFormat:@"%@:%@", name, value];
                height = [BaseLabelView calculateHeightByInfo:content
                                                font:nil
                                                desc:@""
                                           labelFont:nil
                                       andLabelWidth:0
                                            andWidth:width];
//                height = _approvalContentItemHeight;
            }
            break;
        case SECTION_TYPE_COMMON:
            
            height = _footerHeight;
            if(position == 0) {
                height = [WorkOrderDetailCommonItemView calculateHeightByLocation:[self getLocationDesc] andDesc:_jobDetail.woDescription org:_jobDetail.organizationName serviceType:_jobDetail.serviceTypeName andWidth:width andPaddingLeft:paddingLeft andPaddingRight:paddingLeft expand:_expand];
            } else if(position == [self getCommonItemCount] - 1) {  //展开按钮
                height = _expandItemHeight;
            } else if(_expand && [self getCommonItemCount] > 2) {
                WorkOrderDetailImageType type = [self getImageTypeOfCommonSectionInPosition:position];
                switch(type) {
                    case WO_DETAIL_IMAGE_PHOTO_ORDER:
                        height = [BasePhotoView calculateHeightByCount:[self getOrderImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                        break;
                    case WO_DETAIL_IMAGE_PHOTO:
                        height = [BasePhotoView calculateHeightByCount:[self getThumbImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                        break;
                    case WO_DETAIL_IMAGE_AUDIO:
                        height = [BasePhotoView calculateHeightByCount:[self getAudioThumbImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                        break;
                    case WO_DETAIL_IMAGE_VIDEO:
                        height = [BasePhotoView calculateHeightByCount:[self getVideoThumbImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                        break;
                    default:
                        break;
                }
            }
            break;
        case SECTION_TYPE_CONTENT:
            height = _footerHeight;
            if([self getPhotoCount] > 0 && position == 0) {
                height = _photoItemHeight;
            } else {
                if(![FMUtils isStringEmpty:_workContent]) {
                    if(([self getPhotoCount] > 0 && position == 1) || ([self getPhotoCount] == 0 && position == 0)) {
                        height = [WorkOrderDetailContentItemView calculateHeightByContent:_workContent andWidth:width andPaddingLeft:paddingLeft andPaddingRight:paddingLeft];
                    }
                }
            }
            break;
        case SECTION_TYPE_WORK_HISTORY:
            height = _footerHeight;
            if([_jobDetail.histories count] > 0) {
                if(position == 0) {
                    WorkOrderHistoryItem * hitem = [_jobDetail.histories lastObject];
                    height = [WorkOrderDetailHistoryRecordView calculateHeightByInfo:hitem.content photoCount:[hitem.pictures count] andWidth:width];
                } if (position == 1) {
                    height = [FMSize getSizeByPixel:150];
                }
            }
            break;
        case SECTION_TYPE_LABORER:
            height = _footerHeight;
            if(position < [_jobDetail.workOrderLaborers count]) {
                height = _laborerItemHeight;
            }
            break;
        case SECTION_TYPE_DEVICE:
            height = _footerHeight;
            break;
        case SECTION_TYPE_FAILURE_REASON:
            height = _footerHeight;
            break;
            
        case SECTION_TYPE_TOOL:
            height = _footerHeight;
            
            break;
        case SECTION_TYPE_PLAN_STEP:
            height = _footerHeight;
            
            break;
        case SECTION_TYPE_MATERIAL:
            height = _footerHeight;
            break;
        case SECTION_TYPE_HISTORY:
            height = _footerHeight;
            if([_jobDetail.histories count] > 0) {
                if(position == 0) {
                    WorkOrderHistoryItem * hitem = [_jobDetail.histories lastObject];
                    height = [WorkOrderDetailHistoryRecordView calculateHeightByInfo:hitem.content photoCount:[hitem.pictures count] andWidth:width];
                } if (position == 1) {
                    height = [FMSize getSizeByPixel:150];
                }
            }
            
            break;
        case SECTION_TYPE_CHARGE:
            height = _footerHeight;
            break;
        case SECTION_TYPE_SIGN_CUSTOMER:
            height = _footerHeight;
            break;
        case SECTION_TYPE_SIGN_SUPERVISOR:
            height = _footerHeight;
            break;
            
        case SECTION_TYPE_ATTACHMENT:
            if (position < [self getAttachmentCount]) {
                height = _approvalContentItemHeight;
            } else {
                height = _footerHeight;
            }
            break;
        case SECTION_TYPE_RELATED_ORDER:
            if(position < [_jobDetail.relatedOrder count]) {
                height = _orderItemHeight;
            } else {
                height = _footerHeight;
            }
            break;
        default:
            break;
    }
    return (NSInteger)height;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    WorkJobListSection sectionType = [self getSectionType:section];
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell* cell = nil;
    BaseLabelView * approvalContentItemView = nil;
    WorkOrderDetailCommonItemView * commonItemView = nil;
    BaseLabelView * commonExpandItemView = nil;
//    WorkOrderDetailEquipmentItemView * deviceItemView = nil;
    WorkOrderDetailLaborerItemView * laborerItemView = nil;
    BasePhotoView * photoItemView = nil;
    BaseItemView *orderItemView;
    WorkOrderDetailHistoryRecordView * historyItemView = nil;
    
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    BOOL isFooter = NO;
    BOOL isPhoto = NO;
    CGFloat itemHeight = 0;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat paddingLeft = [FMSize getInstance].listItemPaddingLeft;
    NSString * approvalContent;
    if([self needShowApproval]) {
        approvalContent = [_jobDetail getApprovalContent];
        if(!approvalContent) {
            approvalContent = @"";
        }
    }
    switch(sectionType) {
        case SECTION_TYPE_APPROVAL_CONTENT: //审批内容
            if(position < [_tmpApprovalContentArray count]) {
                cellIdentifier = @"CellApprovalContent";
                
                ApprovalContentItem *item = _tmpApprovalContentArray[position];
                NSString *name = item.name;
                NSString *value = item.value;
                if(!name) {
                    name = @"";
                }
                if(!value) {
                    value = @"";
                }
                NSString *content = [[NSString alloc] initWithFormat:@"%@:%@", name, value];
                itemHeight = [BaseLabelView calculateHeightByInfo:content
                                                         font:nil
                                                         desc:@""
                                                    labelFont:nil
                                                andLabelWidth:0
                                                     andWidth:width];
                
//                itemHeight = _approvalContentItemHeight;
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[BaseLabelView class]]) {
                            approvalContentItemView = view;
                        }
                        if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *) view;
                        }
                    }
                }
                if(cell && !approvalContentItemView) {
                    approvalContentItemView = [[BaseLabelView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [approvalContentItemView setLabelText:@"" andLabelWidth:0];
                    [cell addSubview:approvalContentItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    [cell addSubview:seperator];
                } else {
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                }
                if([_tmpApprovalContentArray count] > 0) {
                    [seperator setHidden:YES];
                } else {
                    [seperator setHidden:NO];
                }
                if(approvalContentItemView) {
                    approvalContentItemView.tag = position;
                    ApprovalContentItem * item = _tmpApprovalContentArray[position];
                    NSString * name = item.name;
                    NSString * value = item.value;
                    if(!name) {
                        name = @"";
                    }
                    if(!value) {
                        value = @"";
                    }
                    NSString * content = [[NSString alloc] initWithFormat:@"%@:%@", name, value];
                    [approvalContentItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [approvalContentItemView setContent:content];
                }
            } else {
                isFooter = YES;
            }
            break;
        case SECTION_TYPE_COMMON:           //基本信息
            if(position == 0) {
                cellIdentifier = @"CellCommon";
                itemHeight = [WorkOrderDetailCommonItemView calculateHeightByLocation:[self getLocationDesc] andDesc:_jobDetail.woDescription org:_jobDetail.organizationName serviceType:_jobDetail.serviceTypeName andWidth:width andPaddingLeft:paddingLeft andPaddingRight:paddingLeft expand:_expand];
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[WorkOrderDetailCommonItemView class]]) {
                            commonItemView = view;
                            break;
                        }
                    }
                }
                
                if(cell && !commonItemView) {
                    commonItemView = [[WorkOrderDetailCommonItemView alloc] init];
                    [commonItemView setPaddingLeft:paddingLeft andPaddingRight:paddingLeft];
                    [commonItemView setOnItemClickListener:self];
                    [cell addSubview:commonItemView];
                }
                
                if(commonItemView) {
                    commonItemView.tag = position;
                    [commonItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [commonItemView setExpand:_expand];
                    [commonItemView setInfoWithCreateTime:[_jobDetail getCreateTimeStr]
                                                  contact:[_jobDetail getContact]
                                                    telno:_jobDetail.applicantPhone
                                                      org:[_jobDetail getOrgStr]
                                              serviceType:_jobDetail.serviceTypeName
                                                 location:[self getLocationDesc]
                                         estimateTime:[_jobDetail getEstimateTimeStr]
                                         reserveTime:[_jobDetail getReserveTimeStr]
                                                     desc:_jobDetail.woDescription priority:_jobDetail.priorityId.longLongValue status:_jobDetail.status];
                    
                }
            } else if(_expand && [self getCommonItemCount] > 2 && position < [self getCommonItemCount] - 1) {
                NSMutableArray * photos;
                WorkOrderDetailImageType type = [self getImageTypeOfCommonSectionInPosition:position];
                BasePhotoView * tmpItemView;
                switch(type) {
                    case WO_DETAIL_IMAGE_PHOTO_ORDER:
                        itemHeight = [BasePhotoView calculateHeightByCount:[self getOrderImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                        tmpItemView = _picItemView;
                        cellIdentifier = @"CellPhotoOrder";
                        break;
                    case WO_DETAIL_IMAGE_PHOTO:
                        itemHeight = [BasePhotoView calculateHeightByCount:[self getThumbImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                        tmpItemView = _photoItemView;
                        cellIdentifier = @"CellPhoto";
                        break;
                    case WO_DETAIL_IMAGE_AUDIO:
                        itemHeight = [BasePhotoView calculateHeightByCount:[self getAudioThumbImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                        [_audioItemView setPaddingTop:20 paddingBottom:20];
                        tmpItemView = _audioItemView;
                        cellIdentifier = @"CellAudio";
                        break;
                    case WO_DETAIL_IMAGE_VIDEO:
                        itemHeight = [BasePhotoView calculateHeightByCount:[self getVideoThumbImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                        tmpItemView = _videoItemView;
                        cellIdentifier = @"CellVideo";
                        break;
                    default:
                        break;
                }
                
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if(tmpItemView) {
                        [cell addSubview:tmpItemView];
                    }
                }
                if(cell && !tmpItemView) {
                    switch(type) {
                        case WO_DETAIL_IMAGE_PHOTO_ORDER:
                            photos = [self getOrderPhotosArray];
                            itemHeight = [BasePhotoView calculateHeightByCount:[self getOrderImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                            if(!_picItemView) {
                                _picItemView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                                _picItemView.tag = WO_DETAIL_IMAGE_PHOTO_ORDER;
                                [_picItemView setEnableAdd:NO];
                                [_picItemView setEditable:NO];
                                [_picItemView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
                                [_picItemView setOnMessageHandleListener:self];
                            }
                            tmpItemView = _picItemView;
                            cellIdentifier = @"CellPhotoOrder";
                            break;
                        case WO_DETAIL_IMAGE_PHOTO:
                            photos = [self getRequirementPhotosArray];
                            itemHeight = [BasePhotoView calculateHeightByCount:[self getThumbImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                            if(!_photoItemView) {
                                _photoItemView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                                _photoItemView.tag = WO_DETAIL_IMAGE_PHOTO;
                                [_photoItemView setEnableAdd:NO];
                                [_photoItemView setEditable:NO];
                                [_photoItemView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
                                [_photoItemView setOnMessageHandleListener:self];
                            }
                            tmpItemView = _photoItemView;
                            cellIdentifier = @"CellPhoto";
                            break;
                        case WO_DETAIL_IMAGE_AUDIO:
                            photos = [self getAudioPhotosArray];
                            itemHeight = [BasePhotoView calculateHeightByCount:[self getAudioThumbImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                            if(!_audioItemView) {
                                _audioItemView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                                _audioItemView.tag = WO_DETAIL_IMAGE_AUDIO;
                                [_audioItemView setEnableAdd:NO];
                                [_audioItemView setEditable:NO];
                                [_audioItemView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
                                [_audioItemView setOnMessageHandleListener:self];
                            }
                            tmpItemView = _audioItemView;
                            cellIdentifier = @"CellAudio";
                            break;
                        case WO_DETAIL_IMAGE_VIDEO:
                            photos = [self getVideoPhotosArray];
                            itemHeight = [BasePhotoView calculateHeightByCount:[self getVideoThumbImageCount] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                            if(!_videoItemView) {
                                _videoItemView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                                _videoItemView.tag = WO_DETAIL_IMAGE_VIDEO;
                                [_videoItemView setOnMessageHandleListener:self];
                                [_videoItemView setEnableAdd:NO];
                                [_videoItemView setEditable:NO];
                                [_videoItemView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
                            }
                            tmpItemView = _videoItemView;
                            cellIdentifier = @"CellVideo";
                            break;
                        default:
                            break;
                    }
                    [tmpItemView setPhotosWithArray:photos];
                    [cell addSubview:tmpItemView];
                }
                if(tmpItemView) {
                    [tmpItemView setEditable:NO]; //需求图片不允许编辑
                }
            } else if(position == [self getCommonItemCount] - 1) {
                cellIdentifier = @"CellCommonExpand";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                itemHeight = _expandItemHeight;
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[BaseLabelView class]]) {
                            commonExpandItemView = view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = view;
                        }
                    }
                }
                
                if(cell && !commonExpandItemView) {
                    commonExpandItemView = [[BaseLabelView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    
                    [commonExpandItemView setContentAlignment:NSTextAlignmentCenter];
                    [commonExpandItemView setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
                    [commonExpandItemView setContentFont:[FMFont fontWithSize:15]];
                    [cell addSubview:commonExpandItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    [seperator setFrame:CGRectMake(0, 0, width, seperatorHeight)];
                }
                if(commonExpandItemView) {
                    commonExpandItemView.tag = SECTION_TYPE_COMMON;
                    NSString * strTitle;
                    if(_expand) {
                        strTitle= [[BaseBundle getInstance] getStringByKey:@"order_detail_expand" inTable:nil];
                    } else {
                        strTitle= [[BaseBundle getInstance] getStringByKey:@"order_detail_expand" inTable:nil];
                    }
                    [commonExpandItemView setContent:strTitle];
                }
                
            }
            else {
                isFooter = YES;
            }
            break;
        case SECTION_TYPE_CONTENT:           //工作内容
            if([self getPhotoCount] > 0 && position == 0) {
                isPhoto = YES;
            } else {
                if(![FMUtils isStringEmpty:_workContent]) {
                    if(([self getPhotoCount] > 0 && position == 1) || ([self getPhotoCount] == 0&&  position == 0)) {
                        cellIdentifier = @"CellContent";
                        itemHeight = [WorkOrderDetailContentItemView calculateHeightByContent:_workContent andWidth:width andPaddingLeft:paddingLeft andPaddingRight:paddingLeft];
                        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                        if(!cell) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            //                            if(![_jobDetail hasPhoto]) {
                            //                                seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                            //                                [cell addSubview:seperator];
                            //                            }
                            
                        } else {
                            NSArray * subViews = [cell subviews];
                            for(id view in subViews) {
                                if([view isKindOfClass:[WorkOrderDetailContentItemView class]]) {
                                    _contentItemView = view;
                                }
                                //                                else if ([view isKindOfClass:[SeperatorView class]]) {
                                //                                    seperator = (SeperatorView *) view;
                                //                                }
                            }
                        }
                        if(cell && !_contentItemView) {
                            _contentItemView = [[WorkOrderDetailContentItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                            [_contentItemView setPaddingLeft:paddingLeft andPaddingRight:paddingLeft];
                            
                            [cell addSubview:_contentItemView];
                        }
                        if(cell && seperator){
                            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                        }
                        if(_contentItemView) {
                            _contentItemView.tag = position;
                            [_contentItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                            [_contentItemView setInfoWithContent:_workContent];
                        }
                    } else {
                        isFooter = YES;
                    }
                } else {
                    isFooter = YES;
                }
            }
            
            if(isPhoto) {
                cellIdentifier = @"CellPhoto";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[BasePhotoView class]]) {
                            photoItemView = view;
                            break;
                        }
                    }
                }
                if(cell && !photoItemView) {
                    photoItemView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, width, _photoItemHeight)];
                    [photoItemView setEditable:_editable];
                    [photoItemView setOnMessageHandleListener:self];
                    [photoItemView setEnableAdd:NO];
                    [photoItemView setEditable:NO];
                    [photoItemView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
                    [cell addSubview:photoItemView];
                }
                if(photoItemView) {
                    photoItemView.tag = SECTION_TYPE_CONTENT;
                    NSMutableArray * photos = [self getPhotoArray];
                    [photoItemView setPhotosWithArray:photos];
                    //                    [photoItemView update];
                }
            }
            break;
        case SECTION_TYPE_WORK_HISTORY:           //工作历史
            break;
        case SECTION_TYPE_LABORER:      //执行人信息
            if(position < [_jobDetail.workOrderLaborers count]) {
                WorkOrderLaborer * laborer = _jobDetail.workOrderLaborers[position];
                itemHeight = _laborerItemHeight;
                cellIdentifier = @"CellLaborer";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[WorkOrderDetailLaborerItemView class]]) {
                            laborerItemView = view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *) view;
                        }
                    }
                }
                if(cell && !laborerItemView) {
                    laborerItemView = [[WorkOrderDetailLaborerItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [laborerItemView setPaddingLeft:paddingLeft andPaddingRight:paddingLeft];
                    [cell addSubview:laborerItemView];
                    
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [_jobDetail.workOrderLaborers count] - 1) {
                        [seperator setDotted:YES];
                        [seperator setFrame:CGRectMake(_paddingLeft, itemHeight-seperatorHeight, width-_paddingLeft-_paddingRight, seperatorHeight)];
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(laborerItemView) {
                    laborerItemView.tag = position;
                    if(_editable) {
                        if([_laborerId isEqualToNumber:laborer.laborerId]) {
                            _currentLaborerIndex = position;
                            [laborerItemView setOnClickListener:self];
                            [laborerItemView setEditable:YES];
                        } else {
                            [laborerItemView setOnClickListener:nil];
                            [laborerItemView setEditable:NO];
                        }
                    }
                    [laborerItemView setInfoWithName:laborer.laborer
                                            position:laborer.positionName
                                               telno:laborer.phone
                                          arriveTime:[laborer getArriveDateStr]
                                          finishTime:[laborer getFinishDateStr]
                                              status:laborer.status
                                         responsible:laborer.responsible];
                }
            } else {
                isFooter = YES;
            }
            
            break;
        case SECTION_TYPE_DEVICE:           //设备信息
            isFooter = YES;
            break;
        case SECTION_TYPE_FAILURE_REASON://故障原因
            isFooter = YES;
            break;
        case SECTION_TYPE_TOOL:           //工具信息
            isFooter = YES;
            break;
            
        case SECTION_TYPE_PLAN_STEP:
            isFooter = YES;
            break;
        case SECTION_TYPE_MATERIAL:           //物料信息
            isFooter = YES;
            break;
        case SECTION_TYPE_HISTORY:           //历史记录
            isFooter = YES;
            if([_jobDetail.histories count] > 0) {
                if(position == 0) {
                    isFooter = NO;
                    cellIdentifier = @"CellHistory";
                    WorkOrderHistoryItem * hitem = [_jobDetail.histories lastObject];
                    itemHeight = [WorkOrderDetailHistoryRecordView calculateHeightByInfo:hitem.content photoCount:[hitem.pictures count] andWidth:width];
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if(!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    } else {
                        NSArray * subViews = [cell subviews];
                        for(id view in subViews) {
                            if([view isKindOfClass:[WorkOrderDetailHistoryRecordView class]]) {
                                historyItemView = view;
                            } else if([view isKindOfClass:[SeperatorView class]]) {
                                seperator = (SeperatorView *) view;
                            }
                        }
                    }
                    if(cell && !historyItemView) {
                        historyItemView = [[WorkOrderDetailHistoryRecordView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                        [historyItemView setOnMessageHandleListener:self];
                        [cell addSubview:historyItemView];
                    }
                    if(cell && !seperator) {
                        seperator = [[SeperatorView alloc] init];
                        [cell addSubview:seperator];
                    }
                    if(seperator) {
                        [seperator setDotted:YES];
                        [seperator setFrame:CGRectMake(_paddingLeft, itemHeight-seperatorHeight, width-_paddingLeft-_paddingRight, seperatorHeight)];
                    }
                    if(historyItemView) {
                        [historyItemView setInfoWithIndex:(position + 1) time:hitem.operationDate operater:hitem.handler step:hitem.step content:hitem.content andPhotos:hitem.pictures];
                        [historyItemView setPortraitImageID:hitem.handlerImgId];
                        historyItemView.tag = position;
                    }
                } else if (position == 1) {     //查看全部按钮
                    isFooter = NO;
                    cellIdentifier = @"CellShowMore";
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                        cell.textLabel.font = [FMFont fontWithSize:15];
                        cell.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
                        cell.textLabel.text = [[BaseBundle getInstance] getStringByKey:@"cell_show_all_detail" inTable:nil];
                        
                        CGFloat imgWidth = 18;
                        UIImageView * moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(width-imgWidth-_paddingLeft, (cell.frame.size.height - imgWidth)/2, imgWidth, imgWidth)];
                        moreImg.image = [[FMTheme getInstance] getImageByName:@"slim_more"];
                        
                        [cell addSubview:moreImg];
                    }
                }
            }
            break;
        case SECTION_TYPE_CHARGE:
            isFooter = YES;
            break;
        case SECTION_TYPE_SIGN_CUSTOMER:
            isFooter = YES;
            break;
        case SECTION_TYPE_SIGN_SUPERVISOR:
            isFooter = YES;
            break;
            
        case SECTION_TYPE_ATTACHMENT:
            if([self getAttachmentCount] > 0 && position < [self getAttachmentCount]) {
                //附件
                WorkOrderAttachmentItem * attachment = _attachmentArray[position];
                cellIdentifier = @"CellAttachment";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    CGFloat imgWidth = 18;
                    UIImageView * moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(width-imgWidth-_paddingLeft, (cell.frame.size.height - imgWidth)/2, imgWidth, imgWidth)];
                    moreImg.image = [[FMTheme getInstance] getImageByName:@"slim_more"];
                    
                    [cell addSubview:moreImg];
                } else {
                    NSArray *subViews = [cell subviews];
                    for (UIView *view in subViews) {
                        if ([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *) view;
                        }
                    }
                }
                if (cell) {
                    [cell.textLabel setText:attachment.fileName];
                    cell.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
                    cell.textLabel.font = [FMFont getInstance].font42;
                }
                if (cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if (seperator) {
                    if (position < _jobDetail.attachment.count - 1) {
                        [seperator setHidden:NO];
                        [seperator setDotted:YES];
                        [seperator setFrame:CGRectMake([FMSize getInstance].defaultPadding, _approvalContentItemHeight-[FMSize getInstance].seperatorHeight, width-[FMSize getInstance].defaultPadding*2, [FMSize getInstance].seperatorHeight)];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
            } else {
                isFooter = YES;
            }
            break;
        case SECTION_TYPE_RELATED_ORDER:
            if(position >= 0 && position < [_jobDetail.relatedOrder count]) {
                WorkOrderRelatedOrder * order = _jobDetail.relatedOrder[position];
                itemHeight = _orderItemHeight;
                cellIdentifier = @"CellOrder";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[BaseItemView class]]) {
                            orderItemView = (BaseItemView *)view;
                            break;
                        } else if ([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;
                        }
                    }
                }
                if(cell && !orderItemView) {
                    orderItemView = [[BaseItemView alloc] init];
                    [orderItemView setShowMore:YES];
                    [orderItemView setPaddingLeft:paddingLeft];
                    [orderItemView setPaddingRight:paddingLeft];
                    [orderItemView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
                    [orderItemView addTarget:self action:@selector(onOrderItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:orderItemView];
                }
                if (cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if(orderItemView) {
                    orderItemView.tag = position;
                    [orderItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [orderItemView setInfoWithName:order.code];
                }
                if (seperator) {
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                }
            } else {
                isFooter = YES;
            }
            break;
        default:
            break;
    }
    if(isFooter) {
        cellIdentifier = @"CellFooter";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        SeperatorView * footerView;
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            
        } else {
            NSArray * subViews = [cell subviews];
            for(id subView in subViews) {
                if([subView isKindOfClass:[SeperatorView class]]) {
                    footerView = subView;
                }
            }
        }
        if(cell && !footerView) {
            footerView = [[SeperatorView alloc] init];
            [cell addSubview:footerView];
        }
        if(footerView) {
            [footerView setFrame:CGRectMake(0, 0, width, seperatorHeight)];
            [footerView setShowBottomBound:NO];
            [footerView setShowTopBound:YES];
            if(position > 0) {
                [footerView setShowTopBound:YES];
            } else {
                [footerView setShowTopBound:NO];
            }
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WorkJobListSection sectionType = [self getSectionType:section];
    CGFloat width = CGRectGetWidth(tableView.frame);
    UIView * res;
    MarkedListHeaderView * headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    WorkContentHeaderView * contentHeaderView;
    res = headerView;
    NSString* strHeader = nil;
    NSString * strDesc = nil;
    NSNumber * tmpNumber;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    switch(sectionType) {
        case SECTION_TYPE_APPROVAL_CONTENT:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_approval_content" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        case SECTION_TYPE_COMMON:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_base_info" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_RED_BG];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        case SECTION_TYPE_CONTENT:
            contentHeaderView  = [[WorkContentHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
            strHeader = [[BaseBundle getInstance] getStringByKey:@"order_work_content" inTable:nil];
            [contentHeaderView setInfoWithName:strHeader];
            if(_editable) {
                [contentHeaderView setOnItemClickListener:self];
                [contentHeaderView setShowRightImage:YES];
            } else {
                [contentHeaderView setShowRightImage:NO];
                [contentHeaderView setOnItemClickListener:nil];
            }
            res = contentHeaderView;
            break;
        case SECTION_TYPE_WORK_HISTORY:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"order_work_history" inTable:nil];
            [headerView setInfoWithName:strHeader desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        case SECTION_TYPE_LABORER:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_laborer" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        case SECTION_TYPE_DEVICE:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_equipment" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            break;
        case SECTION_TYPE_FAILURE_REASON:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_failure_reason" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setDescLabel:nil content:_jobDetail.failueDescription];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            break;
        case SECTION_TYPE_TOOL:
            tmpNumber = [self getToolCharge];
            strDesc = [[NSString alloc] initWithFormat:@"%@%.2f", [[BaseBundle getInstance] getStringByKey:@"yuan_symbol" inTable:nil], tmpNumber.floatValue];
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_tool" inTable:nil] desc:strDesc andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            [headerView setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK]];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            
            if([self needShowCharge]) { //如果跟收费明细相邻则下分割线为虚线
                [headerView setShowBottomBorder:YES withPaddingLeft:padding paddingRight:padding];
                [headerView setBottomBorderDotted:YES];
            }
            break;
        case SECTION_TYPE_PLAN_STEP:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_planned_step" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        case SECTION_TYPE_MATERIAL:
            tmpNumber = [self getToolCharge];
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_material" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK]];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            
            break;
        case SECTION_TYPE_HISTORY:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_step" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        case SECTION_TYPE_CHARGE:
            tmpNumber = [self getChargeSum];
            strDesc = [[NSString alloc] initWithFormat:@"%@%.2f", [[BaseBundle getInstance] getStringByKey:@"yuan_symbol" inTable:nil], tmpNumber.floatValue];
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_charge" inTable:nil] desc:strDesc andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            [headerView setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK]];

            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        case SECTION_TYPE_SIGN_CUSTOMER:
            if([self customerSigned]) {
                strDesc = [[BaseBundle getInstance] getStringByKey:@"order_sign_finished" inTable:nil];
            }
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_sign_customer" inTable:nil] desc:strDesc andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            [headerView setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            if([self needShowSignSupervisor]) {
                [headerView setShowBottomBorder:YES withPaddingLeft:padding paddingRight:padding];
            }
            break;
        case SECTION_TYPE_SIGN_SUPERVISOR:
            if([self supervisorSigned]) {
                strDesc = [[BaseBundle getInstance] getStringByKey:@"order_sign_finished" inTable:nil];
            }
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_sign_supervisor" inTable:nil] desc:strDesc andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            [headerView setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        case SECTION_TYPE_ATTACHMENT:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_attachment" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        case SECTION_TYPE_RELATED_ORDER:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_related_order" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        default:
            break;
    }
    headerView.tag = sectionType;
    return res;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

#pragma mark - 点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    WorkJobListSection sectionType = [self getSectionType:section];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    
    switch (sectionType) {
        case SECTION_TYPE_COMMON:
            if(position == [self getCommonItemCount] - 1) { //如果点击展开按钮
                _expand = !_expand;
                NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:section];
                [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
        case SECTION_TYPE_HISTORY:
            if (position == 1) {
                NSMutableArray * histories = _jobDetail.histories;
                [self notifyEvent:WO_DETAIL_EVENT_HISTORY_RECORD_SHOW data:histories];
            }
            break;
        case SECTION_TYPE_ATTACHMENT:
            if (position < [self getAttachmentCount]) {
                [self notifyEvent:WO_DETAIL_EVENT_SHOW_ATTACHMENT_REQUIREMENT data:[NSNumber numberWithInteger:position]];
            }
            break;
            
        default:
            break;
    }
    if(_editable) {
        WorkOrderStep * step;
        WorkOrderChargeItem * charge;
        switch(sectionType) {
            case SECTION_TYPE_CONTENT:
                if (![FMUtils isStringEmpty:_workContent]) {
                    [self notifyEvent:WO_DETAIL_EVENT_CONTENT_EDIT data:_workContent];
                }
                break;
            case SECTION_TYPE_MATERIAL:
                break;
            case SECTION_TYPE_PLAN_STEP:
                if(position >= 0 && position < [_jobDetail.steps count]) {
                    step = _jobDetail.steps[position];
                    
                    [data setValue:step.comment forKeyPath:@"comment"];
                    [data setValue:[NSNumber numberWithBool:step.finished] forKeyPath:@"finished"];
                    [self notifyEvent:WO_DETAIL_EVENT_STEP_EDIT data:data];
                    _curStepIndex = position;
                }
                break;
            case SECTION_TYPE_CHARGE:
                if(position >= 0 && position < [_jobDetail.charges count]) {
                    charge = _jobDetail.charges[position];
                    if(_editable && !charge.chargeId) { //只有当前添加的收费项才允许编辑
                        [self notifyEvent:WO_DETAIL_EVENT_CHARGE_EDIT data:[NSNumber numberWithInteger:position]];
                        NSLog(@"可编辑");
                    } else {
                        NSLog(@"不可编辑");
                    }
                }
                break;
                
            default:
                break;
        }
    }
}


#pragma - 事件处理
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        NSNumber * tmpNumber;
        NSMutableArray * tmpArray;
        if([strOrigin isEqualToString:NSStringFromClass([BasePhotoView class])]) {
            tmpNumber = [msg valueForKeyPath:@"msgType"];
            PhotoActionType type = [tmpNumber integerValue];
            
            tmpNumber = [msg valueForKeyPath:@"tag"];
            NSInteger tag = [tmpNumber integerValue];
            
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    if(tag == WO_DETAIL_IMAGE_PHOTO_ORDER) {
                        [self notifyEvent:WO_DETAIL_EVENT_SHOW_PHOTO_ORDER data:tmpNumber];
                    } else if(tag == WO_DETAIL_IMAGE_PHOTO) {
                        [self notifyEvent:WO_DETAIL_EVENT_SHOW_PHOTO_REQUIREMENT data:tmpNumber];
                    } else if(tag == WO_DETAIL_IMAGE_AUDIO) {
                        [self notifyEvent:WO_DETAIL_EVENT_SHOW_AUDIO_REQUIREMENT data:tmpNumber];
                    } else if(tag == WO_DETAIL_IMAGE_VIDEO) {
                        [self notifyEvent:WO_DETAIL_EVENT_SHOW_VIDEO_REQUIREMENT data:tmpNumber];
                    }
                    break;
                case PHOTO_ACTION_TAKE_PHOTO:
                    break;
                default:
                    break;
            }
        }
        if ([strOrigin isEqualToString:NSStringFromClass([WorkOrderDetailHistoryRecordView class])]) {
            tmpNumber = [msg valueForKeyPath:@"position"];
            tmpArray = [msg valueForKeyPath:@"photosArray"];
            NSDictionary * dic = @{@"photosArray":tmpArray, @"position":tmpNumber};
            [self notifyEvent:WO_DETAIL_EVENT_HISTORY_RECORD_PHOTO_SHOW data:dic];
        }
    }
}

//点击了列表头
- (void) onClick:(UIView *)view {
    if([view isKindOfClass:[MarkedListHeaderView class]]) {
        WorkJobListSection sectionType = (WorkJobListSection)view.tag;
        switch(sectionType) {
            case SECTION_TYPE_CONTENT:
                [self notifyEvent:WO_DETAIL_EVENT_CONTENT_ADD data:nil];
                break;
            case SECTION_TYPE_DEVICE:
                [self notifyEvent:WO_DETAIL_EVENT_EQUIPMENT_SHOW data:nil];
                break;
            case SECTION_TYPE_FAILURE_REASON:
                if(_editable) {
                    [self notifyEvent:WO_DETAIL_EVENT_EDIT_FAILURE_REASON data:nil];
                }
                break;
            case SECTION_TYPE_TOOL:
                [self notifyEvent:WO_DETAIL_EVENT_TOOL_SHOW data:nil];
                break;
            case SECTION_TYPE_MATERIAL:
                [self notifyEvent:WO_DETAIL_EVENT_MATERIAL_SHOW data:nil];
                break;
            case SECTION_TYPE_CHARGE:
                [self notifyEvent:WO_DETAIL_EVENT_CHARGE_SHOW data:nil];
                break;
            case SECTION_TYPE_PLAN_STEP:
                [self notifyEvent:WO_DETAIL_EVENT_STEP_SHOW data:nil];
                break;
            case SECTION_TYPE_SIGN_CUSTOMER:
                if(_editable && ![self customerSigned]) {   //处理中的工单，并且客户还没有签字
                    [self notifyEvent:WO_DETAIL_EVENT_SIGN_EDIT_CUSTOMER data:nil];
                } else {
                    [self notifyEvent:WO_DETAIL_EVENT_SIGN_SHOW_CUSTOMER data:nil];
                }
                break;
            case SECTION_TYPE_SIGN_SUPERVISOR:
                if((_jobDetail.status == ORDER_STATUS_FINISH || _jobDetail.status == ORDER_STATUS_TERMINATE) && ![self supervisorSigned]) {//已完成和已终止的工单，并且主管还没签字
                    [self notifyEvent:WO_DETAIL_EVENT_SIGN_EDIT_SUPERVISOR data:nil];
                } else {
                    [self notifyEvent:WO_DETAIL_EVENT_SIGN_SHOW_SUPERVISOR data:nil];
                }
                
                break;
            default:
                break;
        }
    } else if([view isKindOfClass:[WorkOrderDetailLaborerItemView class]]) {
        NSNumber * arriveTime;
        NSNumber * finishTime;
        for(WorkOrderLaborer * laborer in _jobDetail.workOrderLaborers) {
            if([_laborerId isEqualToNumber:laborer.laborerId]) {
                arriveTime = [laborer.actualArrivalDateTime copy];
                finishTime = [laborer.actualCompletionDateTime copy];
                break;
            }
        }
        NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
        [data setValue:arriveTime forKeyPath:@"arriveTime"];
        [data setValue:finishTime forKeyPath:@"finishTime"];
        [self notifyEvent:WO_DETAIL_EVENT_LABORER_TIME data:data];
    } else if([view isKindOfClass:[WorkOrderDetailEquipmentItemView class]]) {
        NSInteger position = view.tag;
        WorkOrderEquipment * equip = _jobDetail.workOrderEquipments[position];
        [self notifyEvent:WO_DETAIL_EVENT_EQUIPMENT_EDIT data:equip];
    } else if([view isKindOfClass:[WorkOrderDetailToolItemView class]]) {
        NSInteger position = view.tag;
        _curToolIndex = position;
        WorkOrderTool * tool = _jobDetail.workOrderTools[_curToolIndex];
        [self notifyEvent:WO_DETAIL_EVENT_TOOL_EDIT data:tool];
    }
}

//点击拍照
- (void) onCameraClicked {
    [self notifyEvent:WO_DETAIL_EVENT_TAKE_PHOTO data:nil];
}

//图片点击ƒ
- (void) onPhotoItemClick:(UIView *)view position:(NSInteger)position {
    NSInteger tag = view.tag;
    NSNumber * data = [NSNumber numberWithInteger:position];
    switch(tag) {
        case SECTION_TYPE_COMMON:
            [self notifyEvent:WO_DETAIL_EVENT_SHOW_PHOTO_REQUIREMENT data:data];
            break;
    }
}

//
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[WorkOrderDetailCommonItemView class]]) {
        NSString * strPhone = _jobDetail.applicantPhone;
        NSArray * tmpArray = [strPhone componentsSeparatedByString:@"/"];
        NSMutableArray * phones = [[NSMutableArray alloc] init];
        for(NSString * item in tmpArray) {
            if(![FMUtils isStringEmpty:item]) {
                NSString * strItem = [item stringByReplacingOccurrencesOfString:@" " withString:@""];
                [phones addObject:strItem];
            }
        }
        [self notifyEvent:WO_DETAIL_EVENT_TAKE_CALL data:phones];
    }else if([view isKindOfClass:[BasePhotoView class]]) {
        NSInteger picIndex = subView.tag;
        WorkOrderDetailImageType type = view.tag;
        switch(type) {
            case WO_DETAIL_IMAGE_AUDIO:
                [self notifyEvent:WO_DETAIL_EVENT_SHOW_AUDIO_REQUIREMENT data:[NSNumber numberWithInteger:picIndex]];
                break;
            case WO_DETAIL_IMAGE_VIDEO:
                [self notifyEvent:WO_DETAIL_EVENT_SHOW_VIDEO_REQUIREMENT data:[NSNumber numberWithInteger:picIndex]];
                break;
            default:
                break;
        }
        
    } else if([view isKindOfClass:[WorkOrderDetailToolItemView class]]) {
        _curToolIndex = view.tag;
        if(subView && subView.tag == WO_TOOL_ACTION_DELETE) {
            [self notifyEvent:WO_DETAIL_EVENT_TOOL_DELETE data:[NSNumber numberWithInteger:_curToolIndex]];
        } else {
            [self notifyEvent:WO_DETAIL_EVENT_TOOL_EDIT data:[NSNumber numberWithInteger:_curToolIndex]];
        }
    } else if([view isKindOfClass:[WorkOrderDetailChargeItemView class]]) {
        NSInteger position = view.tag;
        WorkOrderChargeItem * charge = _jobDetail.charges[position];
        if(!charge.chargeId) {  //id 不为nil表示是从服务器获取到的数据，不允许修改
            if(!subView) {
                [self notifyEvent:WO_DETAIL_EVENT_CHARGE_EDIT data:[NSNumber numberWithInteger:position]];
            } else {
                [self notifyEvent:WO_DETAIL_EVENT_CHARGE_DELETE data:[NSNumber numberWithInteger:position]];
            }
        }
    } else if([view isKindOfClass:[WorkContentHeaderView class]]) {
        if(subView) {
             [self notifyEvent:WO_DETAIL_EVENT_TAKE_PHOTO data:nil];
        } else {
             [self notifyEvent:WO_DETAIL_EVENT_CONTENT_ADD data:nil];
        }
    }
}

//工具删除
- (void) onButtonClick:(UIView *)parent view:(UIView *)view {
    if([parent isKindOfClass:[WorkOrderDetailEquipmentItemView class]]) {
        NSInteger position = parent.tag;
        [self notifyEvent:WO_DETAIL_EVENT_EQUIPMENT_DELETE data:[NSNumber numberWithInteger:position]];
    }
}

//工单点击
- (void) onOrderItemClicked:(id) sender {
    if([sender isKindOfClass:[BaseItemView class]]) {
        BaseItemView * orderItemView = (BaseItemView *)sender;
        NSInteger position = orderItemView.tag;
        [self notifyEvent:WO_DETAIL_EVENT_SHOW_RELATED_ORDER data:[NSNumber numberWithInteger:position]];
    }
}

@end
