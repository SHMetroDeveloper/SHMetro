//
//  MissionCheckView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/26.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MissionCheckView.h"
#import "BaseLabelView.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface MissionCheckView ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) BaseLabelView *locationLbl;
@property (nonatomic, strong) BaseLabelView *timeLbl;
@property (nonatomic, strong) UILabel *finishLbl;
@property (nonatomic, strong) UIImageView *detailImgView;

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * location;

@property (readwrite, nonatomic, assign) BOOL isChecked;
@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation MissionCheckView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self initViews];
    }
    return self;
}
- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        _isChecked = NO;
        
        UIColor *darkColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        UIColor *lightColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIFont *mFont = [FMFont getInstance].font38;
        
        _titleLbl = [UILabel new];
        _titleLbl.textColor = darkColor;
        _titleLbl.font = mFont;
        _titleLbl.textAlignment = NSTextAlignmentLeft;

        
        _timeLbl = [[BaseLabelView alloc] init];
        [_timeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"energy_task_finish_time" inTable:nil] andLabelWidth:0];
        [_timeLbl setLabelFont:mFont andColor:lightColor];
        [_timeLbl setContentFont:mFont];
        [_timeLbl setContentColor:darkColor];
        
        
        _locationLbl = [[BaseLabelView alloc] init];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"energy_task_location" inTable:nil] andLabelWidth:0];
        [_locationLbl setLabelFont:mFont andColor:lightColor];
        [_locationLbl setContentFont:mFont];
        [_locationLbl setContentColor:darkColor];
        
        
        _finishLbl = [UILabel new];
        _finishLbl.textAlignment = NSTextAlignmentRight;
        _finishLbl.font = mFont;
        
        
        _detailImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        [self addSubview:_titleLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_locationLbl];
        [self addSubview:_finishLbl];
        [self addSubview:_detailImgView];
    }
}

- (void) updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat imgWidth = [FMSize getInstance].imgWidthLevel3;
    CGFloat originX = padding;
    CGFloat originY = padding;
    CGFloat checkLblWidth = 90;
    
    [_titleLbl setFrame:CGRectMake(originX, originY, width-padding*3-checkLblWidth, itemHeight)];
    [_finishLbl setFrame:CGRectMake(width-padding-checkLblWidth, originY, checkLblWidth, itemHeight)];
    originY += itemHeight + padding;
    
    if (_isChecked) {
        _timeLbl.hidden = NO;
        [_timeLbl setFrame:CGRectMake(0, originY, width-padding, itemHeight)];
        originY += itemHeight + padding;
    } else {
        _timeLbl.hidden = YES;
    }
    
    [_locationLbl setFrame:CGRectMake(0, originY, width-padding*2-imgWidth, itemHeight)];
    [_detailImgView setFrame:CGRectMake(width-padding-imgWidth, originY + (itemHeight - imgWidth)/2, imgWidth, imgWidth)];
    originY += itemHeight + padding;
}

- (void) updateInfo {
    if (_isChecked) {
        [_finishLbl setText:[[BaseBundle getInstance] getStringByKey:@"energy_status_finished" inTable:nil]];
        _finishLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
        [_timeLbl setContent:_time];
    } else {
        [_finishLbl setText:[[BaseBundle getInstance] getStringByKey:@"energy_status_unfinished" inTable:nil]];
        _finishLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
    }
    
    [_titleLbl setText:_title];
    
    [_locationLbl setContent:_location];
    
    [self updateViews];
}

- (void) setFinished:(BOOL) finished {
    _isChecked = finished;
    [self updateInfo];
}

- (void) setEndTime:(NSString *)time {
    _time = time;
    [self updateInfo];
}

- (void) setInfoWithMeterName:(NSString *) metername
                     location:(NSString *) location
                andFinsihTime:(NSString *) finishtime {
    _title = @"";
    _time = @"";
    _location = @"";
    
    if (![FMUtils isStringEmpty:metername]) {
        _title = metername;
    }
    if (![FMUtils isStringEmpty:location]) {
        _location = location;
    }
    if (![FMUtils isStringEmpty:finishtime]) {
        _time = finishtime;
    }
    
    [self updateInfo];
}

+ (CGFloat) calculateHeightByFinished:(BOOL) finished {
    CGFloat height = 0;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    if (finished) {
        height = itemHeight * 3 + padding * 4;
    } else {
        height = itemHeight * 2 + padding * 3;
    }
    return height;
}

@end

