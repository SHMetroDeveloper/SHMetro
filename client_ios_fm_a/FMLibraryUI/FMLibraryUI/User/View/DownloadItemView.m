//
//  DownloadItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "DownloadItemView.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"

@interface DownloadItemView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * neweastLbl;
@property (readwrite, nonatomic, strong) UILabel * statusLbl;
//@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) UIImageView * unFinishedImgView;
//@property (readwrite, nonatomic, strong) UILabel * unFinishedImgView;
@property (readwrite, nonatomic, strong) UIProgressView * progressView;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, assign) BOOL isNeweast;
@property (readwrite, nonatomic, strong) NSString * status;
@property (readwrite, nonatomic, strong) NSString * time;
@property (readwrite, nonatomic, assign) CGFloat progress;  //progress = 100 时完成

@property (readwrite, nonatomic, assign) CGFloat timeWidth;
@property (readwrite, nonatomic, assign) CGFloat statusWidth;
@property (readwrite, nonatomic, assign) CGFloat newWidth;
@property (readwrite, nonatomic, assign) CGFloat newHeight;

@property (readwrite, nonatomic, strong) UIFont * nameFont;
@property (readwrite, nonatomic, strong) UIFont * msgFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat seperatorpadding;

@property (readwrite, nonatomic, assign) BOOL showAnimation;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end


@implementation DownloadItemView

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
    if(!_isInited) {
        _isInited = YES;
        
        _paddingLeft = 15;
        _paddingRight = _paddingLeft;
        _seperatorpadding = _paddingLeft;
        
        _timeWidth = 120;
        _statusWidth = 120;
        _newWidth = 30;
        _newHeight = 15;
        
        _isNeweast = NO;
        _showAnimation = NO;
        
        _nameFont = [FMFont getInstance].defaultFontLevel2;
        _msgFont = [FMFont getInstance].defaultFontLevel3;
        
        
        _nameLbl = [[UILabel alloc] init];
        _neweastLbl = [[UILabel alloc] init];
        _statusLbl = [[UILabel alloc] init];
//        _timeLbl = [[UILabel alloc] init];
        _unFinishedImgView = [[UIImageView alloc] init];
        _progressView = [[UIProgressView alloc] init];
        
        [_neweastLbl setText:@"new"];
        [_neweastLbl setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK]];
        [_neweastLbl setTextColor:[UIColor whiteColor]];
        
        [_nameLbl setFont:_nameFont];
        [_neweastLbl setFont:_msgFont];
        [_statusLbl setFont:_msgFont];
//        [_timeLbl setFont:_msgFont];
        
//        _unFinishedImgView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND];
        [_unFinishedImgView setImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] width:1 height:1]];
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _statusLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
//        _timeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        
        _progressView.contentMode = UIViewContentModeScaleAspectFill;
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressImage = [FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN] width:1 height:1];
        
        
        _statusLbl.textAlignment = NSTextAlignmentRight;
//        _timeLbl.textAlignment = NSTextAlignmentRight;
        
        _neweastLbl.textAlignment = NSTextAlignmentCenter;
        _neweastLbl.layer.borderWidth = 0.4;
        _neweastLbl.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK] CGColor];
        _neweastLbl.layer.cornerRadius = _newHeight / 2;
        _neweastLbl.clipsToBounds = YES;
        
        
        [self addSubview:_nameLbl];
        [self addSubview:_neweastLbl];
        [self addSubview:_statusLbl];
//        [self addSubview:_timeLbl];
        [self addSubview:_unFinishedImgView];
        [self addSubview:_progressView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat msgHeight = 16;
    CGFloat sepHeight = 0;
    CGFloat sepWidth = 10;
    CGFloat nameWidth = 0;
    CGFloat progressHeight = 1;
    CGFloat originX = _paddingLeft;
    BOOL showTime = NO;
    
//    if(![FMUtils isStringEmpty:_time]) {
//        showTime = YES;
//    }
    if(showTime) {
        sepHeight = (height - msgHeight * 2)/3;
    } else {
        sepHeight = (height - msgHeight) / 2;
    }
    
    [_nameLbl setFrame:CGRectMake(originX, 0, width-_paddingLeft-_paddingRight, height)];
    nameWidth = [FMUtils widthForString:_nameLbl value:_name];
    [_nameLbl setFrame:CGRectMake(originX, 0, nameWidth, height)];
    originX += nameWidth + sepWidth;
    if(_isNeweast) {
        [_neweastLbl setFrame:CGRectMake(originX, (height-_newHeight)/2, _newWidth, _newHeight)];
        originX += _newWidth + sepWidth;
        [_neweastLbl setHidden:NO];
    } else {
        [_neweastLbl setHidden:YES];
    }
    [_statusLbl setFrame:CGRectMake(width-_statusWidth-_paddingRight, sepHeight, _statusWidth, msgHeight)];
//    if(showTime) {
//        [_timeLbl setFrame:CGRectMake(width-_timeWidth-_paddingRight, sepHeight*2 + msgHeight, _timeWidth, msgHeight)];
//        [_timeLbl setHidden:NO];
//    } else {
//        [_timeLbl setHidden:YES];
//    }
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
//    [_unFinishedImgView setFrame:CGRectMake(_paddingLeft, height-progressHeight+(progressHeight-seperatorHeight)/2, width-_paddingLeft*2, seperatorHeight)];
    if (_seperatorpadding != _paddingLeft) {
        [_unFinishedImgView setFrame:CGRectMake(_seperatorpadding, height-seperatorHeight, width-_seperatorpadding*2, seperatorHeight)];
    } else {
        [_unFinishedImgView setFrame:CGRectMake(_paddingLeft, height-seperatorHeight, width-_paddingLeft*2, seperatorHeight)];
    }
    _unFinishedImgView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND];
    
    [_progressView setFrame:CGRectMake(_paddingLeft, height-progressHeight, width-_paddingLeft*2, progressHeight)];
    
    
    [self updateInfo];
}

- (void) updateInfo {
    [_nameLbl setText:_name];
    [_statusLbl setText:_status];
//    if(![FMUtils isStringEmpty:_time]) {
//        [_timeLbl setText:_time];
//    }
    
    [_progressView setProgress:_progress/100 animated:_showAnimation];
    if (_progress == 100) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_progressView setProgress:0 animated:NO];
        });
    }
}

- (void) setInfoWithName:(NSString *) name
                   isNew:(BOOL) isNew
                  status:(NSString *) status
                    time:(NSString *) time {
    
    _name = name;
    _isNeweast = isNew;
    _status = status;
    _time = time;
    [self updateViews];
}

- (void) setStatusColor:(UIColor *) color {
    [_statusLbl setTextColor:color];
}

- (void) updateStatus:(NSString *) status andTime:(NSString *) time progress:(CGFloat) progress{

    _status = status;
    _time = time;
    if(_progress != progress) {
        _showAnimation = YES;
        _progress = progress;
    } else {
        _showAnimation = NO;
    }
    [self performSelectorOnMainThread:@selector(updateInfo) withObject:nil waitUntilDone:NO];
    
}

- (void) updateNeweast:(BOOL) isNeweast {
    _isNeweast = isNeweast;
    [self performSelectorOnMainThread:@selector(updateViews) withObject:nil waitUntilDone:NO];
}

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}

- (void) setSeperatorPadding:(CGFloat) padding {
    _seperatorpadding = padding;
    [self updateViews];
}

@end


