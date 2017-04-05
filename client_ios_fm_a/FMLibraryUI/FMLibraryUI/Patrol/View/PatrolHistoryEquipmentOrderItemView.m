//
//  PatrolHistoryEquipmentOrderItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistoryEquipmentOrderItemView.h"
#import "BaseLabelView.h"
#import "ColorLabel.h"
#import "BaseBundle.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"

@interface PatrolHistoryEquipmentOrderItemView ()

@property (nonatomic, strong) UILabel * codeBaseLbl;
@property (nonatomic, strong) UIImageView * moreImg;
//@property (readwrite, nonatomic, strong) BaseLabelView * laborerBaseLbl;
//@property (readwrite, nonatomic, strong) BaseLabelView * timeBaseLbl;
//@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;

@property (readwrite, nonatomic, strong) NSString * code;
@property (readwrite, nonatomic, strong) NSString * laborer;
@property (readwrite, nonatomic, strong) NSString * time;
@property (readwrite, nonatomic, strong) NSString * status;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, assign) CGFloat timeWidth;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation PatrolHistoryEquipmentOrderItemView

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
        
        _paddingLeft = 10;
        _paddingRight = 10;
        _labelWidth = 60;
        _timeWidth = 140;
        
        _codeBaseLbl = [[UILabel alloc] init];
        _codeBaseLbl.font = [FMFont getInstance].font38;
        _codeBaseLbl.textColor = [UIColor colorWithRed:16/255.0 green:174/255.0 blue:255/255.0 alpha:1.0];
        
        _moreImg = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];

        
        
//        _laborerBaseLbl = [[BaseLabelView alloc] init];
//        _timeBaseLbl = [[BaseLabelView alloc] init];
//        _statusLbl = [[ColorLabel alloc] init];
        
        
        
//        [_codeBaseLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_code" inTable:nil] andLabelWidth:_labelWidth];
//        [_laborerBaseLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_laborer" inTable:nil] andLabelWidth:_labelWidth];
//        
//        [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
//        [_timeBaseLbl setContentAlignment:NSTextAlignmentRight];
//        [_timeBaseLbl setContentColor:[FMColor getInstance].mainGray];
        
        [self addSubview:_codeBaseLbl];
        [self addSubview:_moreImg];
//        [self addSubview:_laborerBaseLbl];
//        [self addSubview:_timeBaseLbl];
//        [self addSubview:_statusLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    
    CGFloat imgWidth = [FMSize getInstance].imgWidthLevel3;
    CGFloat padding = [FMSize getInstance].padding50;
    CGSize codeSize = [FMUtils getLabelSizeBy:_codeBaseLbl andContent:_code andMaxLabelWidth:width];
    
    CGFloat originY = (height-codeSize.height)/2;
    
    [_codeBaseLbl setFrame:CGRectMake(padding, originY, codeSize.width, codeSize.height)];
    
    [_moreImg setFrame:CGRectMake(width-padding-imgWidth, (height - imgWidth)/2, imgWidth, imgWidth)];
    
    
//    CGFloat itemHeight = 30;
//    CGFloat sepHeight = (height - itemHeight*2) / 3;

//    CGSize statusSize = [ColorLabel calculateSizeByInfo:_status];
    
//    [_statusLbl setFrame:CGRectMake(width-_paddingRight-statusSize.width, originY, statusSize.width, statusSize.height)];
//    originY += itemHeight + sepHeight;
//    
//    [_laborerBaseLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight-_timeWidth, itemHeight)];
//    [_timeBaseLbl setFrame:CGRectMake(width-_paddingRight-_timeWidth, originY, _timeWidth, itemHeight)];
//    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (void) updateInfo {
    [_codeBaseLbl setText:_code];
//    [_statusLbl setContent:_status];
//    [_laborerBaseLbl setContent:_laborer];
//    [_timeBaseLbl setContent:_time];
}

- (void) setInfoWithCode:(NSString *) code andLaborder:(NSString *) laborer andTime:(NSString *) time andStatus:(NSString *) status{
    if(code){
        _code = [code copy];
    } else {
        _code = @"";
    }
    if(laborer) {
        _laborer = laborer;
    } else {
        _laborer = @"";
    }
    if(time) {
        _time = time;
    } else {
        _time = @"";
    }
    if(status) {
        _status = status;
    } else {
        _status = @"";
    }
    
    [self updateViews];
}

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}

@end

