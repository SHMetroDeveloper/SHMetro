//
//  SpotContentItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "SpotContentItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"
#import "PatrolTaskEntity.h"
#import "ColorLabel.h"
#import "BaseLabelView.h"
#import "PatrolServerConfig.h"

@interface SpotContentItemView ()
@property (readwrite, nonatomic, strong) NSString * name;   //名称
@property (readwrite, nonatomic, strong) NSString * state;  //完成状态
@property (readwrite, nonatomic, assign) NSInteger count;   //检查项数量
@property (readwrite, nonatomic, assign) BOOL showImage;
@property (readwrite, nonatomic, assign) BOOL isException;  //巡检内容是存在否异常
@property (readwrite, nonatomic, strong) NSNumber * exceptionStatus;//设备异常状态，如停机等

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * countLbl;

@property (readwrite, nonatomic, strong) ColorLabel * exceptionLbl;
@property (readwrite, nonatomic, strong) ColorLabel * stateLbl;

@property (readwrite, nonatomic, strong) UIImageView * moreImgView;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;
@end


@implementation SpotContentItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
    }
    return self;
}

- (void) initViews {
    _imgWidth = [FMSize getInstance].imgWidthLevel3;
    
    UIFont * mFont = [FMFont getInstance].font38;
    UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
    
    
    _showImage = YES;
    
    _nameLbl = [[UILabel alloc] init];
    _nameLbl.font = mFont;
    _nameLbl.textColor = contentColor;
    
    
    _countLbl = [[BaseLabelView alloc] init];
    [_countLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_content_amount" inTable:nil] andLabelWidth:0];
    [_countLbl setLabelFont:mFont andColor:labelColor];
    [_countLbl setLabelAlignment:NSTextAlignmentLeft];
    [_countLbl setContentFont:mFont];
    [_countLbl setContentColor:contentColor];
    [_countLbl setContentAlignment:NSTextAlignmentLeft];
    
    
    
    _stateLbl = [[ColorLabel alloc] init];
    
    _exceptionLbl = [[ColorLabel alloc] init];
    
    _moreImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
    
    
    [self addSubview:_nameLbl];
    [self addSubview:_countLbl];
    [self addSubview:_stateLbl];
    [self addSubview:_exceptionLbl];
    [self addSubview:_moreImgView];
}

- (void) updateViews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat orginX = [FMSize getInstance].listItemPaddingLeft;
    CGFloat orginY = 0;
    CGFloat imgWidth = _imgWidth;
    CGFloat stateWidth = 60;
    CGFloat nameHeight = [FMSize getInstance].listItemInfoHeight;
    CGSize exceptionSize = CGSizeMake(0, 0);
    CGFloat sepWidth = 10;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGFloat sepHeight = (height-nameHeight * 2)/3;
    orginY = sepHeight;
    
    
    
    
    CGSize stateSize = [ColorLabel calculateSizeByInfo:_state];
    if(_isException) {
        exceptionSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
    }
    stateWidth = stateSize.width;
    [_nameLbl setFrame:CGRectMake(orginX, orginY, width - orginX - imgWidth - stateWidth-exceptionSize.width-sepWidth, nameHeight)];
    [_exceptionLbl setFrame:CGRectMake(width-imgWidth-stateWidth-exceptionSize.width - sepWidth, orginY, exceptionSize.width, exceptionSize.height)];
    
    [_stateLbl setFrame:CGRectMake(width-imgWidth-stateWidth, orginY, stateWidth, stateSize.height)];
    orginY += nameHeight + sepHeight;
    
    [_countLbl setFrame:CGRectMake(0, orginY, width - orginX - imgWidth - stateWidth, nameHeight)];
    
    if(!_showImage) {
        [_moreImgView setHidden:YES];
        imgWidth = 0;
    } else {
        [_moreImgView setHidden:NO];
        [_moreImgView setFrame:CGRectMake(width-imgWidth-padding, orginY+(nameHeight-imgWidth)/2, imgWidth, imgWidth)];
        [_moreImgView setImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
    }
    
    orginY += nameHeight + sepHeight;
    
    [self updateInfo];
}

- (void) setInfoWithName:(NSString*) name
                   state:(NSString*) state
               exception:(BOOL) isException
                   count:(NSInteger) count
               showImage:(BOOL) show
         exceptionStatus:(NSNumber *) exceptionStatus{
    _name = name;
    _state = state;
    _count = count;
    _showImage = show;
    _isException = isException;
    _exceptionStatus = [exceptionStatus copy];
    [self updateViews];
}

- (void) updateInfo {
    [_nameLbl setText:_name];
    [_countLbl setContent:[NSString stringWithFormat:@"%ld", _count]];

    if(_exceptionStatus && _exceptionStatus.integerValue == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {
        NSString * exceptionStatus = [PatrolServerConfig getEquipmentStatusDescription:_exceptionStatus.integerValue];
        [_stateLbl setContent:exceptionStatus];
        [_stateLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        
        _isException = NO;  //不用显示巡检内容状态
    } else {
         [_stateLbl setContent:_state];
        if([_state isEqualToString:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_normal" inTable:nil]]) {
            [_stateLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
        } else if([_state isEqualToString:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_exception" inTable:nil]]) {
            [_stateLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        } else {
            [_stateLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        }
    }
    
    
    if(_isException) {
        [_exceptionLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_exception" inTable:nil]];
        [_exceptionLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        [_exceptionLbl setHidden:NO];
    } else {
        [_exceptionLbl setHidden:YES];
    }
}
@end


