//
//  CellForAudioRecordView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "CellForAudioRecordView.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"

@interface CellForAudioRecordView()
/**
 *  定义一些全局视图View
 */
@property (readwrite, nonatomic, strong) UIButton * audioRecordBtn; //语音播放按钮
@property (readwrite, nonatomic, strong) UIButton * btnImg;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;  //持续时间标签
@property (readwrite, nonatomic, strong) UIButton * deleteBtn;
@property (readwrite, nonatomic, strong) UIImageView * deleteImgView;
/**
 *  定义一些全局变量参数
 */

@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;
@property (readwrite, nonatomic, assign) CGFloat labelHeight;

@property (readwrite, nonatomic, assign) CGFloat deleteBtnWidth;
@property (readwrite, nonatomic, assign) CGFloat deleteImgWidth;

@property (readwrite, nonatomic, strong) NSString * timeDetail;  //用于显示录音时间
@property (readwrite, nonatomic, strong) NSNumber * time;        //持续时间
@property (readwrite, nonatomic, strong) NSNumber * maxTime;     //最大时间

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, assign) BOOL audioExisted;

@property (nonatomic, getter=isEditable) BOOL editable;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> clickListener;

@end


@implementation CellForAudioRecordView

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

}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _editable = YES;
        
        _maxTime = [NSNumber numberWithFloat:120.0];
        _labelHeight = 20;
//        _labelWidth = 30;
        _btnHeight = 40;
        _deleteBtnWidth = 40;
        _deleteImgWidth = [FMSize getInstance].imgWidthLevel3;
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.textAlignment = NSTextAlignmentLeft;
        _timeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _timeLbl.font = [FMFont getInstance].defaultFontLevel2;
        _timeLbl.textAlignment = NSTextAlignmentRight;
        
        _audioRecordBtn = [[UIButton alloc] init];
        _audioRecordBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_AUDIO_RECORD];
        [_audioRecordBtn addTarget:self action:@selector(onPlayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _audioRecordBtn.layer.cornerRadius = 5;
        _audioRecordBtn.layer.masksToBounds = YES;
        _audioRecordBtn.showsTouchWhenHighlighted = YES;
        _audioRecordBtn.tag = AUDIO_PLAY_BUTTON_TYPE;
        
        _deleteBtn = [[UIButton alloc] init];
        _deleteImgView = [[UIImageView alloc] init];
        _deleteBtn.tag = AUDIO_DELETE_BUTTON_TYPE;
        
        [_deleteBtn addSubview:_deleteImgView];
        [_deleteImgView setImage:[[FMTheme getInstance] getImageByName:@"delete_photo"]];
        [_deleteBtn addTarget:self action:@selector(onDeleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _btnImg = [[UIButton alloc] init];
        _btnImg.layer.masksToBounds = YES;
        [_btnImg setBackgroundImage:[[FMTheme getInstance] getImageByName:@"volume"] forState:UIControlStateNormal];
        [_btnImg addTarget:self action:@selector(onPlayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_audioRecordBtn];
        [self addSubview:_btnImg];
        [self addSubview:_timeLbl];
        [self addSubview:_deleteBtn];
    }
}

- (void) updateViews {
    CGRect mframe = self.frame;
    CGFloat width = mframe.size.width;
    CGFloat height = mframe.size.height;
    CGFloat padding = 13;
    CGFloat paddingTop = 0;
    CGFloat paddingLeft = 17;
    
    if (width == 0 || height == 0) {
        return;
    }
    
    paddingTop = (height - _btnHeight) / 2;
    
    if (_audioExisted) {
        
        NSString * time = [self timeToDisplay:_time];
        _timeLbl.text = time;
        _labelWidth = [FMUtils widthForString:_timeLbl value:time];
        
        CGFloat pecent = 0.4;
        if (_time.intValue > _maxTime.integerValue * pecent) {
            pecent = _time.integerValue * 1.0f / _maxTime.floatValue;
        }
        CGFloat recordWidth = (width-paddingLeft*2-_labelWidth)*pecent;
        [_audioRecordBtn setFrame:CGRectMake(paddingLeft, paddingTop, recordWidth, _btnHeight)];
        [_btnImg setFrame:CGRectMake(padding * 2, paddingTop + _btnHeight/4, _btnHeight/2, _btnHeight/2)];
        
        [_timeLbl setFrame:CGRectMake(paddingLeft + (recordWidth - _labelWidth - padding), paddingTop+(_btnHeight-_labelHeight)/2, _labelWidth, _labelHeight)];
        
        if (_editable) {
            [_deleteBtn setFrame:CGRectMake(paddingLeft+recordWidth-_deleteBtnWidth/2, paddingTop-_deleteBtnWidth/2, _deleteBtnWidth, _deleteBtnWidth)];
            [_deleteImgView setFrame:CGRectMake((_deleteBtnWidth - _deleteImgWidth)/2, (_deleteBtnWidth - _deleteImgWidth)/2, _deleteImgWidth, _deleteImgWidth)];
            _deleteBtn.hidden = NO;
            _deleteImgView.hidden = NO;
        } else {
            _deleteBtn.hidden = YES;
            _deleteImgView.hidden = YES;
        }
        
    } else {
        _audioRecordBtn.hidden = YES;
        _timeLbl.hidden = YES;
    }
}

//语音的时间显示
- (NSString *)timeToDisplay:(NSNumber *) sumtime {
    
    NSString * time = [[NSString alloc] init];
    
    if (sumtime.integerValue > 60) {
        time = [time stringByAppendingFormat:@"%ld'%ld''",sumtime.integerValue/60,sumtime.integerValue%60];
    } else {
        time = [time stringByAppendingFormat:@"%ld''",sumtime.integerValue%60];
    }
    
    return time;
}


- (void) setEditable:(BOOL ) isEditable {
    _editable = isEditable;
}


- (void) setDuriationTime:(NSNumber *)seconds {
    
    _time = seconds;
    _audioExisted = YES;
    [self updateViews];
}

#pragma mark 点击事件
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _clickListener = listener;
}

- (void) onPlayButtonClicked {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_audioRecordBtn];
    }
}

- (void) onDeleteButtonClicked {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_deleteBtn];
    }
}

+ (CGFloat) getItemHeight {
    CGFloat height = 0;
    height = 58;
    return height;
}

@end
