//
//  TestViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "VideoTakeViewController.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "UIButton+Bootstrap.h"
#import <AVFoundation/AVFoundation.h>
#import "MediaViewController.h"
#import "OnMessageHandleListener.h"
#import "MediaViewController.h"
#import "VideoTimerView.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, VideoTakeStatus) {
    VIDEO_TAKE_TYPE_INIT,   //准备录制
    VIDEO_TAKE_TYPE_RECORDING,  //录制中
    VIDEO_TAKE_TYPE_PAUSE,  //暂停
    VIDEO_TAKE_TYPE_FINISH, //录制完成
};

@interface VideoTakeViewController () <AVCaptureFileOutputRecordingDelegate, OnTimerUpdateListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UIView * controlView;
@property (readwrite, nonatomic, strong) UIView * previewView;
@property (readwrite, nonatomic, strong) VideoTimerView * timerLbl;

@property (readwrite, nonatomic, strong) UIButton * doBtn;
@property (readwrite, nonatomic, assign) VideoTakeStatus status;
@property (readwrite, nonatomic, assign) CGFloat controlHeight;

@property (readwrite, nonatomic, assign) CGFloat doBtnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, assign) CGFloat timerWidth;
@property (readwrite, nonatomic, assign) CGFloat timerHeight;

@property (readwrite, nonatomic, strong) AVCaptureSession * session;
@property (readwrite, nonatomic, strong) AVCaptureMovieFileOutput * output;

@property (readwrite, nonatomic, strong) UIButton * playBtn;
@property (readwrite, nonatomic, strong) UIButton * okBtn;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, strong) CALayer * focusLayer;  //用于显示计时和点击对焦

@property (readwrite, nonatomic, strong) NSURL * url;
@property (readwrite, nonatomic, strong) NSString * fullPath;

@property (readwrite, nonatomic, assign) BOOL isWorking;    //是否正在压缩视频

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation VideoTakeViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [super setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_video_create" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        _controlHeight = 100;
        _btnWidth = 48;
        _btnHeight = 48;
        CGFloat padding = 20;
        _timerWidth = 50;
        _timerHeight = 26;
        _imgWidth = 48;
        _doBtnWidth = 64;
        _status = VIDEO_TAKE_TYPE_INIT;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height-_controlHeight)];
        
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
        _controlView.backgroundColor = [UIColor colorWithRed:37/255.0 green:39/255.0 blue:42/255.0 alpha:1.0];
        
        
        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, (_controlHeight-_btnHeight)/2, _btnWidth, _btnHeight)];
        [_playBtn addTarget:self action:@selector(onPlayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        //        [_playBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_playBtn setImage:[[FMTheme getInstance] getImageByName:@"video_preview"] forState:UIControlStateNormal];
        _playBtn.layer.cornerRadius = _btnWidth / 2;
        _playBtn.clipsToBounds = YES;
        [_playBtn setHidden:YES];
        
        _doBtn = [[UIButton alloc] initWithFrame:CGRectMake((width-_doBtnWidth)/2, (_controlHeight-_doBtnWidth)/2, _doBtnWidth, _doBtnWidth)];
        [_doBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        
        [_doBtn addTarget:self action:@selector(onDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_doBtn setImage:[[FMTheme getInstance] getImageByName:@"video_take"] forState:UIControlStateNormal];
        _doBtn.layer.cornerRadius = _doBtnWidth / 2;
        _doBtn.clipsToBounds = YES;
        
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-padding-_btnWidth, (_controlHeight-_btnHeight)/2, _btnWidth, _btnHeight)];
        [_okBtn addTarget:self action:@selector(onOKButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn setImage:[[FMTheme getInstance] getImageByName:@"video_choose"] forState:UIControlStateNormal];
        _okBtn.layer.cornerRadius = _btnWidth / 2;
        _okBtn.clipsToBounds = YES;
        [_okBtn setHidden:YES];
        //        [_okBtn setTitle:@"采用" forState:UIControlStateNormal];
        
        [_controlView addSubview:_playBtn];
        [_controlView addSubview:_doBtn];
        [_controlView addSubview:_okBtn];
        
        
        [_mainContainerView addSubview:_previewView];
        [_mainContainerView addSubview:_controlView];
        [self.view addSubview:_mainContainerView];
        
        _timerLbl = [[VideoTimerView alloc] initWithFrame:CGRectMake(20, 20, _timerWidth, _timerHeight)];
        [_timerLbl setMaxPoint:8];
        [_timerLbl setOnTimerUpdateListener:self];
        
        _focusLayer = [CALayer layer];
        //2.设置layer的属性(一定要设置位置，颜色属性才能显示出来)
        _focusLayer.backgroundColor=[[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN] CGColor];
        _focusLayer.bounds=CGRectMake(0, 0, 200, 200);
        _focusLayer.position=CGPointMake(100, 100);
        
        //        [_previewView.layer addSublayer:_focusLayer];
        
        
    }
    
}

- (void) updateStatus {
    switch (_status) {
        case VIDEO_TAKE_TYPE_INIT:
            [_doBtn setHidden:NO];
            [_playBtn setHidden:YES];
            [_okBtn setHidden:YES];
            [_doBtn setImage:[[FMTheme getInstance] getImageByName:@"video_take"] forState:UIControlStateNormal];
            break;
        case VIDEO_TAKE_TYPE_RECORDING:
            [_doBtn setHidden:NO];
            [_playBtn setHidden:YES];
            [_okBtn setHidden:YES];
            [_doBtn setImage:[[FMTheme getInstance] getImageByName:@"video_stop"] forState:UIControlStateNormal];
            break;
        case VIDEO_TAKE_TYPE_FINISH:
            [_doBtn setHidden:YES];
            [_playBtn setHidden:NO];
            [_okBtn setHidden:NO];
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
    [self updateStatus];
    [self initVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onBackButtonPressed {
    [super onBackButtonPressed];
    [FMUtils deleteFileByPath:_fullPath];   //返回的话则试着将相应的文件删除
}

//初始化
- (void) initVideo {
    //1.创建视频设备(摄像头前，后)
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //2.初始化一个摄像头输入设备(first是后置摄像头，last是前置摄像头)
    AVCaptureDeviceInput *inputVideo =[AVCaptureDeviceInput deviceInputWithDevice:[devices firstObject] error:NULL];
    //3.创建麦克风设备
    AVCaptureDevice *deviceAudio = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //4.初始化麦克风输入设备
    AVCaptureDeviceInput *inputAudio =[AVCaptureDeviceInput deviceInputWithDevice:deviceAudio error:NULL];
    
    //5.初始化一个movie的文件输出
    AVCaptureMovieFileOutput *output = [[AVCaptureMovieFileOutput alloc] init];
    self.output = output; //保存output，方便下面操作
    
    //6.初始化一个会话
    _session =[[AVCaptureSession alloc] init];
    
    //7.将输入输出设备添加到会话中
    if ([_session canAddInput:inputVideo]) {
        [_session addInput:inputVideo];
    }
    if ([_session canAddInput:inputAudio]) {
        [_session addInput:inputAudio];
    }
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
    }
    
    //8.创建一个预览涂层
    AVCaptureVideoPreviewLayer *preLayer =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    preLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    
    //设置图层的大小
    preLayer.frame = _previewView.bounds;
    //添加到view上
    [_previewView.layer addSublayer:preLayer];
    
    [preLayer addSublayer:_timerLbl.layer];
    //启动会话
    [_session startRunning];
    
}

- (void) onDoButtonClicked {
    switch (_status) {
        case VIDEO_TAKE_TYPE_INIT:
            [self startToRecord];
            break;
        case VIDEO_TAKE_TYPE_RECORDING:
            [self stopRecoding];
            break;
        case VIDEO_TAKE_TYPE_FINISH:
            break;
        default:
            break;
    }
    [self updateStatus];
}

- (void) onPlayButtonClicked {
    MediaViewController * mediaVC = [[MediaViewController alloc] init];
    [mediaVC setUrl:_url];
    [self gotoViewController:mediaVC];
}

- (void) onOKButtonClicked {
    if(_handler) {
        if(_isWorking) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"requirement_notice_vide_making_zip" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
            [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
            [msg setValue:_url forKeyPath:@"url"];
            [_handler handleMessage:msg];
            [self finish];
        }
    }
}

- (void) startToRecord {
    
    if (![self.output isRecording]) {
        //9.开始会话
        if(![_session isRunning]) {
            [_session startRunning];
        }
        _status = VIDEO_TAKE_TYPE_RECORDING;
        NSNumber * time = [FMUtils getTimeLongNow];
        NSString * name = [[NSString alloc] initWithFormat:@"%lld.mov", time.longLongValue];
        _fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
        _url = [NSURL fileURLWithPath:_fullPath];
        [self.output startRecordingToOutputFileURL:_url recordingDelegate:self];
        [_timerLbl start];
    }
}

- (void) stopRecoding {
    if ([self.output isRecording]) {
        
        _status = VIDEO_TAKE_TYPE_FINISH;
        [self.output stopRecording];
        [_session stopRunning];
        if([_timerLbl isRunning]) {
            [_timerLbl stop];
        }
        
        
    }
}

#pragma --- delegate
//录制完成代理
- (void) captureOutput:(AVCaptureFileOutput *) captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"完成录制");
    NSString * path = [_fullPath stringByReplacingOccurrencesOfString:@".mov" withString:@".mp4"];
    NSURL * oldUrl = _url;
    _url = [NSURL fileURLWithPath:path];
    _isWorking = YES;
    [self showLoadingDialogwith: [[BaseBundle getInstance] getStringByKey:@"requirement_notice_vide_making_zip" inTable:nil]];
    [FMUtils convertVideoQuailtyWithInputURL:oldUrl outputURL:_url completeHandler:^(AVAssetExportSession * session)  {
        _isWorking = NO;
        
        [self performSelectorOnMainThread:@selector(hideLoadingDialog) withObject:nil waitUntilDone:NO];
        NSLog(@"视频压缩完成");
    }];
}

- (void) setOnMessageHanleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

#pragma --- VideoTimer
- (void) onTimerStart:(VideoTimerView *)vtimer {
    
}

- (void) onTimerUpdate:(VideoTimerView *)vtimer point:(NSInteger)point {
    
}

- (void) onTimerFinished:(VideoTimerView *)vtimer {
    NSLog(@"------ 计时结束 ------");
    [self stopRecoding];
    [self updateStatus];
}


@end
