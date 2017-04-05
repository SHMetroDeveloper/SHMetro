//
//  AudioPlayAlertView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/17.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AudioPlayAlertView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "CircleView.h"
#import "SCSiriWaveformView.h"

@interface AudioPlayAlertView ()

@property (readwrite, nonatomic, strong) UIButton * playButton;
@property (readwrite, nonatomic, strong) UIButton * stopButton;
@property (readwrite, nonatomic, strong) CircleView * circleView;  //活动进度条
@property (readwrite, nonatomic, strong) UIImageView * loopView;  //进度条背景图片

@property (readwrite, nonatomic, strong) UILabel * timingLbl;//时间显示
@property (readwrite, nonatomic, strong) NSTimer * timer;    //计时器

@property (nonatomic, assign) CGFloat btnWidth;  //按钮的宽度
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, assign) CGFloat labelWidth;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat sepHeight;
@property (nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, assign) int a; //a:00   用于显示时间
@property (readwrite, nonatomic, assign) int b; //0:b0
@property (readwrite, nonatomic, assign) int c; //0:0c
@property (readwrite, nonatomic, assign) int d; //0:00.d
@property (readwrite, nonatomic, assign) int sumtime;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) BOOL isPlaying;

@property (readwrite, nonatomic, assign) id<OnItemClickListener> clickListener;

@end

@implementation AudioPlayAlertView

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
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (width==0 || height == 0) {
        return;
    }
    
    if (!_isInited) {
        _isInited = YES;
        
        _isPlaying = NO;
        _a = _b = _c = _d = 0;
        
        CGFloat realHeight = [FMSize getInstance].screenHeight;
        _btnWidth = realHeight*30/192;
        _paddingTop = realHeight*10/192;
        _sepHeight = realHeight*4/192;
        _paddingBottom = realHeight*19/192;
        _labelHeight = 30;
        _labelWidth = 40;
        
        CGFloat originX = (width - _btnWidth)/2;
        
        
        CGFloat originY = _paddingTop;
        //时间标签
        _timingLbl = [[UILabel alloc] init];
        _timingLbl.text = @"0:00";
        _timingLbl.textAlignment = NSTextAlignmentCenter;
        _timingLbl.font = [FMFont getInstance].defaultFontLevel1;
        _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL];
        _timingLbl.backgroundColor = [UIColor clearColor];
        [_timingLbl setFrame:CGRectMake((width-_labelWidth)/2, originY, _labelWidth, _labelHeight)];
        originY += _labelHeight + _sepHeight;
        
        
        
        //开始按钮
        _playButton = [[UIButton alloc] init];
        [_playButton setBackgroundImage:[[FMTheme getInstance] getImageByName:@"readytoplay"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(onPlayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _playButton.backgroundColor = [UIColor clearColor];
        _playButton.tag = PLAY_BUTTON_TYPE_PLAY;
        [_playButton setFrame:CGRectMake(originX, originY, _btnWidth, _btnWidth)];
        
        
        //暂停按钮
        _stopButton = [[UIButton alloc] init];
        [_stopButton setBackgroundImage:[[FMTheme getInstance] getImageByName:@"readytopause"] forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(onStopBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _stopButton.backgroundColor = [UIColor clearColor];
        _stopButton.tag = PLAY_BUTTON_TYPE_STOP;
        [_stopButton setFrame:CGRectMake(originX, originY, _btnWidth, _btnWidth)];
        
    
        //圆环进度条
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, _btnWidth+5, _btnWidth+5)];
        _circleView.strokeColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        [_circleView setStrokeEnd:0.0f animated:NO];
        _circleView.center = _stopButton.center;
        
        _loopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _btnWidth+5, _btnWidth+5)];
        _loopView.image = [[FMTheme getInstance] getImageByName:@"loopCircle"];
        _loopView.highlightedImage = [[FMTheme getInstance] getImageByName:@"loopCircle"];
        _loopView.center = _stopButton.center;
        
        //计时器
        _timer = [[NSTimer alloc] init];
        
        [self addSubview:_loopView];
        [self addSubview:_circleView];
        [self addSubview:_playButton];
        [self addSubview:_stopButton];
        
        [self addSubview:_timingLbl];
        
    }
}

- (void) updateViews {
    if (_isPlaying) {
        _stopButton.hidden = NO;
        _playButton.hidden = YES;
        _timingLbl.hidden = NO;
        _circleView.hidden = NO;
        _loopView.hidden = NO;
    } else {
        _stopButton.hidden = YES;
        _playButton.hidden = NO;
        _timingLbl.hidden = NO;
        _circleView.hidden = YES;
        _loopView.hidden = NO;
    }
}

- (void) setDurationTime:(float)sumTime {
    _sumtime = sumTime*10;
}

- (void) increaseTime {
    if ((_d == _sumtime%10) && _c+_b*10+_a*60 == _sumtime/10) {
//        [self onStopBtnClick];
        if (_timer) {
            if ([_timer isValid]) {
                [_timer invalidate];
                _timer = nil;
            }
        }
        _isPlaying = NO;
        _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL];
        _a = _b = _c = _d = 0;
        [self updateViews];
    } else {
        _d += 1;
        if (_d == 10) {
            _d = 0;
            _c += 1;
        }
        if (_c == 10) {
            _c = 0;
            _b += 1;
        }
        if (_b == 6) {
            _b = 0;
            _a += 1;
        }
        //显示读秒
        _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        _timingLbl.text = [NSString stringWithFormat:@"%d:%d%d",_a,_b,_c];
        //刷新圆环
        CGFloat percent = ((float)(_d*0.1)+(float)_c+(float)_b*10+(float)_a*60)/(float)(_sumtime/10 + (_sumtime%10)*0.1);
        [_circleView setStrokeEnd:percent animated:YES];
    }
}

- (void) clearAll {
    //清空数据
    _isPlaying = NO;
    _a = _b = _c = _d = 0;
    _sumtime = 0;
    _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL];
    _timingLbl.text = [NSString stringWithFormat:@"%d:%d%d",_a,_b,_c];
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    [_circleView setStrokeEnd:0.0f animated:YES];
    [self updateViews];
}

#pragma mark - 点击事件相应
- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _clickListener = listener;
}

- (void) onPlayBtnClick {
    
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_playButton];
    }
    _isPlaying = YES;
    _a = _b = _c = _d = 0;
    [self updateViews];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(increaseTime) userInfo:nil repeats:YES];
}

- (void) onStopBtnClick {
    _isPlaying = NO;
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_stopButton];
    }
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    _timingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL];
    int i , j , k;
    i = (_sumtime/10)/60;
    j = ((_sumtime/10)%60)/10;
    k = ((_sumtime/10)%60)%10;
    _timingLbl.text = [NSString stringWithFormat:@"%d:%d%d",i,j,k];
    [_circleView setStrokeEnd:0.0f animated:YES];
    [self updateViews];
}


#pragma mark - Private
- (CGFloat)_normalizedPowerLevelFromDecibels:(CGFloat)decibels {
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}

+ (CGFloat) getPlayViewHeight {
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





