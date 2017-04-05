//
//  AddMoreAlertView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/16.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "AddMoreAlertView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseBundle.h"

@interface AddMoreAlertView ()

@property (readwrite, nonatomic, strong) UIButton * imgBtn;
@property (readwrite, nonatomic, strong) UIButton * cameraBtn;
@property (readwrite, nonatomic, strong) UIButton * audioBtn;
@property (readwrite, nonatomic, strong) UIButton * mediaBtn;

@property (readwrite, nonatomic, strong) UILabel * imgLbl;      //图片标签
@property (readwrite, nonatomic, strong) UILabel * cameraLbl;   //相机标签
@property (readwrite, nonatomic, strong) UILabel * audioLbl;    //语音标签
@property (readwrite, nonatomic, strong) UILabel * mediaLbl;    //视频标签

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) id<OnItemClickListener> clickListener;

@end

@implementation AddMoreAlertView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        UIFont * font = [FMFont getInstance].font42;
        
        _imgLbl = [[UILabel alloc] init];
        _imgLbl.textAlignment = NSTextAlignmentCenter;
        _imgLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _imgLbl.text = [[BaseBundle getInstance] getStringByKey:@"requirement_add_media_photo" inTable:nil];
        _imgLbl.font = font;
        
        _cameraLbl = [[UILabel alloc] init];
        _cameraLbl.textAlignment = NSTextAlignmentCenter;
        _cameraLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _cameraLbl.text = [[BaseBundle getInstance] getStringByKey:@"requirement_add_media_camera" inTable:nil];
        _cameraLbl.font = font;
        
        _audioLbl = [[UILabel alloc] init];
        _audioLbl.textAlignment = NSTextAlignmentCenter;
        _audioLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _audioLbl.text =  [[BaseBundle getInstance] getStringByKey:@"requirement_add_media_voice" inTable:nil];;
        _audioLbl.font = font;
        
        _mediaLbl = [[UILabel alloc] init];
        _mediaLbl.textAlignment = NSTextAlignmentCenter;
        _mediaLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _mediaLbl.text =  [[BaseBundle getInstance] getStringByKey:@"requirement_add_media_video" inTable:nil];;
        _mediaLbl.font = font;
        
        //图片按钮的设置
        _imgBtn = [[UIButton alloc] init];
        [_imgBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"picture2.0"] forState:UIControlStateNormal];
        [_imgBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"picture2.0_on"] forState:UIControlStateHighlighted];
        _imgBtn.contentMode = UIViewContentModeScaleAspectFill;
        _imgBtn.layer.masksToBounds = YES;
        _imgBtn.layer.borderWidth = 0.2;
        _imgBtn.layer.borderColor = [[UIColor clearColor] CGColor];
        [_imgBtn addTarget:self action:@selector(onImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _imgBtn.tag = BUTTON_TYPE_IMAGE;
        
        //拍照按钮的设置
        _cameraBtn = [[UIButton alloc] init];
        [_cameraBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"camera2.0"] forState:UIControlStateNormal];
        [_cameraBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"camera2.0_on"] forState:UIControlStateHighlighted];
        _cameraBtn.layer.masksToBounds = YES;
        _cameraBtn.layer.borderWidth = 0.2;
        _cameraBtn.layer.borderColor = [[UIColor clearColor] CGColor];
        [_cameraBtn addTarget:self action:@selector(onCameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _cameraBtn.tag = BUTTON_TYPE_CAMERA;
        
        //语音按钮的设置
        _audioBtn = [[UIButton alloc] init];
        [_audioBtn setImage:[[FMTheme getInstance] getImageByName:@"voice2.0"] forState:UIControlStateNormal];
        [_audioBtn setImage:[[FMTheme getInstance] getImageByName:@"voice2.0_on"] forState:UIControlStateHighlighted];
        _audioBtn.layer.masksToBounds = YES;
        _audioBtn.layer.borderWidth = 0.2;
        _audioBtn.layer.borderColor = [[UIColor clearColor] CGColor];
        [_audioBtn addTarget:self action:@selector(onAudioButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _audioBtn.tag = BUTTON_TYPE_AUDIO;

        //视频按钮的设置
        _mediaBtn = [[UIButton alloc] init];
        [_mediaBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"video2.0"] forState:UIControlStateNormal];
        [_mediaBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"video2.0_on"] forState:UIControlStateHighlighted];
        _mediaBtn.layer.masksToBounds = YES;
        _mediaBtn.layer.borderWidth = 0.2;
        _mediaBtn.layer.borderColor = [[UIColor clearColor] CGColor];
        [_mediaBtn addTarget:self action:@selector(onMediaButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _mediaBtn.tag = BUTTON_TYPE_MEDIA;
        
        [self addSubview:_imgLbl];
        [self addSubview:_cameraLbl];
        [self addSubview:_audioLbl];
        [self addSubview:_mediaLbl];
        
        [self addSubview:_imgBtn];
        [self addSubview:_cameraBtn];
        [self addSubview:_audioBtn];
        [self addSubview:_mediaBtn];
    }
    
}

- (void) updateViews {
    CGRect mframe = self.frame;
    CGFloat width = CGRectGetWidth(mframe);
    CGFloat height = CGRectGetHeight(mframe);
    CGFloat sepWidth = 0;
    if (width > 320) {  //如果是大尺寸的话 空隙就会大一点
        sepWidth = 30;
    } else {
        sepWidth = 20;
    }
    CGFloat btnWidth = (width - sepWidth*5)/4;
    CGFloat labelHeight = 20;
    CGFloat sepHeight = (height - btnWidth - labelHeight)/3;

    if (width == 0 || height == 0) {
        return;
    }
    
    [_imgBtn setFrame:CGRectMake(sepWidth, sepHeight, btnWidth, btnWidth)];
    [_imgLbl setFrame:CGRectMake(sepWidth, sepHeight*3/2+btnWidth, btnWidth, labelHeight)];
    _imgBtn.layer.cornerRadius = btnWidth/2;
    _imgBtn.layer.masksToBounds = YES;
    
    [_cameraBtn setFrame:CGRectMake(sepWidth*2+btnWidth, sepHeight, btnWidth, btnWidth)];
    [_cameraLbl setFrame:CGRectMake(sepWidth*2+btnWidth, sepHeight*3/2+btnWidth, btnWidth, labelHeight)];
    _cameraBtn.layer.cornerRadius = btnWidth/2;
    _cameraBtn.layer.masksToBounds = YES;
    
    [_audioBtn setFrame:CGRectMake(sepWidth*3+btnWidth*2, sepHeight, btnWidth, btnWidth)];
    [_audioLbl setFrame:CGRectMake(sepWidth*3+btnWidth*2, sepHeight*3/2+btnWidth, btnWidth, labelHeight)];
    _audioBtn.layer.cornerRadius = btnWidth/2;
    _audioBtn.layer.masksToBounds = YES;
    
    [_mediaBtn setFrame:CGRectMake(sepWidth*4+btnWidth*3, sepHeight, btnWidth, btnWidth)];
    [_mediaLbl setFrame:CGRectMake(sepWidth*4+btnWidth*3, sepHeight*3/2+btnWidth, btnWidth, labelHeight)];
    _mediaBtn.layer.cornerRadius = btnWidth/2;
    _mediaBtn.layer.masksToBounds = YES;
}

#pragma mark 点击事件
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _clickListener = listener;
}

- (void) onImageButtonClick {
    NSLog(@"选择图片");
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_imgBtn];
    }
}

- (void) onCameraButtonClick {
    NSLog(@"拍照");
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_cameraBtn];
    }
}

- (void) onAudioButtonClick {
    NSLog(@"录音");
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_audioBtn];
    }
}

- (void) onMediaButtonClick {
    NSLog(@"视频");
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_mediaBtn];
    }
}

@end
