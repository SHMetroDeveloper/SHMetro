//
//  QuickReportViewController.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "QuickReportViewController.h"
#import "FMUtilsPackages.h"
#import "VideoTakeViewController.h"
#import "QuickReportTableView.h"
#import "BaseDataEntity.h"
#import "FileUploadService.h"
#import "BaseDataDbHelper.h"

#import "TaskAlertView.h"
#import "AddMoreAlertView.h"
#import "AudioRecordAlertView.h"
#import "AudioPlayAlertView.h"

#import "QuickReportBusiness.h"
#import "CameraHelper.h"
#import "PhotoShowHelper.h"
#import "InfoSelectViewController.h"
#import "QrCodeViewController.h"
#import "EquipmentQrcode.h"

#include "lame.h"
#import "AudioCoverUtils.h"
#import "SystemConfig.h"
#import "PhotoShowHelper.h"
#import "MediaViewController.h"
#import "UserBusiness.h"



typedef NS_ENUM(NSInteger, AlertViewType) {
    QUICK_REPORT_OPERATION_ADD_BTN,  //添加多媒体操作
    QUICK_REPORT_OPERATION_AUDIO_RECORDING,  //语音录制
    QUICK_REPORT_OPERATION_AUDIO_PLAYING   //语音播放
};

typedef NS_ENUM(NSInteger, UploadOperationType) {
    UPLOAD_FILE_TYPE_AUDIO,  //上传语音
    UPLOAD_FILE_TYPE_PHOTO,  //上传照片
    UPLOAD_FILE_TYPE_VIDEO,  //上传视频
};

@interface QuickReportViewController () <OnClickListener,OnItemClickListener,OnMessageHandleListener,FileUploadListener,OnQrCodeScanFinishedListener,AVAudioPlayerDelegate>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) QuickReportTableView *tableView;
@property (nonatomic, strong) UIButton *addMoreBtn;

@property (nonatomic, strong) TaskAlertView *alertView; //弹出框
@property (nonatomic, assign) AlertViewType operateType;
@property (nonatomic, assign) CGFloat alertViewHeight;   //弹出框高度
@property (nonatomic, strong) AddMoreAlertView *addMoreView; //提醒弹出View (四个按钮)
@property (nonatomic, strong) AudioRecordAlertView *audioRecordAlertView; //提醒弹出View (录音界面)
@property (nonatomic, strong) AudioPlayAlertView *audioPlayAlertView; //提醒弹出View (录音播放界面)

@property (nonatomic, strong) BaseDataDbHelper *dbHelper;
@property (nonatomic, strong) CameraHelper *cameraHelper;
@property (nonatomic, strong) PhotoShowHelper *photoShowHelper;
@property (nonatomic, strong) QuickReportBusiness *business;
@property (nonatomic, assign) UploadOperationType uploadType;
@property (nonatomic, strong) __block NSMutableArray *audioMP3Array;

@property (nonatomic, strong) NSNumber *assetEqId;   //用于处理从资产详情过来的快速报障
@property (nonatomic, strong) Position *patrolLocation; //用于处理从巡检过来的快速报障
@property (nonatomic, strong) NSString *patrolDesc;  //用于处理从巡检过来的快速报障

@property (nonatomic, strong) __block QuickReportBaseInfoModel *baseInfo;
@property (nonatomic, strong) NSMutableArray *equipmentArray;
@property (nonatomic, strong) NSMutableArray *audioArray;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) NSMutableArray *audioTimeArray; //用于存放语音时长，在tableview中显示

@property (nonatomic, strong) NSMutableArray *photoReponseIds; //上传成功以后返回的图片ID
@property (nonatomic, strong) NSMutableArray *audioReponseIds; //上传成功以后返回的音频ID
@property (nonatomic, strong) NSMutableArray *videoReponseIds; //上传成功以后返回的视频ID

@property (nonatomic, strong) AVAudioRecorder *mp3Recorder;  //录音控件
@property (nonatomic, strong) NSMutableDictionary *recorderSettings;  //录音设置
@property (nonatomic, strong) NSString *recordFilePath;   //单个录音的path
@property (nonatomic, strong) NSNumber *recordTimeInterval;   //单个录音的时间
@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer; //播放控件
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, assign) BOOL backFromQrcode;  //是否是从扫描二维码返回
@property (nonatomic, strong) EquipmentQrcode *equipQrcode;

@end

@implementation QuickReportViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"quick_report_navi_title" inTable:nil]];
    [self setBackAble:YES];
    
    NSArray * menuTextArray = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"function_report_uploaded" inTable:nil], nil];
    [self setMenuWithArray:menuTextArray];
}

- (void)initAlertView {
    _alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    //四个按钮
    _addMoreView = [[AddMoreAlertView alloc] init];
    _addMoreView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_addMoreView setOnItemClickListener:self];
    [_alertView setContentView:_addMoreView withKey:@"addmoreMedia" andHeight:self.view.frame.size.height*0.205 andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    //录音录制界面
    _audioRecordAlertView = [[AudioRecordAlertView alloc] init];
    _audioRecordAlertView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_audioRecordAlertView setOnItemClickListener:self];
    [_alertView setContentView:_audioRecordAlertView withKey:@"audioRecording" andHeight:[AudioRecordAlertView getRecordViewHeight] andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    //录音播放界面
    _audioPlayAlertView = [[AudioPlayAlertView alloc] init];
    _audioPlayAlertView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_audioPlayAlertView setOnItemClickListener:self];
    [_alertView setContentView:_audioPlayAlertView withKey:@"audioPlaying" andHeight:[AudioPlayAlertView getPlayViewHeight] andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (void)initRecorder {
    _recorderSettings = [[NSMutableDictionary alloc] init];
    //录音格式
    [_recorderSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //采样率
    [_recorderSettings setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    //通道数
    [_recorderSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数
    [_recorderSettings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [_recorderSettings setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
}

- (void)initBaseInfo {
    [self initDbHelper];
    NSInteger userId = [[SystemConfig getOauthFM] getUserInfo].userId;
    NSString *userName;
    UserInfo *user = [_dbHelper queryUserById:[NSNumber numberWithInteger:userId]];
    if(user) {
        userName = user.name;
        if([FMUtils isStringEmpty:userName]) {
            userName = user.loginName;
        }
        if(!userName) {
            userName = @"";
        }
        _baseInfo.applicant = userName;
        _baseInfo.phoneNumber = user.phone;
        if (user.type.integerValue != USER_TYPE_OUTSOURCE) {
            _baseInfo.location = [_dbHelper getDefaultPosition];
        } else {
            /**
             请求最后一次签到记录
             */
            __weak typeof(self) weakSelf = self;
            [[UserBusiness getInstance] getLastAttendanceRecordSuccess:^(NSInteger key, id object) {
                AttendanceRecordEntity *attendanceRecord = (AttendanceRecordEntity * )object;
                if (attendanceRecord.location) {
                    weakSelf.baseInfo.location = attendanceRecord.location;
                } else {
                    weakSelf.baseInfo.location = nil;
                }
            } fail:^(NSInteger key, NSError *error) {
                DLog(@"请求签到记录失败");
            }];
        }
    } else {
        NSString *loginName = [SystemConfig getLoginName];
        _baseInfo.applicant = loginName;
    }
    
    if (_assetEqId) {
        Device *dev = [_dbHelper queryDeviceById:_assetEqId];
        if (dev) {
            [_equipmentArray addObject:dev];
            _baseInfo.location = dev.position;
        }
    }
    if (_patrolLocation) {
        _baseInfo.location = _patrolLocation;
    }
    if (![FMUtils isStringEmpty:_patrolDesc]) {
        _baseInfo.desc = _patrolDesc;
    }
    [self updateList];
}

- (void)initDbHelper {
    if (!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    NSMutableArray *allTypes = [[NSMutableArray alloc] init];
    allTypes = [_dbHelper queryAllRequirementTypesOfCurrentProject];
    if ([allTypes count] <= 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"download_notice_download" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

//处理从巡检过来的报障
- (void) setInforWithLocation:(Position *) location
                    equipment:(NSNumber *) equipId
                      content:(NSNumber *) contentId
                         desc:(NSString *) desc
                         imgs:(NSMutableArray *) imageIds {
    
    _patrolLocation = location;
    _assetEqId = equipId;
    _patrolDesc = desc;
    
//    _baseInfo = [[QuickReportBaseInfoModel alloc] init];
//    _baseInfo.location = location;
//    
//    if(!_dbHelper) {
//        _dbHelper = [BaseDataDbHelper getInstance];
//    }
//    if (!_equipmentArray) {
//        _equipmentArray = [NSMutableArray new];
//    }
//    if(equipId) {
//        Device *dev = [_dbHelper queryDeviceById:equipId];
//        if(dev) {
//            [_equipmentArray addObject:dev];
//        } else {
//            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"download_notice_download" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
//        }
//    }
//    _baseInfo.desc = desc;
}

//处理从资产过来的快速报障
- (void) setEquipmentId:(NSNumber *)eqId {
    _assetEqId = eqId;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAlertView];
    [self initRecorder];
    [self initBaseInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_backFromQrcode) {
        _backFromQrcode = NO;
        [self handleQrcodeResult];
    }
}

#pragma mark - 页面绘制
- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        if (!_baseInfo) {
            _baseInfo = [[QuickReportBaseInfoModel alloc] init];
        }
        if (!_equipmentArray) {
            _equipmentArray = [NSMutableArray new];
        }
        if (!_audioArray) {
            _audioArray = [NSMutableArray new];
        }
        if (!_audioMP3Array) {
            _audioMP3Array = [NSMutableArray new];
        }
        if (!_photoArray) {
            _photoArray = [NSMutableArray new];
        }
        if (!_videoArray) {
            _videoArray = [NSMutableArray new];
        }
        if (!_audioTimeArray) {
            _audioTimeArray = [NSMutableArray new];
        }
        if (!_audioReponseIds) {
            _audioReponseIds = [NSMutableArray new];
        }
        if (!_photoReponseIds) {
            _photoReponseIds = [NSMutableArray new];
        }
        if (!_videoReponseIds) {
            _videoReponseIds = [NSMutableArray new];
        }
        if (!_business) {
            _business = [QuickReportBusiness getInstance];
        }
        
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        [_mainContainerView addSubview:self.tableView];
        [_mainContainerView addSubview:self.addMoreBtn];
        
        _cameraHelper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:YES];
        [_cameraHelper setOnMessageHandleListener:self];
        
        _photoShowHelper = [[PhotoShowHelper alloc] initWithContext:self];
        
        self.view.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [self.view addSubview:_mainContainerView];
    }
}

#pragma mark - Lazy load
- (QuickReportTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QuickReportTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight) style:UITableViewStyleGrouped];
        __weak typeof(self) weakSelf = self;
        _tableView.actionBlock = ^(QuickReportActionType type, id object){
            switch (type) {
                case QUICK_REPORT_ACTION_BASE_INFO_SERVICETYPE:{
                    [weakSelf gotoSelectServiceType];
                }
                    break;
                case QUICK_REPORT_ACTION_BASE_INFO_LOCATION:{
                    [weakSelf gotoSelectLocation];
                }
                    break;
                    
                    
                case QUICK_REPORT_ACTION_EQUIPMENT_DETAIL:{
                    Device *dev = (Device *)object;
                    [weakSelf gotoShowEquipment:dev];
                }
                    break;
                case QUICK_REPORT_ACTION_EQUIPMENT_DELETE:{
                    NSNumber *position = (NSNumber *)object;
                    [weakSelf deleteEquipmentByPosition:position.integerValue];
                }
                    break;
                case QUICK_REPORT_ACTION_EQUIPMENT_ADD_DIRECT:{
                    [weakSelf gotoSelectEquipment];
                }
                    break;
                case QUICK_REPORT_ACTION_EQUIPMENT_ADD_SCAN:{
                    [weakSelf gotoScanEquipment];
                }
                    break;
                    
                    
                case QUICK_REPORT_ACTION_MEDIA_AUDIO_SHOW:{
                    NSNumber *position = (NSNumber *)object;
                    [weakSelf gotoShowPlayControlView:position.integerValue];
                }
                    break;
                case QUICK_REPORT_ACTION_MEDIA_AUDIO_DELETE:{
                    NSNumber *position = (NSNumber *)object;
                    [weakSelf deleteAudioByPosition:position.integerValue];
                }
                    break;
                    
                    
                case QUICK_REPORT_ACTION_MEDIA_PHOTO_SHOW:{
                    NSNumber *position = (NSNumber *)object;
                    [weakSelf gotoShowPhoto:position.integerValue];
                }
                    break;
                case QUICK_REPORT_ACTION_MEDIA_PHOTO_DELETE:{
                    NSNumber *position = (NSNumber *)object;
                    [weakSelf deletePhotoByPosition:position.integerValue];
                }
                    break;
                    
                    
                case QUICK_REPORT_ACTION_MEDIA_VIDEO_SHOW:{
                    NSNumber *position = (NSNumber *)object;
                    [weakSelf gotoShowVideo:position.integerValue];
                }
                    break;
                case QUICK_REPORT_ACTION_MEDIA_VIDEO_DELETE:{
                    NSNumber *position = (NSNumber *)object;
                    [weakSelf deleteVideoByPosition:position.integerValue];
                }
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _tableView;
}

- (UIButton *)addMoreBtn {
    if (!_addMoreBtn) {
        //添加按钮
        CGFloat btnWidth = [FMSize getInstance].filterWidth;
        CGFloat padding = [FMSize getInstance].defaultPadding;
        _addMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-btnWidth-padding, _realHeight-btnWidth-padding, btnWidth, btnWidth)];
        [_addMoreBtn addTarget:self action:@selector(onAddMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addMoreBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"add_normal"] forState:UIControlStateNormal];
        [_addMoreBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"add_highlight"] forState:UIControlStateHighlighted];
        _addMoreBtn.layer.cornerRadius = btnWidth/2;
        _addMoreBtn.layer.masksToBounds = YES;
    }
    return _addMoreBtn;
}

#pragma mark - Private Method
- (void)updateList {
    [_tableView setQuickReportBaseInfo:_baseInfo];
    
    [_tableView setQuickReportEquipment:_equipmentArray];
    
    [_tableView setQuickReportAudio:_audioArray];
    [_tableView setQuickReportAudioTimeInterval:_audioTimeArray];
    
    [_tableView setQuickReportPhoto:_photoArray];
    
    [_tableView setQuickReportVideo:_videoArray];
}

- (void)gotoSelectServiceType {
    InfoSelectViewController *infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_SERVICE_TYPE_INFO_SELECT];
    [infoSelectVC setOnMessageHandleListener:self];
    [self gotoViewController:infoSelectVC];
}

- (void)gotoSelectLocation {
    InfoSelectViewController *infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_LOCATION_INFO_SELECT];
    [infoSelectVC setOnMessageHandleListener:self];
    [self gotoViewController:infoSelectVC];
}

- (void)gotoShowEquipment:(Device *)device {
    //暂不用显示设备详情
}

- (void)gotoSelectEquipment {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_baseInfo.location forKeyPath:@"position"];
    InfoSelectViewController *infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_DEVICE_INFO_SELECT andParam:param];
    [infoSelectVC setOnMessageHandleListener:self];
    [self gotoViewController:infoSelectVC];
}

- (void)gotoScanEquipment {
    QrCodeViewController * vc = [[QrCodeViewController alloc] init];
    [vc setOnQrCodeScanFinishedListener:self];
    [self gotoViewController:vc];
}

- (void)gotoShowPlayControlView:(NSInteger)position {
    [self setupAudioPlayer:position];
    _operateType = QUICK_REPORT_OPERATION_AUDIO_PLAYING;
    [_alertView showType:@"audioPlaying"];
    [_alertView show];
}

- (void)setupAudioPlayer:(NSInteger)position {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *activationErr  = nil;
        NSError *setCategoryErr = nil;
        [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
        NSString *audioPath = _audioArray[position];
        NSURL *audioUrl = [NSURL URLWithString:audioPath];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
        _audioPlayer.delegate = self;
        
        [_audioPlayer prepareToPlay];
        [_audioPlayer setMeteringEnabled:YES];
        _isPlaying = YES;
    });
}

- (void)deleteEquipmentByPosition:(NSInteger)position {
    [_equipmentArray removeObjectAtIndex:position];
    [self updateList];
}

- (void)deleteAudioByPosition:(NSInteger)position {
    [_audioArray removeObjectAtIndex:position];
    [_audioTimeArray removeObjectAtIndex:position];
    [_audioMP3Array removeObjectAtIndex:position];
    [self updateList];
}

- (void)deletePhotoByPosition:(NSInteger)position {
    [_photoArray removeObjectAtIndex:position];
    [self updateList];
}

- (void)deleteVideoByPosition:(NSInteger)position {
    [_videoArray removeObjectAtIndex:position];
    [self updateList];
}

#pragma mark - NetWorking
- (void)uploadQuickReportInfo {
    
    _baseInfo = [_tableView quickReportBaseInfo];
    
    /* 联系电话 */
    if ([FMUtils isStringEmpty:_baseInfo.phoneNumber]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_request_phone" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    
    /* 位置 */
    if (_baseInfo.location == nil) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_request_location" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    
    /* 故障描述 */
    if ([FMUtils isStringEmpty:_baseInfo.desc]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_request_description" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    [self uploadData];
}

- (void)uploadData {
    [self showLoadingDialog];
    if (_audioMP3Array.count > 0) {
        [self uploadAudio];
    } else if (_photoArray.count > 0) {
        [self uploadImage];
    } else if (_videoArray.count > 0) {
        [self uploadVideo];
    } else {
        [self requestUploadQuickReport];
    }
}

- (void)requestUploadQuickReport {
    [self showLoadingDialog];
    QuickReportCreateRequestParam *param = [self getReportParam];
    __weak typeof(self) weakSelf = self;
    [_business uploadQuickReportInfo:param success:^(NSInteger key, id object) {
        [weakSelf hideLoadingDialog];
        [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_upload_fail_check_internet" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (QuickReportCreateRequestParam *)getReportParam {
    QuickReportCreateRequestParam *param = [[QuickReportCreateRequestParam alloc] init];
    param.requester = _baseInfo.applicant;
    param.contact = _baseInfo.phoneNumber;
    param.serviceTypeId = _baseInfo.serviceType.serviceTypeId;
    param.desc = _baseInfo.desc;
    param.location = _baseInfo.location;
    for (Device *dev in _equipmentArray) {
        [param.equipment addObject:dev.eqId];
    }
    param.audioIds = _audioReponseIds;
    param.photoIds = _photoReponseIds;
    param.videoIds = _videoReponseIds;
    return param;
}

- (void)uploadAudio {
    _uploadType = UPLOAD_FILE_TYPE_AUDIO;
    [[FileUploadService getInstance] uploadAudioFiles:_audioMP3Array listener:self];
}

- (void)uploadImage {
    _uploadType = UPLOAD_FILE_TYPE_PHOTO;
    [[FileUploadService getInstance] uploadImageFiles:_photoArray listener:self];
}

- (void)uploadVideo {
    NSMutableArray *videoFiles = [[NSMutableArray alloc] init];
    for(PhotoItem * item in _videoArray) {
        [videoFiles addObject:item.originUrl];
    }
    _uploadType = UPLOAD_FILE_TYPE_VIDEO;
    [[FileUploadService getInstance] uploadVideoFiles:videoFiles listener:self];
}

- (void) onUploadFileError:(NSURLResponse *)response error:(NSError *)error {
    [self hideLoadingDialog];
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"file_submit_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}

- (void) onUploadFileFinished:(NSURLResponse *)response object:(id)responseObject {
    switch(_uploadType) {
        case UPLOAD_FILE_TYPE_AUDIO:
            if(!_audioReponseIds) {
                _audioReponseIds = [[NSMutableArray alloc] init];
            } else {
                [_audioReponseIds removeAllObjects];
            }
            for(NSNumber *aid in responseObject) {
                [_audioReponseIds addObject:aid];
            }
            if (_photoArray.count > 0) {
                [self uploadImage];
            } else if (_videoArray.count > 0) {
                [self uploadVideo];
            } else {
                [self requestUploadQuickReport];
            }
            break;
        case UPLOAD_FILE_TYPE_PHOTO:
            if(!_photoReponseIds) {
                _photoReponseIds = [[NSMutableArray alloc] init];
            } else {
                [_photoReponseIds removeAllObjects];
            }
            for(NSNumber *pid in responseObject) {
                [_photoReponseIds addObject:pid];
            }
            if (_videoArray.count > 0) {
                [self uploadVideo];
            } else {
                [self requestUploadQuickReport];
            }
            break;
        case UPLOAD_FILE_TYPE_VIDEO:
            if(!_videoReponseIds) {
                _videoReponseIds = [[NSMutableArray alloc] init];
            } else {
                [_videoReponseIds removeAllObjects];
            }
            for(NSNumber *vid in responseObject) {
                [_videoReponseIds addObject:vid];
            }
            [self requestUploadQuickReport];
            break;
    }
}

#pragma mark - Click Event
- (void)onMenuItemClicked:(NSInteger)position {
    [self uploadQuickReportInfo];
}

- (void)onAddMoreBtnClick:(UIButton *) sender {
    _operateType = QUICK_REPORT_OPERATION_ADD_BTN;
    [_alertView showType:@"addmoreMedia"];
    [_alertView show];
}

- (void) tryToTakePhoto {
    [_cameraHelper takePhotoWithWaterMark:nil];
}

- (void) tryToPickImage {
    [_cameraHelper pickImageWithWaterMark:nil];
}

- (void)showRecordControlView {
    _operateType = QUICK_REPORT_OPERATION_AUDIO_RECORDING;
    [_audioRecordAlertView clearAll];
    [_alertView showType:@"audioRecording"];
    [_alertView show];
}

- (void) tryToTakeVideo {
    VideoTakeViewController * videoVC = [[VideoTakeViewController alloc] init];
    [videoVC setOnMessageHanleListener:self];
    [self gotoViewController:videoVC];
}

#pragma mark - OnQrCodeScanFinishedListener
- (void) onQrCodeScanFinished:(NSString *)result {
    _backFromQrcode = YES;
    _equipQrcode = [[EquipmentQrcode alloc] initWithString:result];
}

- (void) handleQrcodeResult {
    if(_equipQrcode && [_equipQrcode isValidQrcode]) {
        NSNumber *eqId = [_equipQrcode getEquipmentId];
        for (Device *dev in _equipmentArray) {
            if ([eqId isEqualToNumber:dev.eqId]) {
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"asset_qrcode_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                return;
                break;
            }
        }
        if(![FMUtils isNumberNullOrZero:eqId]) {
            Device *dev = [_dbHelper queryDeviceById:eqId];
            if(dev) {
                [_equipmentArray addObject:dev];
                [self updateList];
            } else {
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"download_notice_download" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"asset_qrcode_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"asset_qrcode_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

#pragma mark - OnClickListener
- (void)onClick:(UIView *)view {
    if([view isKindOfClass:[TaskAlertView class]]) {
        if(_displayLink) {
            [self setShowWaveForm:NO];
        }
        [_alertView close];
    }
}

#pragma mark - OnItemClickListener
- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    NSInteger tag = subView.tag;
    if ([view isKindOfClass:[AddMoreAlertView class]]) {
        ButtonType buttonType = tag;
        switch (buttonType) {
            case BUTTON_TYPE_IMAGE:
                [self tryToPickImage];
                [_alertView close];
                break;
            case BUTTON_TYPE_CAMERA:
                [self tryToTakePhoto];
                [_alertView close];
                break;
            case BUTTON_TYPE_AUDIO:
                [self showRecordControlView];
                break;
            case BUTTON_TYPE_MEDIA:
                [self tryToTakeVideo];
                [_alertView close];
                break;
        }
        
    } else if ([view isKindOfClass:[AudioRecordAlertView class]]) {
        RecordButtonType type = tag;
        switch (type) {
            case RECORD_BUTTON_TYPE_START:{
                if(!_displayLink) {         //开始录音
                    [self setShowWaveForm:YES];
                }
                [self tryToStratRecording];
            }
                break;
            case RECORD_BUTTON_TYPE_STOP:   //停止录音
                if(_displayLink) {
                    [self setShowWaveForm:NO];
                }
                [self tryToStopRecording];
                break;
            case RECORD_BUTTON_TYPE_PLAY:   //播放录音
                [self setShowWaveForm:YES];
                [self tryToPlayRecord];
                break;
            case RECORD_BUTTON_TYPE_PAUSE:  //暂停播放
                [self setShowWaveForm:NO];
                [self tryToPauseRecord];
                break;
            case RECORD_BUTTON_CANCEL:      //取消录音
                [self tryToCancelRecord];
                break;
            case RECORD_BUTTON_DONE:    //保存录音
                [self tryToSaveRecord];
                break;
        }
    } else if ([view isKindOfClass:[AudioPlayAlertView class]]) {
        PlayBtnType type = tag;
        switch (type) {
            case PLAY_BUTTON_TYPE_PLAY:
                [self playRecordWithPosition];
                break;
            case PLAY_BUTTON_TYPE_STOP:
                [_audioPlayAlertView clearAll];
                [self pauseRecordWithPosition];
                break;
            default:
                break;
        }
    }
}

- (void)playRecordWithPosition {
    [_audioPlayer play];
    _isPlaying = YES;
}

- (void)pauseRecordWithPosition {
    [_audioPlayer stop];
    _isPlaying = NO;
}


- (NSURL *)getTmpURL {
    NSDate *now = [NSDate date];
    NSNumber *curTime = [FMUtils dateToTimeLong:now];
    NSString *soundFilePath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"FM%lldsound.caf",[curTime longLongValue]]];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    _recordFilePath = soundFilePath;
    return newURL;
}

//开始录音
- (void) tryToStratRecording {
    if(!_isRecording) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _isRecording = YES;
            _mp3Recorder = nil;
            NSError *error;
            _mp3Recorder = [[AVAudioRecorder alloc] initWithURL:[self getTmpURL] settings:_recorderSettings error:&error];
            [_mp3Recorder setMeteringEnabled:YES];
            [_mp3Recorder prepareToRecord];
            [_mp3Recorder record];
        });
    }
}

//停止录音
- (void) tryToStopRecording {
    if(_isRecording) {
        _isRecording = NO;
        NSTimeInterval duration = [_mp3Recorder currentTime];
        _recordTimeInterval = [NSNumber numberWithFloat:duration];
        [_mp3Recorder stop];
    }
}

//开始播放录音
- (void)tryToPlayRecord {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *activationErr  = nil;
        NSError *setCategoryErr = nil;
        
        [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
        
        NSURL *audioUrl = [NSURL URLWithString:_recordFilePath];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
        _audioPlayer.delegate = self;
        
        [_audioPlayer prepareToPlay];
        [_audioPlayer setMeteringEnabled:YES];
        [_audioPlayer play];
        
        _isPlaying = YES;
    });
}

//暂停播放录音
- (void)tryToPauseRecord {
    if (_isPlaying) {
        [_audioPlayer stop];
        _isPlaying = NO;
    }
}

//取消录音
- (void)tryToCancelRecord {
    [_audioRecordAlertView clearAll];
    [self setShowWaveForm:NO];
    [_alertView close];
}

//保存录音
- (void)tryToSaveRecord {
    [_audioArray addObject:_recordFilePath];
    [_audioTimeArray addObject:_recordTimeInterval];
    [self coverToMP3:_recordFilePath];  //开异步线程 转化为mp3
    [self setShowWaveForm:NO];
    [_alertView close];
    [self updateList];
}

- (void)coverToMP3:(NSString *)filePath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self) weakSelf = self;
        coverToMP3([NSURL URLWithString:filePath], ^(NSURL *mp3Url) {
            [weakSelf.audioMP3Array addObject:mp3Url];
        });
    });
}


//设置波形图的展示
- (void)setShowWaveForm:(BOOL)show{
    if(show) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMetersForView)]; //将cadisplaylink添加到runloop中
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_displayLink invalidate]; //从runloop中移除
            _displayLink = nil;
        });
    }
}

- (void) updateMetersForView {
    CGFloat power = 0.0f;
    if (!_isPlaying && _isRecording) {
        [_mp3Recorder updateMeters];
        power = [_mp3Recorder averagePowerForChannel:0];
    }
    
    if ((_isPlaying&&!_isRecording) || (_isPlaying && _isRecording)) {
        [_audioPlayer updateMeters];
        power = [_audioPlayer averagePowerForChannel:0];
    }
    
    [_audioRecordAlertView updateMetersWithAveragePower:power];
}

#pragma mark - AVAudioPlayerDelegate
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(_isPlaying) {
        _isPlaying = NO;
        [_audioPlayAlertView clearAll];
//        [self pauseRecordWithPosition:_audioPosition];
    }
}

#pragma mark - OnMessageHandleListener
- (void)handleMessage:(id)msg {
    NSString *strOrigin = [msg valueForKeyPath:@"msgOrigin"];
    id result;
    if ([strOrigin isEqualToString:NSStringFromClass([CameraHelper class])]) {
        NSArray *imgPaths = [msg valueForKeyPath:@"result"];
        for (NSString *path in imgPaths) {
            UIImage *img = [FMUtils getImageWithName:path];
            [_photoArray addObject:img];
        }
        [self updateList];
    } else if ([strOrigin isEqualToString:NSStringFromClass([VideoTakeViewController class])]){
        //视频
        NSURL *url = [msg valueForKeyPath:@"url"];
        UIImage *img = [FMUtils thumbnailWithAssetUrl:url time:1];
        PhotoItem * item = [[PhotoItem alloc] init];
        //存放用于上传视频的url
        [item setImage:img];
        [item setOrigin:PHOTO_ORIGIN_VIDEO];
        [item setOriginUrl:url];
        [_videoArray addObject:item];
        [self updateList];
    } else if ([strOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]){
        InfoSelectRequestType requestType = [[msg valueForKeyPath:@"requestType"] integerValue];
        switch (requestType) {
            case REQUEST_TYPE_SERVICE_TYPE_INFO_SELECT:{  //服务类型
                result = [msg valueForKeyPath:@"result"];
                if (result) {
                    ServiceType * serviceType = [result valueForKeyPath:@"serviceType"];
                    if (serviceType) {
                        _baseInfo.serviceType = serviceType;
                    }
                }
                [self updateList];
            }
                break;
                
            case REQUEST_TYPE_LOCATION_INFO_SELECT:{  //站点
                result = [msg valueForKeyPath:@"result"];
                if (result) {
                    Position *pos = [result valueForKeyPath:@"position"];
                    if(!pos || [pos isNull]) {
                        pos = [_dbHelper getDefaultPosition];
                    }
                    if(pos) {
                        _baseInfo.location = pos;
                    }
                }
                [self updateList];
            }
                break;
            case REQUEST_TYPE_DEVICE_INFO_SELECT:{  //设备选择
                Device *device = [msg valueForKeyPath:@"result"];
                if (device) {
                    if(![self isDeviceExist:device.eqId]) {
                        [_equipmentArray addObject:device];
                        [self updateList];
                    } else {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_equipment_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                        });
                    }
                }
            }
                break;
            default:
                break;
        }
    }
}

- (BOOL) isDeviceExist:(NSNumber *) deviceId {
    BOOL res = NO;
    for(Device *dev in _equipmentArray) {
        if(dev.eqId && [deviceId isEqualToNumber:dev.eqId]) {
            res= YES;
            break;
        }
    }
    return res;
}

//播放视频
- (void)gotoShowVideo:(NSInteger)position {
    MediaViewController *mediaVC = [[MediaViewController alloc] init];
    PhotoItem *video = _videoArray[position];
    [mediaVC setUrl:video.originUrl];
    [self gotoViewController:mediaVC];
}

- (void)gotoShowPhoto:(NSInteger)position {
    [_photoShowHelper setPhotos:_photoArray];
    [_photoShowHelper showPhotoWithIndex:position];
}

@end
