//
//  NewRequirementViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 6/30/16.
//  Copyright © 2016 flynn. All rights reserved.
//

#import "NewRequirementViewController.h"
#import <sys/sysctl.h>  //此两条用于查看系统内存占用情况
#import <mach/mach.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "InfoSelectViewController.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "MLAudioRecorder.h"           //音频解码播放类
#import "CafRecordWriter.h"
#import "AmrRecordWriter.h"
#import "Mp3RecordWriter.h"
#import "MLAudioMeterObserver.h"
#import "MLAudioPlayer.h"
#import "AmrPlayerReader.h"
#import "Debug.h"
#import "BaseBundle.h"

#import "ServiceCenterNetRequest.h"    //实体类与一些网络config
#import "ServiceCenterServerConfig.h"
#import "WorkOrderServerConfig.h"
#import "FileUploadService.h"
#import "SystemConfig.h"
#import "UploadConfig.h"
#import "UserEntity.h"
#import "NewDemandEntity.h"
#import "BaseDataEntity.h"
#import "BaseDataDbHelper.h"

#import "RequirementBaseInfoView.h"    //tableView子视图
#import "CellForAudioRecordView.h"
#import "PhotoItem.h"
#import "MediaViewController.h"
#import "DXAlertView.h"
#import "SeperatorView.h"

#import "TaskAlertView.h"              //弹出框视图
#import "AddMoreAlertView.h"
#import "AudioRecordAlertView.h"
#import "AudioPlayAlertView.h"
#import "VideoTakeViewController.h"
#import "BaseLabelView.h"
#import "RequirementManagerBusiness.h"
#import "CaptionTextField.h"
#import "CaptionTextView.h"
#import "BasePhotoView.h"
#import "CameraHelper.h"
#import "PhotoShowHelper.h"

#import "PerformanceUploader.h"

typedef NS_ENUM(NSInteger, NewRequireMentSectionType) {
    SECTION_TYPE_COMMON,
    SECTION_TYPE_IMG,
    SECTION_TYPE_AUDIO,
    SECTION_TYPE_MEDIA,
    SECTION_TYPE_UNKNOW,
};

typedef NS_ENUM(NSInteger, InfoViewType) {
    ADDMORE_MEDIA_ALERT_VIEW,
    ADUIO_RECORD_ALERT_VIEW,
    AUDIO_PLAY_ALERT_VIEW,
};

@interface NewRequirementViewController () <UINavigationControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UIImagePickerControllerDelegate,OnClickListener, OnViewResizeListener, OnMessageHandleListener, OnItemClickListener, FileUploadListener>
/**
 *  全局控件
 */
@property (readwrite, nonatomic, strong) UIView * mainContainer; //主容器
//@property (readwrite, nonatomic, strong) UITableView * mainTableView;
@property (readwrite, nonatomic, strong) UIScrollView * mainScrollView;
@property (readwrite, nonatomic, strong) UIButton * addMoreBtn;  //添加更多按钮

@property (readwrite, nonatomic, strong) CaptionTextField * applicantTF;    //申请人
@property (readwrite, nonatomic, strong) CaptionTextField * telnoTF;    //联系电话
@property (readwrite, nonatomic, strong) CaptionTextField * typeTF;     //需求类型
@property (readwrite, nonatomic, strong) CaptionTextView * descTF;      //需求描述

@property (readwrite, nonatomic, strong) TaskAlertView * infoView;  //提醒弹出View (四个按钮)
@property (readwrite, nonatomic, strong) AddMoreAlertView * addMoreView; //提醒弹出View (四个按钮)
@property (readwrite, nonatomic, strong) AudioRecordAlertView * audioRecordAlertView; //提醒弹出View (录音界面)
@property (readwrite, nonatomic, strong) AudioPlayAlertView * audioPlayAlertView; //提醒弹出View (录音播放界面)
@property (readwrite, nonatomic, assign) NSInteger  infoViewType;


@property (readwrite, nonatomic, strong) BasePhotoView * photoItemView; //图片展示
@property (readwrite, nonatomic, strong) CameraHelper * cameraHelper;
@property (readwrite, nonatomic, strong) PhotoShowHelper * photoHelper;


@property (readwrite, nonatomic, strong) CellForAudioRecordView * audioRecordView; //音频cell视图
@property (readwrite, nonatomic, strong) BasePhotoView * videoRecordView; //视频展示

@property (readwrite, nonatomic, strong) BaseLabelView * photoHeaderView;  //图片
@property (readwrite, nonatomic, strong) BaseLabelView * audioHeaderView;  //音频
@property (readwrite, nonatomic, strong) BaseLabelView * videoHeaderView;  //视频

@property (readwrite, nonatomic, strong) NSMutableArray * photoIds; //图片ID 数组
@property (readwrite, nonatomic, strong) NSMutableArray * audioIds; //音频ID 数组
@property (readwrite, nonatomic, strong) NSMutableArray * videoIds; //视频ID 数组

@property (readwrite, nonatomic, strong) NSMutableArray * audioViewArray;   //音频视图
@property (readwrite, nonatomic, strong) NSMutableArray * seperatorArray;   //分割线数组
/**
 *  录音和播放控件
 */
@property (nonatomic, strong) AVAudioRecorder * recoderOfSystem;  //系统Record用于播放
@property (nonatomic, strong) MLAudioRecorder * uploadRecorder; //用于上传的recorder
@property (nonatomic, strong) Mp3RecordWriter * mp3Writer;
@property (nonatomic, strong) MLAudioMeterObserver * meterObserver;
@property (nonatomic, strong) NSString * upLoadFilePath;   //用于上传的音频路径

@property (nonatomic, strong) AVAudioPlayer * playerOfSystem;  //播放控件
@property (nonatomic, strong) NSURL * playFileURL;
@property (nonatomic, strong) CADisplayLink * displayLink;

/**
 *  全局参数信息
 */
@property (readwrite, nonatomic, strong) NSMutableArray * audioRecordUploadArray; //存放上传录音path的数组
@property (readwrite, nonatomic, strong) NSMutableArray * audioRecordPlayArray; //存放播放录音的path的数组
@property (readwrite, nonatomic, strong) NSMutableArray * audioRecordTimeArray; //存放每个录音时长的数组
@property (readwrite, nonatomic, strong) NSString * tmpAudioUploadPath;
@property (readwrite, nonatomic, strong) NSString * tmpAudioPlayPath;
@property (readwrite, nonatomic, strong) NSNumber * tmpAudioTime;

@property (readwrite, nonatomic, assign) NSInteger audioPosition;   //用于确定是第几个音频
//@property (readwrite, nonatomic, assign) NSInteger currentRow;
//@property (readwrite, nonatomic, assign) NSInteger currentSection;

@property (readwrite, nonatomic, strong) NSMutableArray * photos;
@property (readwrite, nonatomic, strong) NSMutableArray * videos;

@property (readwrite, nonatomic, assign) CGFloat headerHeight;  //section头的高度
@property (readwrite, nonatomic, assign) CGFloat infoViewHeight;  //alert界面的高度

@property (readwrite, nonatomic, assign) CGFloat realHeight; //显示框整体高度
@property (readwrite, nonatomic, assign) CGFloat realWidth; //显示框整体宽度

@property (readwrite, nonatomic, assign) BOOL isRecording;  //是否正在录音
@property (readwrite, nonatomic, assign) BOOL isPlaying;  //是否正在播放

@property (readwrite, nonatomic, strong) NewDemandDetail * demandDetail;  //数据实体
@property (readwrite, nonatomic, strong) RequirementType * reqType;       //数据实体

@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultDescHeight;
@property (readwrite, nonatomic, assign) CGFloat photoItemHeight;
@property (readwrite, nonatomic, assign) CGFloat audioItemHeight;
@property (readwrite, nonatomic, assign) CGFloat videoItemHeight;

@property (readwrite, nonatomic, assign) CGFloat footerHeight;

@property (readwrite, nonatomic, assign) NSInteger operateTag;
@property (readwrite, nonatomic, strong) RequirementManagerBusiness * business;

@end

@implementation NewRequirementViewController

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_requirement_create" inTable:nil]];
    [self setBackAble:YES];
    NSMutableArray * menueArray = [[NSMutableArray alloc] init];
    NSString * strOK = [[BaseBundle getInstance] getStringByKey:@"btn_title_submit" inTable:nil];
    [menueArray addObject:strOK];
    [self setMenuWithTextArray:menueArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
    [self updateLayout];
    
    _cameraHelper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:YES];
    [_cameraHelper setOnMessageHandleListener:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initAlertView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"！！！！！-----内存低，请及时释放-----！！！！！");
    NSLog(@"Now the iPhone is using memory of %f",[self usedMemory]);
}

- (double)usedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

- (void) initParameters {
    _headerHeight = [FMSize getInstance].listHeaderHeight;
    _isRecording = NO;
    _isPlaying = NO;
    
    _defaultItemHeight = 92;
    _defaultDescHeight = 174;
    _photoItemHeight = 120;
    _audioItemHeight = 58;
    _videoItemHeight = 120;
    _footerHeight = [FMSize getInstance].listFooterHeight;
    
    
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    _audioRecordUploadArray = [[NSMutableArray alloc] init];
    _audioRecordPlayArray = [[NSMutableArray alloc] init];
    _audioRecordTimeArray = [[NSMutableArray alloc] init];
    
    _photos = [[NSMutableArray alloc] init];
    _videos = [[NSMutableArray alloc] init];
    
    _demandDetail = [[NewDemandDetail alloc] init];   //初始化一下实体
    _dbHelper = [BaseDataDbHelper getInstance];
    _reqType = [[RequirementType alloc] init];
    
    _business = [RequirementManagerBusiness getInstance];
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    
}

- (void) initLayout {
    if(!_mainContainer) {
        [self initParameters];
        
        CGRect mframe = [self getContentFrame];
        CGFloat width = CGRectGetWidth(mframe);
        CGFloat height = CGRectGetHeight(mframe);
        CGFloat padding = [FMSize getInstance].defaultPadding;
        
        _realHeight = CGRectGetHeight(mframe);
        _realWidth = CGRectGetWidth(mframe);
        _infoViewHeight = CGRectGetHeight(self.view.frame);
        
        _mainContainer = [[UIView alloc] initWithFrame:mframe];
        
        _mainScrollView = [[UIScrollView alloc] init];
        [_mainScrollView setFrame:CGRectMake(0, 0, mframe.size.width, mframe.size.height)];
        _mainScrollView.delaysContentTouches = NO;
        

        CGFloat originY = 0;
        CGFloat sepHeight = 0;
        
        CGFloat itemHeight = _defaultItemHeight;
        _applicantTF = [[CaptionTextField alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        [_applicantTF setDetegate:self];
        [_applicantTF setTitle: [[BaseBundle getInstance] getStringByKey:@"requirement_req_person" inTable:nil]];
        [_applicantTF setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"requirement_req_person_placeholder" inTable:nil]];
        [_applicantTF setShowMark:YES];
        [_applicantTF setEditable:NO];
        originY += itemHeight + sepHeight;
        
        itemHeight = _defaultItemHeight;
        _telnoTF = [[CaptionTextField alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        [_telnoTF setDetegate:self];
        [_telnoTF setTitle: [[BaseBundle getInstance] getStringByKey:@"requirement_req_phone" inTable:nil]];
        [_telnoTF setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"requirement_req_phone_placeholder" inTable:nil]];
        [_telnoTF setShowMark:YES];
        originY += itemHeight + sepHeight;
        
        itemHeight = _defaultItemHeight;
        _typeTF = [[CaptionTextField alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        [_typeTF setDetegate:self];
        [_typeTF setTitle: [[BaseBundle getInstance] getStringByKey:@"requirement_req_type" inTable:nil]];
        [_typeTF setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"requirement_req_type_placeholder" inTable:nil]];
        [_typeTF setShowMark:YES];
        [_typeTF setEditable:NO];
        [_typeTF setOnClickListener:self];
        originY += itemHeight + sepHeight;
        
        itemHeight = _defaultDescHeight;
        _descTF = [[CaptionTextView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        [_descTF setFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        [_descTF setTitle: [[BaseBundle getInstance] getStringByKey:@"requirement_req_desc" inTable:nil]];
        [_descTF setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"requirement_req_desc_placeholder" inTable:nil]];
        [_descTF setOnViewResizeListener:self];
        [_descTF setShowMark:YES];
        originY += itemHeight + sepHeight;
        
        _photoItemView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, width, _photoItemHeight)];
        [_photoItemView setEditable:YES];
        [_photoItemView setEnableAdd:NO];
        [_photoItemView setOnMessageHandleListener:self];
        _photoItemView.tag = SECTION_TYPE_IMG;
        
        _videoRecordView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, width, _photoItemHeight)];
        [_videoRecordView setEditable:YES];
        [_videoRecordView setEnableAdd:NO];
        [_videoRecordView setOnMessageHandleListener:self];
        _videoRecordView.tag = SECTION_TYPE_MEDIA;
        
        _photoHeaderView = [[BaseLabelView alloc] init];
        [_photoHeaderView setContentFont:[FMFont setFontByPX:44]];
        [_photoHeaderView setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        [_photoHeaderView setContent: [[BaseBundle getInstance] getStringByKey:@"requirement_headlbl_picture" inTable:nil]];
        _photoHeaderView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _audioHeaderView = [[BaseLabelView alloc] init];
        [_audioHeaderView setContentFont:[FMFont setFontByPX:44]];
        [_audioHeaderView setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        [_audioHeaderView setContent: [[BaseBundle getInstance] getStringByKey:@"requirement_headlbl_audio" inTable:nil]];
        _audioHeaderView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _videoHeaderView = [[BaseLabelView alloc] init];
        [_videoHeaderView setContentFont:[FMFont setFontByPX:44]];
        [_videoHeaderView setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        [_videoHeaderView setContent: [[BaseBundle getInstance] getStringByKey:@"requirement_headlbl_video" inTable:nil]];
        _videoHeaderView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        _audioViewArray = [[NSMutableArray alloc] init];
        _seperatorArray = [[NSMutableArray alloc] init];
        
        
        //添加按钮
        CGFloat btnWidth = [FMSize getInstance].filterWidth;
        _addMoreBtn = [[UIButton alloc] init];
        [_addMoreBtn addTarget:self action:@selector(addMore) forControlEvents:UIControlEventTouchUpInside];
        [_addMoreBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"add_normal"] forState:UIControlStateNormal];
        [_addMoreBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"add_highlight"] forState:UIControlStateHighlighted];
        _addMoreBtn.layer.cornerRadius = btnWidth/2;
        _addMoreBtn.layer.masksToBounds = YES;
        [_addMoreBtn setFrame:CGRectMake(width-btnWidth-padding, height-btnWidth-padding, btnWidth, btnWidth)];
        
        _mainScrollView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _photoItemView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _videoRecordView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [_mainScrollView addSubview:_applicantTF];
        [_mainScrollView addSubview:_telnoTF];
        [_mainScrollView addSubview:_typeTF];
        [_mainScrollView addSubview:_descTF];
        
        [_mainScrollView addSubview:_photoHeaderView];
        [_mainScrollView addSubview:_photoItemView];
        [_mainScrollView addSubview:_audioHeaderView];
        [_mainScrollView addSubview:_videoHeaderView];
        [_mainScrollView addSubview:_videoRecordView];
        
        [_mainContainer addSubview:_mainScrollView];
        [_mainContainer addSubview:_addMoreBtn];
        
        
        [self.view addSubview:_mainContainer];
        
        [self updateInfo];
        [self initUserInfo];
    }
}

- (void) updateLayout {
    
    CGFloat itemHeight = 0;
    NSInteger seperatorIndex = 0;
    SeperatorView * seperator;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = 0;
    CGFloat originY = padding;
    
    itemHeight = _defaultItemHeight;
    [_applicantTF setFrame:CGRectMake(padding, originY, _realWidth - padding*2, itemHeight)];
    originY += itemHeight;
    

    itemHeight = _defaultItemHeight;
    [_telnoTF setFrame:CGRectMake(padding, originY, _realWidth - padding*2, itemHeight)];
    originY += itemHeight;
    
    itemHeight = _defaultItemHeight;
    [_typeTF setFrame:CGRectMake(padding, originY, _realWidth - padding*2, itemHeight)];
    originY += itemHeight;
    
    itemHeight = CGRectGetHeight(_descTF.frame);
    if(itemHeight == 0) {
        itemHeight = _defaultDescHeight;
    }
    [_descTF setFrame:CGRectMake(padding, originY, _realWidth - padding*2, itemHeight)];
    originY += itemHeight;
    
    
    BOOL needSeperator = NO;
    if([_photos count] > 0) {
        [_photoHeaderView setFrame:CGRectMake(padding, originY, _realWidth-padding*2, _headerHeight)];
        originY += _headerHeight;
        
        _photoItemHeight = [BasePhotoView calculateHeightByCount:[_photos count] width:_realWidth addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
        [_photoItemView setFrame:CGRectMake(padding, originY, _realWidth-padding*2, _photoItemHeight)];
        originY += _photoItemHeight;
        
        [_photoHeaderView setHidden:NO];
        [_photoItemView setHidden:NO];
        needSeperator = YES;
    } else {
        [_photoHeaderView setHidden:YES];
        [_photoItemView setHidden:YES];
    }
    
    if([_audioRecordUploadArray count] > 0) {
        if(needSeperator) {
            needSeperator = NO;
            if(seperatorIndex < [_seperatorArray count]) {
                seperator = _seperatorArray[seperatorIndex];
                [seperator setHidden:NO];
            }
            if(!seperator) {
                seperator = [[SeperatorView alloc] init];
                [_seperatorArray addObject:seperator];
                [_mainScrollView addSubview:seperator];
            }
            if(seperator) {
                [seperator setFrame:CGRectMake(padding, originY-seperatorHeight, _realWidth-padding*2, seperatorHeight)];
            }
            seperatorIndex++;
        }
        
        [_audioHeaderView setFrame:CGRectMake(padding, originY, _realWidth-padding*2, _headerHeight)];
        originY += _headerHeight;
        
        NSInteger count = [_audioRecordUploadArray count];
        NSInteger index = 0;
        for(;index<count;index++) {
            CellForAudioRecordView * audioView;
            if(index < [_audioViewArray count]) {
                audioView = _audioViewArray[index];
                [audioView setHidden:NO];
            }
            if(!audioView) {
                audioView = [[CellForAudioRecordView alloc] init];
                audioView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
                [audioView setOnItemClickListener:self];
                [_audioViewArray addObject:audioView];
                [_mainScrollView addSubview:audioView];
            }
            
            [audioView setFrame:CGRectMake(padding, originY, _realWidth-padding*2, _audioItemHeight)];
            audioView.tag = index;
            NSNumber * duriation = _audioRecordTimeArray[index];
            [audioView setDuriationTime:duriation];
            
            originY += _audioItemHeight;
            
//            seperator = nil;
//            if(seperatorIndex < [_seperatorArray count]) {
//                seperator = _seperatorArray[seperatorIndex];
//                [seperator setHidden:NO];
//            }
//            if(!seperator) {
//                seperator = [[SeperatorView alloc] init];
//                [_seperatorArray addObject:seperator];
//                [_mainScrollView addSubview:seperator];
//            }
//            if(seperator) {
//                [seperator setFrame:CGRectMake(padding, originY, _realWidth-padding*2, seperatorHeight)];
//                originY += seperatorHeight;
//            }
//            seperatorIndex++;
        }
        for(;index < [_audioViewArray count];index++) {
            UIView * view = _audioViewArray[index];
            [view setHidden:YES];
        }
        [_audioHeaderView setHidden:NO];
    } else {
        [_audioHeaderView setHidden:YES];
        for(UIView * view in _audioViewArray) {
            [view setHidden:YES];
        }
    }
    
    if([_videos count] > 0) {
        if(needSeperator) {
            needSeperator = NO;
            seperator = nil;
            if(seperatorIndex < [_seperatorArray count]) {
                seperator = _seperatorArray[seperatorIndex];
                [seperator setHidden:NO];
            }
            if(!seperator) {
                seperator = [[SeperatorView alloc] init];
                [_seperatorArray addObject:seperator];
                [_mainScrollView addSubview:seperator];
            }
            if(seperator) {
                [seperator setFrame:CGRectMake(padding, originY-seperatorHeight, _realWidth-padding*2, seperatorHeight)];
            }
            seperatorIndex++;
        }
        
        [_videoHeaderView setFrame:CGRectMake(padding, originY, _realWidth-padding*2, _headerHeight)];
        originY += _headerHeight;
        
        _videoItemHeight = [BasePhotoView calculateHeightByCount:[_videos count] width:_realWidth addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
        [_videoRecordView setFrame:CGRectMake(padding, originY, _realWidth-padding*2, _videoItemHeight)];
        originY += _videoItemHeight;
        
        [_videoRecordView setPhotosWithArray:_videos];
        
        [_videoHeaderView setHidden:NO];
        [_videoRecordView setHidden:NO];
        
        needSeperator = YES;
    } else {
        [_videoHeaderView setHidden:YES];
        [_videoRecordView setHidden:YES];
    }
    
    if(needSeperator) {
        needSeperator = NO;
        seperator = nil;
        if(seperatorIndex < [_seperatorArray count]) {
            seperator = _seperatorArray[seperatorIndex];
            [seperator setHidden:NO];
        }
        if(!seperator) {
            seperator = [[SeperatorView alloc] init];
            [_seperatorArray addObject:seperator];
            [_mainScrollView addSubview:seperator];
        }
        if(seperator) {
            [seperator setFrame:CGRectMake(padding, originY-seperatorHeight, _realWidth-padding*2, seperatorHeight)];
        }
        seperatorIndex++;
    }
    for(;seperatorIndex<[_seperatorArray count];seperatorIndex++) { //隐藏多余的分割线
        seperator = _seperatorArray[seperatorIndex];
        if(seperator) {
            [seperator setHidden:YES];
        }
    }
    _mainScrollView.contentSize = CGSizeMake(_realWidth, originY);
}


- (void) initAlertView {
    if(!_infoView) {
        _infoView = [[TaskAlertView alloc] init];
        [_infoView setFrame:CGRectMake(0, 0, _realWidth, _infoViewHeight)];
        [_infoView setHidden:YES];
        [_infoView setOnClickListener:self];
        
        //四个按钮
        _addMoreView = [[AddMoreAlertView alloc] init];
        _addMoreView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_addMoreView setOnItemClickListener:self];
        
        //录音界面
        _audioRecordAlertView = [[AudioRecordAlertView alloc] init];
        _audioRecordAlertView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_audioRecordAlertView setOnItemClickListener:self];
        
        //录音播放界面
        _audioPlayAlertView = [[AudioPlayAlertView alloc] init];
        _audioPlayAlertView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_audioPlayAlertView setOnItemClickListener:self];
        
        
        
        //多媒体按钮
        [_infoView setContentView:_addMoreView withKey:@"addmoreMedia" andHeight:self.view.frame.size.height*0.205 andPosition:ALERT_CONTENT_POSITION_BOTTOM];
        //录音
        [_infoView setContentView:_audioRecordAlertView withKey:@"audioRecord" andHeight:[AudioRecordAlertView getRecordViewHeight] andPosition:ALERT_CONTENT_POSITION_BOTTOM];
        //录音播放
        [_infoView setContentView:_audioPlayAlertView withKey:@"audioPlay" andHeight:[AudioPlayAlertView getPlayViewHeight] andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    }
    
    [self.view addSubview:_infoView];
}

- (void) updateInfo {
    NSMutableArray * allTypes = [[NSMutableArray alloc] init];
    allTypes = [_dbHelper queryAllRequirementTypesOfCurrentProject];
    if ([allTypes count] <= 0) {
        [self noticeDownloadBaseData];
    }
}

- (void) initUserInfo {
    NSInteger userId = [[SystemConfig getOauthFM] getUserInfo].userId;
    NSString * userName;
    UserInfo * user = [_dbHelper queryUserById:[NSNumber numberWithInteger:userId]];
    if(user) {
        userName = user.name;
        if([FMUtils isStringEmpty:userName]) {
            userName = user.loginName;
        }
        if(!userName) {
            userName = @"";
        }
        [_applicantTF setText:userName];
        [_telnoTF setText:user.phone];
    } else {
        NSString *loginName = [SystemConfig getLoginName];
        [_applicantTF setText:loginName];
    }
}

#pragma mark 屏幕点击位置监听
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取屏幕点击位置来判断谁是第一相应
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:_addMoreView];
    CGPoint touchPoint2 = [touch locationInView:_audioRecordAlertView];
    CGPoint touchPoint3 = [touch locationInView:_audioPlayAlertView];
    switch (_infoViewType) {
        case ADDMORE_MEDIA_ALERT_VIEW:
            if (touchPoint.y < 0) {
                [self resetWorking];
            }
            break;
            
        case ADUIO_RECORD_ALERT_VIEW:
            if (!_isRecording) {
                if (touchPoint2.y < 0) {
                    [self resetWorking];
                    [self setShowWaveForm:NO];
                }
            }
            break;
            
        case AUDIO_PLAY_ALERT_VIEW:
            if (!_isPlaying) {
                if (touchPoint3.y < 0) {
                    [self resetWorking];
//                    [self setShowWaveForm:NO];
                }
            }
            break;
    }
}

- (void) noticeDownloadBaseData {
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"download_notice_download" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}

#pragma mark handleMessage
- (void) handleMessage:(id)msg {
    NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
    if([strOrigin isEqualToString:@"InfoSelectViewController"]) {
        InfoSelectRequestType requestType = [[msg valueForKeyPath:@"requestType"] integerValue];
        RequirementType * requirement;
        switch (requestType) {
            case REQUEST_TYPE_REQUIREMENT_TYPE_INFO_SELECT:
                requirement = [msg valueForKeyPath:@"result"];
                if (requirement) {
                    _reqType.typeId = requirement.typeId;
                    _reqType.name = requirement.name;
                    _reqType.fullName = requirement.fullName;
                    if (requirement.parentTypeId) {
                        _reqType.parentTypeId = requirement.parentTypeId;
                    } else {
                        _reqType.parentTypeId = nil;
                    }
                    [_typeTF setText:_reqType.fullName];
                }
                break;
                
            default:
                break;
        }
    } else if([strOrigin isEqualToString:@"VideoTakeViewController"]) {
        //视频
        NSURL * url = [msg valueForKeyPath:@"url"];
        UIImage * img = [FMUtils thumbnailWithAssetUrl:url time:1];
        
        PhotoItem * item = [[PhotoItem alloc] init];
        //存放用于上传视频的url
        [item setImage:img];
        [item setOrigin:PHOTO_ORIGIN_VIDEO];
        [item setOriginUrl:url];
        [_videos addObject:item];
        
        [self updateLayout];
        [self resetWorking];
    } else if ([strOrigin isEqualToString:NSStringFromClass([BasePhotoView class])]) {
        NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
        PhotoActionType type = [tmpNumber integerValue];
        tmpNumber = [msg valueForKeyPath:@"tag"];
        NSInteger tag = tmpNumber.integerValue;
        if(tag == SECTION_TYPE_IMG) {
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [_photoHelper setPhotos:_photos];
                    [_photoHelper showPhotoWithIndex:tmpNumber.integerValue];
                    break;
                case PHOTO_ACTION_DELETE:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [_photos removeObjectAtIndex:tmpNumber.integerValue];
                    [_photoItemView setPhotosWithArray:_photos];
                    [self updateLayout];
                    break;
                case PHOTO_ACTION_TAKE_PHOTO:
                    [self tryToTakePhoto];
                    break;
            }
        } else if(tag == SECTION_TYPE_MEDIA) {
            PhotoItem * item;
            NSInteger videoIndex;
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    item = _videos[tmpNumber.integerValue];
                    [self gotoPlayVideo:item];
                    break;
                case PHOTO_ACTION_DELETE:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    videoIndex = tmpNumber.integerValue;
                    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"notice_video_delete" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
                    [alert showIn:self];
                    alert.leftBlock = ^() {
                        if(videoIndex >=0 && videoIndex < [_videos count]) {
                            [_videos removeObjectAtIndex:videoIndex];
                            [_videoRecordView setPhotosWithArray:_videos];
                            [self updateLayout];
                        }
                    };
                    alert.rightBlock = ^() {
                    };
                    alert.dismissBlock = ^() {
                    };
                    break;
            }
        }
    } else if ([strOrigin isEqualToString:NSStringFromClass([_cameraHelper class])]) {
        NSArray *imgPaths = [msg valueForKeyPath:@"result"];
        for (NSString *path in imgPaths) {
            UIImage * img = [FMUtils getImageWithName:path];
            PhotoItem * item = [[PhotoItem alloc] init];
            [item setImage:img];
            [_photos addObject:item];
        }
        [_photoItemView setPhotosWithArray:_photos];
        [self updateLayout];
    }
}

#pragma mark 网络上传
- (void) upLoadNewDemandInfo {
    [self getDemandBaseInfo];
}

- (void) getDemandBaseInfo {
    if (!_demandDetail) {
        _demandDetail = [[NewDemandDetail alloc] init];
    }
    _demandDetail.userName = [_applicantTF text];
    _demandDetail.phoneNumber = [_telnoTF text];
    
    if ([FMUtils isStringEmpty:_demandDetail.phoneNumber]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_request_phone" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    
    if ([FMUtils isNumberNullOrZero:_reqType.typeId]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"requirement_notice_reqtype" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    } else {
        _demandDetail.typeId = _reqType.typeId;
    }
    
    NSString * content = [_descTF text];
    if ([FMUtils isStringEmpty:content]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"requirement_notice_description" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    } else {
        _demandDetail.descDetail = content;
        [self upLoadDataRightNow];
    }
}

- (void) upLoadDataRightNow {
    [self showLoadingDialog];
    if([self hasPhoto]) {
        [self requestUploadImage];
    } else if([self hasAudio]) {
        [self requestUploadAudio];
    } else if([self hasVideo]) {
        [self requestUploadVideo];
    } else {
        [self requestUploadRequirement];
    }
}

//判断是否有图片需要上传
- (BOOL) hasPhoto {
    BOOL res = NO;
    if(_photos && [_photos count] > 0) {
        res = YES;
    }
    return res;
}

//判断是否有音频需要上传
- (BOOL) hasAudio {
    BOOL res = NO;
    if(_audioRecordUploadArray && [_audioRecordUploadArray count] > 0) {
        res = YES;
    }
    return res;
}

//判断是否有视频需要上传
- (BOOL) hasVideo {
    BOOL res = NO;
    if(_videos && [_videos count] > 0) {
        res = YES;
    }
    return res;
}

- (void) requestUploadRequirement {
    NewDemandRequestParam * param = [[NewDemandRequestParam alloc] init];
    param.requester = _demandDetail.userName;
    param.contact = _demandDetail.phoneNumber;
    param.desc = _demandDetail.descDetail;
    param.typeId = _demandDetail.typeId;
    param.photoIds = _photoIds;
    param.audioIds = _audioIds;
    param.videoIds = _videoIds;
    NSLog(@"上传需求数据");
    
    if(_business) {
        [_business createRequirementByParam:param success:^(NSInteger key, id object) {
            [self hideLoadingDialog];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"requirement_upload_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self finish];
            });
            
        } fail:^(NSInteger key, NSError *error) {
            [self hideLoadingDialog];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"requirement_upload_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    }
}

- (void) requestUploadImage {
    NSLog(@"上传需求图片");
    NSMutableArray * files = [[NSMutableArray alloc] init];
    for(PhotoItem * item in _photos) {
        [files addObject:item.image];
    }
    if([files count] > 0) {
        _operateTag = FILE_TYPE_IMAGE;
        [[FileUploadService getInstance] uploadImageFiles:files listener:self];
    }
}

- (void) requestUploadAudio {
    _operateTag = FILE_TYPE_AUDIO;
    [[FileUploadService getInstance] uploadAudioFiles:_audioRecordUploadArray listener:self];
}

- (void) requestUploadVideo {
    NSMutableArray * files = [[NSMutableArray alloc] init];
    for(PhotoItem * item in _videos) {
        [files addObject:item.originUrl];
    }
    _operateTag = FILE_TYPE_VIDEO;
    [[FileUploadService getInstance] uploadVideoFiles:files listener:self];
}

#pragma - 图片上传结果监听
- (void) onUploadFileError:(NSURLResponse *)response error:(NSError *)error {
    NSLog(@"文件上传失败。");
    [FMUtils printCurrentTime];
    [self hideLoadingDialog];
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"file_submit_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}

- (void) onUploadFileFinished:(NSURLResponse *)response object:(id)responseObject {
    [FMUtils printCurrentTime];
    switch(_operateTag) {
        case FILE_TYPE_IMAGE:
            if(!_photoIds) {
                _photoIds = [[NSMutableArray alloc] init];
            } else {
                [_photoIds removeAllObjects];
            }
            for(NSNumber * pid in responseObject) {
                [_photoIds addObject:pid];
            }
            if([self hasAudio]) {
                [self requestUploadAudio];
            } else if([self hasVideo]) {
                [self requestUploadVideo];
            } else {
                [self requestUploadRequirement];
            }
            break;
        case FILE_TYPE_AUDIO:
            if(!_audioIds) {
                _audioIds = [[NSMutableArray alloc] init];
            } else {
                [_audioIds removeAllObjects];
            }
            for(NSNumber * aid in responseObject) {
                [_audioIds addObject:aid];
            }
            if([self hasVideo]) {
                [self requestUploadVideo];
            } else {
                [self requestUploadRequirement];
            }
            break;
        case FILE_TYPE_VIDEO:
            if(!_videoIds) {
                _videoIds = [[NSMutableArray alloc] init];
            } else {
                [_videoIds removeAllObjects];
            }
            for(NSNumber * vid in responseObject) {
                [_videoIds addObject:vid];
            }
            [self requestUploadRequirement];
            break;
    }
}

#pragma --- 需求描述内容长度改变
- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _descTF) {
        CGRect frame = _descTF.frame;
        frame.size = newSize;
        [_descTF setFrame:frame];
        [self updateLayout];
    }
}

//确定创建按钮点击执行操作
- (void) onMenuItemClicked: (NSInteger) position {
    switch(position) {
        case 0:
            [self upLoadNewDemandInfo];
            break;
    }
}

- (void) onClick:(UIView *)view {
    if(view == _infoView) {
        /**
         *  当点击infoView的别的地方的时候 将infoview缩回去
         */
        [self resetWorking];
    } else if(view == _typeTF) {
        InfoSelectViewController * infoSelectVC;
        infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_REQUIREMENT_TYPE_INFO_SELECT];
        [infoSelectVC setOnMessageHandleListener:self];
        [self gotoViewController:infoSelectVC];
    }
}


//其他点击事件监听
- (void) onItemClick:(UIView *)parent subView:(UIView *)view {
    //录音界面
    if ([parent isKindOfClass:[AudioRecordAlertView class]]) {
        RecordButtonType type = view.tag;
        switch (type) {
            case RECORD_BUTTON_TYPE_START:
                if(!_displayLink) {         //开始录音
                    [self setShowWaveForm:YES];
                }
                [self stratRecord];
                break;
            case RECORD_BUTTON_TYPE_STOP:   //停止录音
                if(_displayLink) {
                    [self setShowWaveForm:NO];
                }
                [self stopRecord];
                break;
            case RECORD_BUTTON_TYPE_PLAY:   //播放录音
                [self setShowWaveForm:YES];
                [self playRecord];
                break;
            case RECORD_BUTTON_TYPE_PAUSE:  //暂停播放
                [self setShowWaveForm:NO];
                [self pauseRecord];
                break;
            case RECORD_BUTTON_CANCEL:      //取消录音
                [self cancelRecord];
                break;
            case RECORD_BUTTON_DONE:    //保存录音
                [self saveRecord];
                break;
                
            default:
                break;
        }
    }
    
    //照片点击删除
    if (parent == _photoItemView) {
        NSInteger picIndex = view.tag;
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"notice_photo_delete" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
        [alert showIn:self];
        alert.leftBlock = ^() {
            if(picIndex >=0 && picIndex < [_photos count]) {
                [self removePhotoAtPosition:picIndex];
            }
        };
        alert.rightBlock = ^() {
        };
        alert.dismissBlock = ^() {
        };
    }
    
    //视频点击删除
    if (parent == _videoRecordView) {
        NSInteger picIndex = view.tag;
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"notice_video_delete" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil]  viewController:self];
        [alert showIn:self];
        alert.leftBlock = ^() {
            if (picIndex >= 0 && picIndex < [_videos count]) {
                [self removeVideoAtPosition:picIndex];
            }
        };
        alert.rightBlock = ^() {
        };
        alert.dismissBlock = ^() {
            
        };
    }
    
    //音频展示点击
    if ([parent isKindOfClass:[CellForAudioRecordView class]]) {
        _audioPosition = parent.tag;
        AudioDetailButtonType type = view.tag;
        switch (type) {
            case AUDIO_PLAY_BUTTON_TYPE: {
                NSNumber * sumtime =  _audioRecordTimeArray[_audioPosition];
                [_audioPlayAlertView setDurationTime:[sumtime floatValue]];
                [self audioDetailClick];
            }
                break;
                
            case AUDIO_DELETE_BUTTON_TYPE:{
                DXAlertView * alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"notice_audio_delete" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
                [alert showIn:self];
                alert.leftBlock = ^() {
                    if (_audioPosition >= 0 && _audioPosition < [_audioRecordUploadArray count]) {
                        [self removeAudioAtPosition:_audioPosition];
                    }
                };
                alert.rightBlock = ^() {
                };
                alert.dismissBlock = ^() {
                };
            }
            break;
        }
    }
    
    //播放操作界面
    if ([parent isKindOfClass:[AudioPlayAlertView class]]) {
        NSInteger tag = view.tag;
        PlayBtnType type = tag;
        
        switch (type) {
            case PLAY_BUTTON_TYPE_PLAY:
                NSLog(@"你点击了语音控制界面的播放按钮");
                [self playRecordWithPosition:_audioPosition];
                break;
            case PLAY_BUTTON_TYPE_STOP:
                NSLog(@"你点击了语音控制界面的暂停按钮");
                [_audioPlayAlertView clearAll];
                [self pauseRecordWithPosition:_audioPosition];
                break;
            default:
                break;
        }
    }
    
    //四个多媒体按钮
    if (parent == _addMoreView) {
        NSInteger tag = view.tag;
        ButtonType type = tag;
        switch (type) {
            case BUTTON_TYPE_IMAGE:
                [self tryToPickImage];
                [self resetWorking];
                break;
            case BUTTON_TYPE_CAMERA:
                [self tryToTakePhoto];
                [self resetWorking];
                break;
            case BUTTON_TYPE_AUDIO:
                [self audioRecord];
                break;
            case BUTTON_TYPE_MEDIA:
                [self tryToTakeVideo];
                [self resetWorking];
                break;
            default:
                break;
        }
        
    }
}


#pragma mark - 点击事件响应
- (void) updateMetersForView {
    NSLog(@"正处于runloop中");
    CGFloat power = 0.0f;
    if (!_isPlaying && _isRecording) {
        [_recoderOfSystem updateMeters];
        power = [_recoderOfSystem averagePowerForChannel:0];
    }
    
    if ((_isPlaying&&!_isRecording) || (_isPlaying && _isRecording)) {
        [_playerOfSystem updateMeters];
        power = [_playerOfSystem averagePowerForChannel:0];
    }
    
    [_audioRecordAlertView updateMetersWithAveragePower:power];
}

- (void) setupPlayRecorder {
    //播放recorder设置
    NSString *soundFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDate * now = [NSDate date];
    NSNumber * curTime = [FMUtils dateToTimeLong:now];
    soundFilePath = [soundFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"FM%lldsound.pcm",[curTime longLongValue]]];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    _playFileURL = newURL;                              // _playFileURL用于随录随放
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    NSDictionary *settings = @{AVSampleRateKey:          [NSNumber numberWithFloat: 44100.0],
                               AVFormatIDKey:            [NSNumber numberWithInt: kAudioFormatAppleLossless],
                               AVNumberOfChannelsKey:    [NSNumber numberWithInt: 2],
                               AVEncoderAudioQualityKey: [NSNumber numberWithInt: AVAudioQualityHigh]};
    NSError *error = nil;
    AVAudioRecorder * newRecorder = [[AVAudioRecorder alloc] initWithURL:_playFileURL settings:settings error:&error];
    _recoderOfSystem = newRecorder;
    _recoderOfSystem.delegate = self;
}

- (void) setupUploadRecorder {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDate * now = [NSDate date];
    NSNumber * curTime = [FMUtils dateToTimeLong:now];
    
    Mp3RecordWriter *mp3Writer = [[Mp3RecordWriter alloc]init];
    mp3Writer.filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"FM%lldrecord.mp3",[curTime longLongValue]]];
    mp3Writer.maxSecondCount = 120;
    mp3Writer.maxFileSize = 10240*256;
    _mp3Writer = mp3Writer;
    
    //用于上传的recorder
    MLAudioRecorder *uploadRecorder = [[MLAudioRecorder alloc]init];
    __weak __typeof(self)weakweakSelf = self;
    uploadRecorder.receiveStoppedBlock = ^{
        weakweakSelf.meterObserver.audioQueue = nil;
    };
    uploadRecorder.receiveErrorBlock = ^(NSError *error){
        weakweakSelf.meterObserver.audioQueue = nil;
        [weakweakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[NSString stringWithFormat:@"%@",error.userInfo] time:DIALOG_ALIVE_TIME_SHORT];
    };
    
    //mp3
    uploadRecorder.fileWriterDelegate = mp3Writer;   //用于上传的模式
    _upLoadFilePath = mp3Writer.filePath;
    _uploadRecorder = uploadRecorder;
    
    
    _tmpAudioUploadPath = _upLoadFilePath;
}

- (void) stratRecord {
    if(!_isRecording) {
        _isRecording = YES;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self setupPlayRecorder];   //初始化用于播放的recorder
            [_recoderOfSystem setMeteringEnabled:YES];
            [_recoderOfSystem prepareToRecord];
            [_recoderOfSystem record];
            //-------------------------------------------------------
            [self setupUploadRecorder];
            [_uploadRecorder startRecording];
        });
    }
}

- (void) stopRecord {
    if(_isRecording) {
        _isRecording = NO;
        
        NSTimeInterval duration = [_recoderOfSystem currentTime];
        _tmpAudioTime = [NSNumber numberWithFloat:duration];
        [_recoderOfSystem stop];
        //    [[AVAudioSession sharedInstance] setActive: NO error: nil];
        //-------------------------------------------------------
        [_uploadRecorder stopRecording];   //结束录音
//        [self updateLayout];
    }
}

//用于录音界面展示中的播放暂停
- (void) playRecordWithPosition:(NSInteger)position {
    if(!_isPlaying) {
        _isPlaying = YES;
        NSNumber * sumtime =  _audioRecordTimeArray[_audioPosition];
        [_audioPlayAlertView setDurationTime:[sumtime floatValue]];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *activationErr  = nil;
            NSError *setCategoryErr = nil;
            
            [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
            
            NSURL * NewURL = [[NSURL alloc] init];
            NewURL = _audioRecordPlayArray[position];
            
            _playerOfSystem = [[AVAudioPlayer alloc] initWithContentsOfURL:NewURL error:nil];
            _playerOfSystem.delegate = self;
            
            [_playerOfSystem prepareToPlay];
            [_playerOfSystem setMeteringEnabled:YES];
            [_playerOfSystem play];
        });
    }
}

- (void) pauseRecordWithPosition:(NSInteger)position {
    if(_isPlaying) {
        [_playerOfSystem stop];
        _isPlaying = NO;
    }
}

//用于录音过程中的播放暂停
- (void) playRecord {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *activationErr  = nil;
        NSError *setCategoryErr = nil;
        
        [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
        
        _playerOfSystem = [[AVAudioPlayer alloc] initWithContentsOfURL:_playFileURL error:nil];
        _playerOfSystem.delegate = self;
        
        [_playerOfSystem prepareToPlay];
        [_playerOfSystem setMeteringEnabled:YES];
        [_playerOfSystem play];
        
        _isPlaying = YES;
    });
}

- (void) pauseRecord {
    [_playerOfSystem stop];
    _isPlaying = NO;
}

//播放音视频
- (void) gotoPlayVideo:(PhotoItem *) item {
    MediaViewController * mediaVC = [[MediaViewController alloc] init];
    [mediaVC setUrl:item.originUrl];
    [self gotoViewController:mediaVC];
}

- (void) cancelRecord {

    [_infoView close];
    [_audioRecordAlertView clearAll];
    [self updateLayout];
    [self setShowWaveForm:NO];
}

- (void) saveRecord {
    [_audioRecordPlayArray addObject:_playFileURL];
    [_audioRecordUploadArray addObject:_tmpAudioUploadPath];
    [_audioRecordTimeArray addObject:_tmpAudioTime];
    
    [_infoView close];
    [self setShowWaveForm:NO];
    [self updateLayout];
}

- (void) addMore {
    [_addMoreBtn setHidden:YES];
    [_infoView setContentHeight:self.view.frame.size.height*0.205 withKey:@"addmoreMedia"];
    [_infoView showType:@"addmoreMedia"];
    [_infoView show];
    _infoViewType = ADDMORE_MEDIA_ALERT_VIEW;
}

- (void) audioRecord {
    [_audioRecordAlertView clearAll];
    [_infoView setContentHeight:[AudioRecordAlertView getRecordViewHeight] withKey:@"audioRecord"];
    [_infoView showType:@"audioRecord"];
    [_infoView show];
    _infoViewType = ADUIO_RECORD_ALERT_VIEW;
}

- (void) audioDetailClick {
    [_infoView setContentHeight:[AudioPlayAlertView getPlayViewHeight] withKey:@"audioPlay"];
    [_infoView showType:@"audioPlay"];
    [_infoView show];
    _infoViewType = AUDIO_PLAY_ALERT_VIEW;
}

- (void) resetWorking {
    if([_playerOfSystem isPlaying]) {
        [_playerOfSystem stop];
    }
    if(_displayLink) {
        [self setShowWaveForm:NO];
    }
    if(_isRecording) {
        [self stopRecord];
    }
    if(_isPlaying) {
        [_audioPlayAlertView clearAll];
        [self pauseRecordWithPosition:_audioPosition];
    }
    [_addMoreBtn setHidden:NO];
    [_infoView close];
}

//设置波形图的展示
- (void)setShowWaveForm:(BOOL)show{
    if(show) {
        [_addMoreBtn setHidden:YES];
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration
                              delay:0.0
                            options:0
                         animations:^{
                             _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMetersForView)]; //将cadisplaylink添加到runloop中
                             [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                             
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else  {
        [_addMoreBtn setHidden:NO];
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration
                              delay:0.0
                            options:0
                         animations:^{
                             [_displayLink invalidate]; //从runloop中移除
                             _displayLink = nil;
                             
                         }
                         completion:^(BOOL finished) {
                             
//                             [_audioRecordAlertView clearAll];
//                             [_audioPlayAlertView clearAll];
//                             [_infoView close];
                         }];
    }
}

#pragma - mark  音频播放监听
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(_isPlaying) {
        _isPlaying = NO;
        [_audioPlayAlertView clearAll];
        [self pauseRecordWithPosition:_audioPosition];
    }
}

#pragma - mark 调用摄像头-拍照/摄影
- (void) tryToTakeVideo {
    VideoTakeViewController * videoVC = [[VideoTakeViewController alloc] init];
    [videoVC setOnMessageHanleListener:self];
    [self gotoViewController:videoVC];
}

- (void) tryToTakePhoto {
    [_cameraHelper takePhotoWithWaterMark:nil];
}

- (void) tryToPickImage {
    [_cameraHelper pickImageWithWaterMark:nil];
}


//删除照片
- (void) removePhotoAtPosition:(NSInteger) position {
    if(position >= 0 && position < [_photos count]) {
        [_photos removeObjectAtIndex:position];
        [self updateLayout];
    }
}

//删除音频
- (void) removeAudioAtPosition:(NSInteger) position {
    [_audioRecordUploadArray removeObjectAtIndex:position];
    [_audioRecordPlayArray removeObjectAtIndex:position];
    [_audioRecordTimeArray removeObjectAtIndex:position];
    
    if ([_audioRecordUploadArray count] == 0) {
        [self updateLayout];
    } else {
        [self updateLayout];
    }
}

//删除视频
- (void) removeVideoAtPosition:(NSInteger) position {
    if (position >= 0 && position < [_videos count]) {
        [_videos removeObjectAtIndex:position];
        [self updateLayout];
    }
}

#pragma --- 键盘的显示与隐藏
//- (void)keyboardWasShown:(NSNotification*)aNotification {
//    NSDictionary *info = [aNotification userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    if(keyboardSize.height > 0) {
//        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
//            CGRect frame = CGRectMake(0, 0, _realWidth, _realHeight-keyboardSize.height);
//            _mainScrollView.frame = frame;
////            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
////                _mainScrollView.bouncesZoom= NO;
////            });
//        }];
//    }
//}
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
//        _mainScrollView.frame = CGRectMake(0, 0, _realWidth, _realHeight);
//    }];
//}



@end
