//
//  RequirementDetailRecordView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/26.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequirementDetailRecordView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "ServiceCenterServerConfig.h"
#import "DottedBubbleView.h"

@interface RequirementDetailRecordView ()

@property (readwrite, nonatomic, strong) DottedBubbleView * buddleLbl;

@property (readwrite, nonatomic, strong) UILabel * topTimeLineLbl;  //起始部分时间线
@property (readwrite, nonatomic, strong) UILabel * timeLineLbl;
@property (readwrite, nonatomic, strong) UIImageView * timePointImgView;
@property (readwrite, nonatomic, strong) UILabel * dateLbl; //日期
@property (readwrite, nonatomic, strong) UILabel * timeLbl; //时间


@property (readwrite, nonatomic, assign) BOOL showTopTimeLine;
@property (readwrite, nonatomic, assign) BOOL showTimeLine;

@property (readwrite, nonatomic, assign) CGFloat buddleLeft;    //图片拉伸使用
@property (readwrite, nonatomic, assign) CGFloat buddleTop;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSString * content;

@property (readwrite, nonatomic, assign) RequirementRecordType recordType;
@property (readwrite, nonatomic, strong) NSNumber* time;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, assign) CGFloat lineWidth;
@property (readwrite, nonatomic, assign) CGFloat pointWidth;

@property (readwrite, nonatomic, assign) CGFloat dateWidth;//时间宽度
@property (readwrite, nonatomic, assign) CGFloat timeWidth;

@property (readwrite, nonatomic, assign) CGFloat titleHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation RequirementDetailRecordView

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
        
        _paddingLeft = 40;
        _paddingTop = 10;
        _paddingRight = 17;
        _paddingBottom = 20;
        _lineWidth = [FMSize getInstance].defaultBorderWidth;
        
        _buddleLeft = 21;
        _buddleTop = 14;
        
        _dateWidth = 70;
        _timeWidth = 70;
        
        _titleHeight = 30;
        _pointWidth = 32;
        _showTopTimeLine = NO;
        _showTimeLine = YES;
        
        UIFont * timeFont = [FMFont getInstance].defaultFontLevel3;
        
        _buddleLbl = [[DottedBubbleView alloc] init];
//        _buddleLbl = [[BuddleLabel alloc] init];
        _timeLineLbl = [[UILabel alloc] init];
        
        _dateLbl = [[UILabel alloc] init];
        _timeLbl = [[UILabel alloc] init];
        _topTimeLineLbl = [[UILabel alloc] init];
        
        [_dateLbl setFont:timeFont];
        [_timeLbl setFont:timeFont];
        
        _dateLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _timeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        _dateLbl.textAlignment = NSTextAlignmentCenter;
        _timeLbl.textAlignment = NSTextAlignmentCenter;
        
        _topTimeLineLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND];
        
        _timeLineLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND];
        _timePointImgView = [[UIImageView alloc] init];
        [_timePointImgView setImage:[[FMTheme getInstance] getImageByName:@"clock"]];
       

        [self addSubview:_buddleLbl];
        [self addSubview:_topTimeLineLbl];
        [self addSubview:_timeLineLbl];
        [self addSubview:_timePointImgView];
        [self addSubview:_dateLbl];
        [self addSubview:_timeLbl];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width==0||height==0) {
        return;
    }
    CGFloat sepHeight = _paddingTop/2;
    CGFloat itemHeight = 0;
    CGFloat originY = 0;
    CGFloat buddleWidth = width-_paddingLeft-_paddingRight-_pointWidth/2-_paddingTop;
    CGFloat buddleHeight = height-_paddingTop * 2-_paddingBottom;
    
    [_buddleLbl setFrame:CGRectMake(_paddingLeft+_pointWidth/2 + _paddingTop, _paddingTop * 2, buddleWidth, buddleHeight)];
    
    CGFloat controlPointHeight = [_buddleLbl getControlPointHeight];
    originY = controlPointHeight + _paddingTop * 2 - _pointWidth / 2;
    
    [_topTimeLineLbl setFrame:CGRectMake(_paddingLeft, 0, _lineWidth, originY-sepHeight)];
    
    [_timePointImgView setFrame:CGRectMake(_paddingLeft-_pointWidth/2, originY, _pointWidth, _pointWidth)];
    originY += _pointWidth +sepHeight;
    
    itemHeight = 14;
    [_dateLbl setFrame:CGRectMake(_paddingLeft - _dateWidth/2, originY, _dateWidth, itemHeight)];
    originY += itemHeight;
    
    [_timeLbl setFrame:CGRectMake(_paddingLeft - _timeWidth/2, originY, _timeWidth, itemHeight)];
    originY += itemHeight + sepHeight / 2;
    
    itemHeight = height - originY;
    [_timeLineLbl setFrame:CGRectMake(_paddingLeft, originY, _lineWidth, itemHeight)];
    
    
    [self updateInfo];
}

- (void) updateInfo {
    [_buddleLbl setInfoWithTitle:_title content:_content];
    [_dateLbl setText:[self getDateDescription]];
    [_timeLbl setText:[self getTimteDescription]];
    
    if(_showTopTimeLine) {
        [_topTimeLineLbl setHidden:NO];
    } else {
        [_topTimeLineLbl setHidden:YES];
    }
    _showTimeLine = YES;
    NSString * imgTypeName = @"clock";
    switch (_recordType) {
        case REQUIREMENT_RECORD_TYPE_CREATE:
            imgTypeName = @"requirement_record_create";
            break;
        case REQUIREMENT_RECORD_TYPE_APPROVAL:
            imgTypeName = @"requirement_record_approval";
            break;
        case REQUIREMENT_RECORD_TYPE_ORDER:
            imgTypeName = @"requirement_record_order";
            break;
        case REQUIREMENT_RECORD_TYPE_PROCESS:
            imgTypeName = @"requirement_record_process";
            break;
        case REQUIREMENT_RECORD_TYPE_FOLLOW_UP:
            imgTypeName = @"requirement_record_follow_up";
            _showTimeLine = NO;
            break;
        case REQUIREMENT_RECORD_TYPE_FINISH:
            imgTypeName = @"requirement_record_finish";
            break;
        default:
            break;
    }
    if(_showTimeLine) {
        [_timeLineLbl setHidden:NO];
    } else {
        [_timeLineLbl setHidden:YES];
    }
    [_timePointImgView setImage:[[FMTheme getInstance] getImageByName:imgTypeName]];
}

- (NSString *) getDateDescription {
    NSString * res = @"";
    if(_time) {
        res = [FMUtils getDateTimeStringBy:_time.longLongValue/1000 format:[[BaseBundle getInstance] getStringByKey:@"requirement_record_date_format" inTable:nil]];
    }
    return res;
}

- (NSString *) getTimteDescription {
    NSString * res = @"";
    if(_time) {
        res = [FMUtils getDateTimeStringBy:_time.longLongValue/1000 format:@"HH:mm"];
    }
    return res;
}

- (void) setInfoWithTitle:(NSString *) title
                  content:(NSString *) content
                     type:(NSInteger) recordType
                     time:(NSNumber *) time {
    _title = title;
    _content = @"";
    if (![FMUtils isStringEmpty:content]) {
        _content = content;
    }
    _recordType = recordType;
    _time = time;
    [self updateInfo];
}

- (void) setShowTopTimeLine:(BOOL) showTopTimeLine {
    _showTopTimeLine = showTopTimeLine;
    [self updateInfo];
}

+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width {
    CGFloat height = 0;
    CGFloat paddingLeft = 60;
    CGFloat paddingRight = 10;
    CGFloat paddingTop = 10;
    CGFloat paddingBottom = 20;
    CGFloat pointWidth = 40;

    height = [DottedBubbleView calculateHeightByContent:content width:width-paddingLeft-paddingRight - pointWidth/2-paddingTop] + paddingTop * 2 + paddingBottom;
    return height;
    
}

@end
