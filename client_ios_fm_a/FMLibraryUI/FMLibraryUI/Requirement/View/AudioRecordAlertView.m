//
//  AudioRecordAlertView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AudioRecordAlertView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "pop/POP.h"
#import "CircleView.h"
#import "SCSiriWaveformView.h"  //声波
#import "BaseBundle.h"

@interface AudioRecordAlertView ()

@property (readwrite, nonatomic, strong) SCSiriWaveformView * waveformView1;  //wave线1号
@property (readwrite, nonatomic, strong) SCSiriWaveformView * waveformView2;  //wave线2号

@property (readwrite, nonatomic, strong) UIButton * startRecordBtn;  //开始录音按钮
@property (readwrite, nonatomic, strong) UIButton * stopRecordBtn;   //结束录音按钮

@property (readwrite, nonatomic, strong) UIButton * playRecordBtn;   //开始播放按钮
@property (readwrite, nonatomic, strong) UIButton * pauseRecordBtn;  //暂停播放按钮

@property (readwrite, nonatomic, strong) CircleView * circleView; //活动进度条
@property (readwrite, nonatomic, strong) UIImageView * loopView;  //进度条背景图片

@property (readwrite, nonatomic, strong) UIButton * leftCancelBtn;  //取消按钮
@property (readwrite, nonatomic, strong) UIButton * rightDoneBtn;     //发送按钮

@property (readwrite, nonatomic, strong) UILabel * noticeLbl;  //信息提示
@property (readwrite, nonatomic, strong) UILabel * timingLbl;   //显示时间的label

@property (readwrite, nonatomic, strong) NSTimer * timer;     //计时器
@property (readwrite, nonatomic, strong) NSTimer * timer2;     //计时器2

@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat doBtnHeight;
@property (readwrite, nonatomic, assign) CGFloat timelabelWidth;
@property (readwrite, nonatomic, assign) CGFloat timelabelHeight;
@property (readwrite, nonatomic, assign) CGFloat waveWidth;
@property (readwrite, nonatomic, assign) CGFloat waveHeight;
@property (readwrite, nonatomic, assign) CGFloat noticeLabelWidth;
@property (readwrite, nonatomic, assign) CGFloat noticeLabelHeight;

@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat sepHeight;
@property (nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, assign) NSInteger totalTime;

@property (readwrite, nonatomic, assign) int a;          //a:00   用于显示时间
@property (readwrite, nonatomic, assign) int b;          //0:b0
@property (readwrite, nonatomic, assign) int c;          //0:0c

@property (readwrite, nonatomic, assign) int i;          //i:00   用于显示时间
@property (readwrite, nonatomic, assign) int j;          //0:j0   用于显示时间
@property (readwrite, nonatomic, assign) int k;          //0:0k   用于显示时间
@property (readwrite, nonatomic, assign) int m;          //0:0km   用于显示时间

@property (readwrite, nonatomic, assign) int sumTime;    //用于统计总时间

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) BOOL isRecording;
@property (readwrite, nonatomic, assign) BOOL isPlaying;

@property (readwrite, nonatomic, assign) id<OnItemClickListener> clickListener;

@end

@implementation AudioRecordAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self initViews];
    [self updateViews];
}

- (void) initViews {
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    if (width==0 || height == 0) {
        return;
    }
    
    
    if (!_isInited) {
        _isInited = YES;
    
        _isRecording = NO;
        _isPlaying = NO;
        
        _a = _b = _c = _i = _j = _k = _m = _sumTime = 0;
        _timelabelHeight = _waveHeight = _noticeLabelHeight = 30;
        
        CGFloat realHeight = [FMSize getInstance].screenHeight;
        
        _doBtnHeight = [FMSize getInstance].btnBottomControlHeight;
        _timelabelWidth = 40;
        _waveWidth = 100;
        _noticeLabelWidth = 80;
        _btnWidth = realHeight*30/192;
        
        _paddingTop = realHeight*10/192;
        _sepHeight = realHeight*4/192;
        _paddingBottom = realHeight*19/192;
        
        /* 由于第三方view特定需要，此处在initViews中画界面
         *（如无特殊需要，一般都是在updateView中画界面）
         */
        
        
        CGFloat originY = _paddingTop;
        //波浪线1
        _waveformView1 = [[SCSiriWaveformView alloc] initWithFrame:CGRectMake((width-_waveWidth*2-_timelabelWidth)/2, originY, _waveWidth, _waveHeight)];
        _waveformView1.waveColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        _waveformView1.primaryWaveLineWidth = 1.0f;
        _waveformView1.secondaryWaveLineWidth = 0.5f;
        _waveformView1.backgroundColor = [UIColor clearColor];
        
        //波浪线2
        _waveformView2 = [[SCSiriWaveformView alloc] initWithFrame:CGRectMake((width-_waveWidth*2-_timelabelWidth)/2+_waveWidth+_timelabelWidth, originY, _waveWidth, _waveHeight)];
        _waveformView2.waveColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        _waveformView2.primaryWaveLineWidth = 1.0f;
        _waveformView2.secondaryWaveLineWidth = 0.5f;
        _waveformView2.backgroundColor = [UIColor clearColor];
        
        //录音开始按钮
        _startRecordBtn = [[UIButton alloc] init];
        [_startRecordBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"readytostart2.0"] forState:UIControlStateNormal];
        [_startRecordBtn addTarget:self action:@selector(onStartRecordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _startRecordBtn.layer.cornerRadius = _btnWidth/2;
        _startRecordBtn.layer.masksToBounds = YES;
        _startRecordBtn.layer.borderWidth = 1;
        _startRecordBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND] CGColor];
        _startRecordBtn.tag = RECORD_BUTTON_TYPE_START;
        _startRecordBtn.hidden = YES;
        
        //录音结束按钮
        _stopRecordBtn = [[UIButton alloc] init];
        [_stopRecordBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"readytostop2.0"] forState:UIControlStateNormal];
        [_stopRecordBtn addTarget:self action:@selector(onStopRecordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _stopRecordBtn.layer.cornerRadius = _btnWidth/2;
        _stopRecordBtn.layer.masksToBounds = YES;
        _stopRecordBtn.layer.borderWidth = 1;
        _stopRecordBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND] CGColor];
        _stopRecordBtn.tag = RECORD_BUTTON_TYPE_STOP;
        _stopRecordBtn.hidden = YES;
        
        //播放录音
        _playRecordBtn = [[UIButton alloc] init];
        [_playRecordBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"readytoplay2.0"] forState:UIControlStateNormal];
        [_playRecordBtn addTarget:self action:@selector(onPlayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _playRecordBtn.layer.cornerRadius = _btnWidth/2;
        _playRecordBtn.layer.masksToBounds = YES;
        _playRecordBtn.layer.borderWidth = 1;
        _playRecordBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND] CGColor];
        _playRecordBtn.tag = RECORD_BUTTON_TYPE_PLAY;
        _playRecordBtn.hidden = YES;
        
        //暂停播放按钮
        _pauseRecordBtn = [[UIButton alloc] init];
        [_pauseRecordBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"readytopause2.0"] forState:UIControlStateNormal];
        [_pauseRecordBtn addTarget:self action:@selector(onPauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _pauseRecordBtn.layer.cornerRadius = _btnWidth/2;
        _pauseRecordBtn.layer.masksToBounds = YES;
        _pauseRecordBtn.layer.borderWidth = 0;
        _pauseRecordBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND] CGColor];
        _pauseRecordBtn.tag = RECORD_BUTTON_TYPE_PAUSE;
        _pauseRecordBtn.hidden = YES;
        
        //圆环进度条
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, _btnWidth+5, _btnWidth+5)];
        _circleView.strokeColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        [_circleView setStrokeEnd:0.0f animated:NO];
        
        _loopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _btnWidth+5, _btnWidth+5)];
        _loopView.image = [[FMTheme getInstance] getImageByName:@"loopCircle"];
        _loopView.highlightedImage = [[FMTheme getInstance] getImageByName:@"loopCircle"];
        
        //取消按钮
        _leftCancelBtn = [[UIButton alloc] init];
        _leftCancelBtn.layer.borderWidth = 1;
        _leftCancelBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND] CGColor];
        [_leftCancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"notice_delete_cancel" inTable:nil] forState:UIControlStateNormal];
        [_leftCancelBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_AUDIO_CANCEL] forState:UIControlStateNormal];
        _leftCancelBtn.titleLabel.font = [FMFont getInstance].font42;
        [_leftCancelBtn addTarget:self action:@selector(onLeftCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _leftCancelBtn.tag = RECORD_BUTTON_CANCEL;
        _leftCancelBtn.hidden = YES;
        
        //发送按钮
        _rightDoneBtn = [[UIButton alloc] init];
        _rightDoneBtn.layer.borderWidth = 1;
        _rightDoneBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND] CGColor];
        [_rightDoneBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"notice_delete_done" inTable:nil] forState:UIControlStateNormal];
        [_rightDoneBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_AUDIO_CANCEL] forState:UIControlStateNormal];
        _rightDoneBtn.titleLabel.font = [FMFont getInstance].font42;
        [_rightDoneBtn addTarget:self action:@selector(onRightDoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _rightDoneBtn.tag = RECORD_BUTTON_DONE;
        _rightDoneBtn.hidden = YES;
        
        //时间标签
        _timingLbl = [[UILabel alloc] init];
        _timingLbl.text = @"0:00";
        _timingLbl.textAlignment = NSTextAlignmentCenter;
        _timingLbl.font = [FMFont getInstance].defaultFontLevel1;
        _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL];
        _timingLbl.hidden = YES;
        
        //提示标签
        _noticeLbl = [[UILabel alloc] init];
        _noticeLbl.text =  [[BaseBundle getInstance] getStringByKey:@"requirement_voice_record_start" inTable:nil];;
        _noticeLbl.textAlignment = NSTextAlignmentCenter;
        _noticeLbl.font = [FMFont getInstance].font42;
        _noticeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
        _noticeLbl.hidden = YES;
        
        /* 
         计时器1用于录音计时，
         计时器2用于倒计时播放
        */
        _timer = [[NSTimer alloc] init];
        _timer2 = [[NSTimer alloc] init];
        
        [self addSubview:_startRecordBtn];
        [self addSubview:_stopRecordBtn];
        
        [self addSubview:_loopView];
        [self addSubview:_circleView];
        [self addSubview:_playRecordBtn];
        [self addSubview:_pauseRecordBtn];
        
        [self addSubview:_leftCancelBtn];
        [self addSubview:_rightDoneBtn];
        [self addSubview:_timingLbl];
        [self addSubview:_noticeLbl];
        [self addSubview:_waveformView1];
        [self addSubview:_waveformView2];
    }
}

- (void) updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat originX = (width - _btnWidth)/2;
    CGFloat originY = 0;
    
    if (_isRecording) {
        _startRecordBtn.hidden = YES;
        _stopRecordBtn.hidden = NO;
        _playRecordBtn.hidden = YES;
        _pauseRecordBtn.hidden = YES;
        _leftCancelBtn.hidden = YES;
        _rightDoneBtn.hidden = YES;
        _timingLbl.hidden = NO;
        _noticeLbl.hidden = YES;
        _circleView.hidden = YES;
        _loopView.hidden = YES;
        _waveformView1.hidden = NO;
        _waveformView2.hidden = NO;
        

        originY = _paddingTop;
        [_timingLbl setFrame:CGRectMake((width-_timelabelWidth)/2, originY, _timelabelWidth, _timelabelHeight)];
        [_waveformView1 setFrame:CGRectMake((width-_waveWidth*2-_timelabelWidth)/2, originY, _waveWidth, _waveHeight)];
        [_waveformView2 setFrame:CGRectMake((width-_waveWidth*2-_timelabelWidth)/2+_waveWidth+_timelabelWidth, originY, _waveWidth, _waveHeight)];
        originY += _timelabelHeight + _sepHeight; //根据设计图示的要求
        
        [_stopRecordBtn setFrame:CGRectMake(originX, originY, _btnWidth, _btnWidth)];
        
    } else {
        _startRecordBtn.hidden = NO;
        _stopRecordBtn.hidden = YES;
        _playRecordBtn.hidden = YES;
        _pauseRecordBtn.hidden = YES;
        _leftCancelBtn.hidden = YES;
        _rightDoneBtn.hidden = YES;
        _timingLbl.hidden = YES;
        _noticeLbl.hidden = NO;
        _circleView.hidden = YES;
        _loopView.hidden = YES;
        _waveformView1.hidden = YES;
        _waveformView2.hidden = YES;
        
        originY = _paddingTop;
        [_noticeLbl setFrame:CGRectMake((width-_noticeLabelWidth)/2, originY, _noticeLabelWidth, _noticeLabelHeight)];
        originY += _noticeLabelHeight + _sepHeight;
        
        [_startRecordBtn setFrame:CGRectMake(originX, originY, _btnWidth, _btnWidth)];
    }
}

- (void) updateViews2 {
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat originX = (width - _btnWidth)/2;
    CGFloat originY = 0;
    
    if (_isPlaying) {
        _startRecordBtn.hidden = YES;
        _stopRecordBtn.hidden = YES;
        _playRecordBtn.hidden = YES;
        _pauseRecordBtn.hidden = NO;
        _leftCancelBtn.hidden = NO;
        _rightDoneBtn.hidden = NO;
        _timingLbl.hidden = NO;
        _noticeLbl.hidden = YES;
        _circleView.hidden = NO;
        _loopView.hidden = NO;
        _waveformView1.hidden = NO;
        _waveformView2.hidden = NO;
        
        originY = _paddingTop;
        [_timingLbl setFrame:CGRectMake((width-_timelabelWidth)/2, originY, _timelabelWidth, _timelabelHeight)];
        [_waveformView1 setFrame:CGRectMake((width-_waveWidth*2-_timelabelWidth)/2, originY, _waveWidth, _waveHeight)];
        [_waveformView2 setFrame:CGRectMake((width-_waveWidth*2-_timelabelWidth)/2+_waveWidth+_timelabelWidth, originY, _waveWidth, _waveHeight)];
        
        originY += _timelabelHeight + _sepHeight;
        
        [_pauseRecordBtn setFrame:CGRectMake(originX, originY, _btnWidth, _btnWidth)];
        _circleView.center = _pauseRecordBtn.center;
        _loopView.center = _pauseRecordBtn.center;
//        originY += _btnWidth + sephight;
        
        [_leftCancelBtn setFrame:CGRectMake(0, height-_doBtnHeight, width/2 + 0.5, _doBtnHeight)];  //此0.5用于解决两个button之间的间隔过宽问题（因为button的borderwidth = 1）
        [_rightDoneBtn setFrame:CGRectMake(width/2 + 0.5, height-_doBtnHeight, width/2 + 0.5, _doBtnHeight)];
        
    } else {
        _startRecordBtn.hidden = YES;
        _stopRecordBtn.hidden = YES;
        _playRecordBtn.hidden = NO;
        _pauseRecordBtn.hidden = YES;
        _leftCancelBtn.hidden = NO;
        _rightDoneBtn.hidden = NO;
        _timingLbl.hidden = NO;
        _noticeLbl.hidden = YES;
        _circleView.hidden = YES;
        _loopView.hidden = YES;
        _waveformView1.hidden = NO;
        _waveformView2.hidden = NO;
        
        originY = _paddingTop;
        [_timingLbl setFrame:CGRectMake((width-_timelabelWidth)/2, originY, _timelabelWidth, _timelabelHeight)];
        [_waveformView1 setFrame:CGRectMake((width-_waveWidth*2-_timelabelWidth)/2, originY, _waveWidth, _waveHeight)];
        [_waveformView2 setFrame:CGRectMake((width-_waveWidth*2-_timelabelWidth)/2+_waveWidth+_timelabelWidth, originY, _waveWidth, _waveHeight)];
        originY += _timelabelHeight + _sepHeight;
        
        
        [_playRecordBtn setFrame:CGRectMake(originX, originY, _btnWidth, _btnWidth)];
        _circleView.center = _playRecordBtn.center;
        _loopView.center = _playRecordBtn.center;
//        originY += _btnWidth + sephight;
        
        [_leftCancelBtn setFrame:CGRectMake(0, height-_doBtnHeight, width/2 + 0.5, _doBtnHeight)];
        [_rightDoneBtn setFrame:CGRectMake(width/2 - 0.5, height-_doBtnHeight, width/2 + 0.5, _doBtnHeight)];
    }
}

//此处算法计算比较拙劣，有待日后改善
- (void) updateTimeWhenRecording {
    _c += 1;
    if (_c == 10) {
        _c = 0;
        _b += 1;
    }
    if (_b == 6) {
        _b = 0;
        _a += 1;
    }
    //最长时间为 2 分钟,然后自动暂停
    if (_a == 2) {
        [self onStopRecordBtnClick];
    }
    
    _timingLbl.text = [NSString stringWithFormat:@"%d:%d%d",_a,_b,_c];
}

- (void) updateTimeWhenPlaying {
    if (_i == _a && _j ==_b && _k == _c) {
        [self onPauseBtnClick];
        _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL];
    } else {
        _m += 1;
        if (_m == 10) {
            _m = 0;
            _k += 1;
        } else if (_k == 10) {
            _k = 0;
            _j += 1;
        } else if (_j == 6) {
            _j = 0;
            _i += 1;
        }
        //显示读秒
        _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        _timingLbl.text = [NSString stringWithFormat:@"%d:%d%d",_i,_j,_k];
        //显示圆环进度条
        CGFloat percent = ((float)(_m*0.1)+(float)_k+(float)_j*10+(float)_i*60)/(float)_sumTime;
        [_circleView setStrokeEnd:percent animated:YES];
    }
}

- (void) clearAll {
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    _isRecording = NO;
    _isPlaying = NO;
    _a = _b = _c = _i = _j = _k = 0;
    _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL];
    _timingLbl.text = [NSString stringWithFormat:@"%d:%d%d",_a,_b,_c];
    [self updateViews];
}

#pragma mark - 点击事件相应
- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _clickListener = listener;
}

//开始录音
- (void) onStartRecordBtnClick {
    _isRecording = YES;
    [self updateViews];
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_startRecordBtn];
    }
    _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeWhenRecording) userInfo:nil repeats:YES];
}

//暂停录音
- (void) onStopRecordBtnClick {
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_stopRecordBtn];
    }
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    _sumTime = _a*60+_b*10+_c;
    _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL];
    _isRecording = NO;
    [self updateViews2];
}

//播放
- (void) onPlayBtnClick {
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_playRecordBtn];
    }
    _isPlaying = YES;
    [self updateViews2];
    _i = _j = _k = _m = 0;
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeWhenPlaying) userInfo:nil repeats:YES];
}

//暂停
- (void) onPauseBtnClick {
    _isPlaying = NO;
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_pauseRecordBtn];
    }
    if (_timer2) {
        if ([_timer2 isValid]) {
            [_timer2 invalidate];
            _timer2 = nil;
        }
    }
    _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL];
    _timingLbl.text = [NSString stringWithFormat:@"%d:%d%d",_a,_b,_c];
    [_circleView setStrokeEnd:0.0f animated:YES];
    [self updateViews2];
}

- (void) onLeftCancelBtnClick {
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_leftCancelBtn];
    }
}

- (void) onRightDoneBtnClick {
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_rightDoneBtn];
    }
}

- (void) updateMetersWithAveragePower:(CGFloat)power {
    CGFloat normalizedValue;
    normalizedValue = [self _normalizedPowerLevelFromDecibels:power];
    [_waveformView1 updateWithLevel:normalizedValue];
    [_waveformView2 updateWithLevel:normalizedValue];
}

#pragma mark - Private
- (CGFloat)_normalizedPowerLevelFromDecibels:(CGFloat)decibels {
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}

+ (CGFloat) getRecordViewHeight {
    CGFloat height = 0;
    CGFloat screenHeight = [FMSize getInstance].screenHeight;
    
    CGFloat btnWidth = screenHeight*30/192;
    CGFloat paddingTop = screenHeight*10/192;
    CGFloat sepHeight = screenHeight*4/192;
    CGFloat paddingBottom = screenHeight*19/192;
    CGFloat labelHeight = 30;
    
    height = paddingTop + labelHeight + sepHeight + btnWidth + paddingBottom;
    
    return height;
}

@end



