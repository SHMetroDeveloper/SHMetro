//
//  EnergyMissionListView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/7/11.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "EnergyMissionListView.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface EnergyMissionListView ()

@property (nonatomic, strong) UILabel *missionTitleLbl;
@property (nonatomic, strong) BaseLabelView *missionDescLbl;
@property (nonatomic, strong) BaseLabelView *lastTimeLbl;
@property (nonatomic, strong) UIImageView *detailImgView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *lastTime;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation EnergyMissionListView

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
        [self updateViews];
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
        
        UIColor *lightColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *darkColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _missionTitleLbl = [UILabel new];
        _missionTitleLbl.textColor = darkColor;
        _missionTitleLbl.font = [FMFont getInstance].font42;
        _missionTitleLbl.textAlignment = NSTextAlignmentLeft;
        
        
        _missionDescLbl = [[BaseLabelView alloc] init];
        [_missionDescLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"energy_task_cycle" inTable:nil] andLabelWidth:0];
        [_missionDescLbl setLabelFont:[FMFont getInstance].font38 andColor:lightColor];
        [_missionDescLbl setLabelAlignment:NSTextAlignmentLeft];
        [_missionDescLbl setContentFont:[FMFont getInstance].font38];
        [_missionDescLbl setContentColor:darkColor];
        
        _lastTimeLbl = [[BaseLabelView alloc] init];
        [_lastTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"energy_task_lastTime" inTable:nil] andLabelWidth:0];
        [_lastTimeLbl setLabelFont:[FMFont getInstance].font38 andColor:lightColor];
        [_lastTimeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_lastTimeLbl setContentFont:[FMFont getInstance].font38];
        [_lastTimeLbl setContentColor:darkColor];
        
        
        
        _detailImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        [self addSubview:_missionTitleLbl];
        [self addSubview:_lastTimeLbl];
        [self addSubview:_missionDescLbl];
        [self addSubview:_detailImgView];
    }
}

- (void) updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    if(width == 0) {
        return;
    }
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat imgWidth = [FMSize getInstance].imgWidthLevel3;
    CGFloat originX = padding;
    CGFloat originY = padding;
    
    [_missionTitleLbl setFrame:CGRectMake(originX, originY, width-padding*2, itemHeight)];
    originY += padding + itemHeight;
    
    if(_lastTime) {
        [_lastTimeLbl setHidden:NO];
        [_lastTimeLbl setFrame:CGRectMake(0, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
    } else {
        [_lastTimeLbl setHidden:YES];
    }
    
    [_missionDescLbl setFrame:CGRectMake(0, originY, width-padding*2-imgWidth, itemHeight)];
    [_detailImgView setFrame:CGRectMake(width-padding-imgWidth, originY + (itemHeight - imgWidth)/2, imgWidth, imgWidth)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_missionTitleLbl setText:_title];
    [_missionDescLbl setContent:_desc];
    if(_lastTime) {
        [_lastTimeLbl setContent:[FMUtils getMinuteStr:[FMUtils timeLongToDate:_lastTime]]];
    }
}


- (void) setInfoWithTitle:(NSString *) title
              description:(NSString *) desc
           lastSubmitTime:(NSNumber *) lastTime {
    _title = title;
    _desc = desc;
    _lastTime = lastTime;
    [self updateViews];
}


+ (CGFloat) calculateheightByLastTime:(NSNumber *) lastTime {
    CGFloat height = 0;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    height = itemHeight * 2 + padding * 3;
    
    if(lastTime) {
        height += itemHeight + padding;
    }
    
    return height;
}


@end

