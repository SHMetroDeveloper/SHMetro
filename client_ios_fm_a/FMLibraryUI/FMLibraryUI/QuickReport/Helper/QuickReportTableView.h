//
//  QuickReportTableView.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickReportBaseInfoModel.h"

typedef NS_ENUM(NSInteger, QuickReportActionType) {
    
    QUICK_REPORT_ACTION_BASE_INFO_SERVICETYPE, //添加服务类型
    QUICK_REPORT_ACTION_BASE_INFO_LOCATION,  //添加地理位置
    
    QUICK_REPORT_ACTION_EQUIPMENT_DETAIL,  //查看故障设备
    QUICK_REPORT_ACTION_EQUIPMENT_DELETE,  //删除故障设备
    
    QUICK_REPORT_ACTION_EQUIPMENT_ADD_DIRECT,  //直接添加故障设备
    QUICK_REPORT_ACTION_EQUIPMENT_ADD_SCAN, //扫描添加故障设备
    
    QUICK_REPORT_ACTION_MEDIA_AUDIO_SHOW,  //录音点击试听
    QUICK_REPORT_ACTION_MEDIA_AUDIO_DELETE, //录音删除
    QUICK_REPORT_ACTION_MEDIA_PHOTO_SHOW,  //照片查看
    QUICK_REPORT_ACTION_MEDIA_PHOTO_DELETE,  //照片删除
    QUICK_REPORT_ACTION_MEDIA_VIDEO_SHOW,  //视频点击试听
    QUICK_REPORT_ACTION_MEDIA_VIDEO_DELETE, //视频删除
};

typedef void(^QuickReportActionBlock)(QuickReportActionType type, id object);

@interface QuickReportTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@property (nonatomic, copy) QuickReportActionBlock actionBlock;

//设置基本信息
- (void)setQuickReportBaseInfo:(QuickReportBaseInfoModel *)baseInfo;

//设置故障设备
- (void)setQuickReportEquipment:(NSMutableArray *)equipmentArray;

//设置语音
- (void)setQuickReportAudio:(NSMutableArray *)audioArray;
//设置语音时常
- (void)setQuickReportAudioTimeInterval:(NSMutableArray *)audioTimeArray;

//设置图片
- (void)setQuickReportPhoto:(NSMutableArray *)photoArray;

//设置视频
- (void)setQuickReportVideo:(NSMutableArray *)videoArray;

//获取基本信息
- (QuickReportBaseInfoModel *)quickReportBaseInfo;

@end
