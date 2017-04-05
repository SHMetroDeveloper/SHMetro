//
//  LaborerSelectItemView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/4.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "LaborerSelectItemView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "WorkOrderServerConfig.h"
#import "BaseLabelView.h"


@interface LaborerSelectItemView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * scoreLbl;
@property (readwrite, nonatomic, strong) UILabel * statusLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * estimateArriveTimeLbl;

@property (readwrite, nonatomic, strong) UIImageView * checkedImgView;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, assign) NSInteger score;
@property (readwrite, nonatomic, assign) NSInteger grabStatus;
@property (readwrite, nonatomic, strong) NSNumber *estimateArriveTime;
@property (readwrite, nonatomic, strong) NSNumber * status;  //在岗状态

@property (readwrite, nonatomic, strong) UIColor * grabedColor;
@property (readwrite, nonatomic, strong) UIColor * unGrabedColor;


@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;
@property (readwrite, nonatomic, assign) CGFloat grabWidth;
@property (readwrite, nonatomic, assign) CGFloat signWidth; //在岗
@property (readwrite, nonatomic, assign) BOOL checked;  //是否被选

@property (readwrite, nonatomic, assign) BOOL showGrab;  //是否可抢

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation LaborerSelectItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        CGFloat labelWidth = 110;
        
        UIFont * font = [FMFont getInstance].defaultFontLevel2;
        
        _grabedColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
        _unGrabedColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
        
        _padding = 17;
        _imgWidth = [FMSize getInstance].imgWidthLevel3;
        _grabWidth = 40;
        _signWidth = 60;
        
        _nameLbl = [[UILabel alloc] init];
        
//        _scoreLbl = [[UILabel alloc] init];
        
        _statusLbl = [[UILabel alloc] init];
        _checkedImgView = [[UIImageView alloc] init];
        _estimateArriveTimeLbl = [[BaseLabelView alloc] init];
        
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _scoreLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        [_nameLbl setFont:font];
        [_scoreLbl setFont:font];
        [_statusLbl setFont:font];
        
        [_estimateArriveTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_estimate_arrive_time" inTable:nil] andLabelWidth:labelWidth];
        [_estimateArriveTimeLbl setLabelFont:font andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        
        
        [self addSubview:_nameLbl];
        /**
         *  积分这边暂时隐藏，在需要抢单的时候再打开
         */
//        [self addSubview:_scoreLbl];
        
        [self addSubview:_statusLbl];
        [self addSubview:_checkedImgView];
        [self addSubview:_estimateArriveTimeLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat timeHeight = 0;
    CGFloat sepHeight = 0;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat sepWidth = _padding;
    CGFloat statusWidth = 0;
    if(_showGrab) { //抢单
        statusWidth = _grabWidth;
        if(_grabStatus == WORK_ORDER_GRAB_LABORER_STATUS_WAITING) {
            timeHeight = itemHeight;
            sepHeight = _padding / 2;
        }
    } else {    //在岗状态
        statusWidth = _signWidth;
        
    }
    
    CGFloat itemWidth = (width - _padding * 2 - _imgWidth - statusWidth - sepWidth)/2;
    CGFloat originY = (height-itemHeight-timeHeight-sepHeight) / 2;
    [_nameLbl setFrame:CGRectMake(_padding, originY, itemWidth, itemHeight)];
    [_scoreLbl setFrame:CGRectMake(_padding + itemWidth, originY, itemWidth, itemHeight)];
    [_statusLbl setFrame:CGRectMake(width-_padding-_imgWidth-statusWidth, originY, statusWidth, itemHeight)];
    [_checkedImgView setFrame:CGRectMake(width-_padding-_imgWidth, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    originY += itemHeight + sepHeight;
    
    [_estimateArriveTimeLbl setHidden:YES];
    if(_showGrab) {
        [_estimateArriveTimeLbl setFrame:CGRectMake(0, originY, width-_padding-_imgWidth, timeHeight)];
        if(_grabStatus == WORK_ORDER_GRAB_LABORER_STATUS_WAITING) {
            [_estimateArriveTimeLbl setHidden:NO];
        }
    } else {
        
    }
    
    [self updateInfo];
}


- (void) updateInfo {
    [_nameLbl setText:_name];
    [_scoreLbl setText:[[NSString alloc] initWithFormat:@"%@ %ld", [[BaseBundle getInstance] getStringByKey:@"order_score" inTable:nil], _score]];
    
    NSString * strStatus = @"";
    if(_showGrab) { //展示抢单
        if(_grabStatus == WORK_ORDER_GRAB_LABORER_STATUS_WAITING) {
            strStatus = [[BaseBundle getInstance] getStringByKey:@"order_grab_laborer_grabed" inTable:nil];
            [_statusLbl setTextColor:_grabedColor];
            NSString * strTime = [FMUtils timeLongToDateString:_estimateArriveTime];
            [_estimateArriveTimeLbl setContent:strTime];
        } else {
            strStatus = [[BaseBundle getInstance] getStringByKey:@"order_grab_laborer_ungrabed" inTable:nil];
            [_statusLbl setTextColor:_unGrabedColor];
        }
    } else {    //显示在岗状态
        [_statusLbl setHidden:NO];
        switch(_status.integerValue) {
            case 0:     //离岗
                strStatus = [[BaseBundle getInstance] getStringByKey:@"attendance_person_status_out" inTable:nil];
                [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
                break;
            case 1:     //在岗
                strStatus = [[BaseBundle getInstance] getStringByKey:@"attendance_person_status_in" inTable:nil];
                [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
                break;
            case 2:     //没有参与考勤
                [_statusLbl setHidden:YES];
                break;
        }
    }
    [_statusLbl setText:strStatus];
    if(_checked) {
        [_checkedImgView setImage:[[FMTheme getInstance] getImageByName:@"checked_on"]];
    } else {
        [_checkedImgView setImage:[[FMTheme getInstance] getImageByName:@"checked_off"]];
    }
    
}

- (void) setInfoWith:(NSString *) name score:(NSInteger) score {
    _name = name;
    _score = score;
    _showGrab = NO;
    
    [self updateViews];
}

- (void) setInfoWith:(NSString *) name
               score:(NSInteger) score
          grabStatus:(NSInteger) grabStatus
  estimateArriveTime:(NSNumber *) time
              status:(NSNumber *) status{
    _name = name;
    _score = score;
    _grabStatus = grabStatus;
    _showGrab = YES;
    _estimateArriveTime = time;
    _status = status;
    
    [self updateViews];
}
- (void) setChecked:(BOOL) checked {
    _checked = checked;
    [self updateInfo];
}

- (void) setShowGrab:(BOOL)showGrab {
    _showGrab = showGrab;
    [self updateViews];
}

+ (CGFloat) calculateHeightByInfo:(NSInteger) grabStatus {
    CGFloat height = 0;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat sepHeight = padding / 2;
    CGFloat timeHeight = itemHeight;
    height = itemHeight + padding * 2;
    if(grabStatus == WORK_ORDER_GRAB_LABORER_STATUS_WAITING) {
        height += timeHeight + sepHeight;
    }
    return height;
}
@end
