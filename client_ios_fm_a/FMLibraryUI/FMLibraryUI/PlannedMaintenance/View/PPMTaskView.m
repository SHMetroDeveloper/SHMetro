//
//  PPMTaskView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/23.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "PPMTaskView.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"
#import "ColorLabel.h"
#import "BaseLabelView.h"

@interface PPMTaskView()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) ColorLabel * typeColorLbl;
@property (readwrite, nonatomic, strong) ColorLabel * statusColorLbl;
@property (readwrite, nonatomic, strong) UIImageView * moreDetailImgView;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, assign) BOOL hasWorkOrder;
@property (readwrite, nonatomic, assign) NSInteger status;
@property (readwrite, nonatomic, strong) NSNumber * time;


@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation PPMTaskView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2];
        
        //计划性维护名称
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = mFont;
        _nameLbl.textColor = textColor;
        _nameLbl.numberOfLines = 1;
        
        //任务有无工单Colorlbl
        _typeColorLbl = [[ColorLabel alloc] init];
        [_typeColorLbl setShowCorner:YES];
        [_typeColorLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        
        //任务状态Colorlbl
        _statusColorLbl = [[ColorLabel alloc] init];
        [_statusColorLbl setShowCorner:YES];
        [_statusColorLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        
        //维护时间lbl
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.numberOfLines = 1;
        _timeLbl.textAlignment = NSTextAlignmentLeft;
        _timeLbl.font = mFont;
        
        //showmoredetailImageView
        _moreDetailImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        
        [self addSubview:_nameLbl];
        [self addSubview:_typeColorLbl];
        [self addSubview:_statusColorLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_moreDetailImgView];
    }
}

- (void) updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat padding = [FMSize getInstance].padding50;
    CGFloat imageWidth = 31;
    
    CGFloat originX = padding;
    CGFloat originY = padding;
    
    CGSize nameSize = [FMUtils getLabelSizeBy:_nameLbl andContent:_nameLbl.text andMaxLabelWidth:width];
    CGSize typeSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"ppm_work_order" inTable:nil]];
    CGSize statusSzie = [ColorLabel calculateSizeByInfo:@"漏检"];
    CGSize timeSize = [FMUtils getLabelSizeBy:_timeLbl andContent:_timeLbl.text andMaxLabelWidth:width];
    
    
    [_nameLbl setFrame:CGRectMake(originX, originY, nameSize.width, nameSize.height)];
    originX = width-padding-statusSzie.width;
    
    [_statusColorLbl setFrame:CGRectMake(originX, originY + (nameSize.height - statusSzie.height)/2, statusSzie.width, statusSzie.height)];
    originX -= padding - typeSize.width;
    
    [_typeColorLbl setFrame:CGRectMake(originX, originY + (nameSize.height - typeSize.height)/2, typeSize.width, typeSize.height)];
    originX = padding;
    originY += nameSize.height + padding;
    
    [_timeLbl setFrame:CGRectMake(originX, originY, timeSize.width, timeSize.height)];
    originX = width - padding - imageWidth;
    
    [_moreDetailImgView setFrame:CGRectMake(originX, originY, imageWidth, imageWidth)];
    
}

- (void) updateInfo {
    [_nameLbl setText:_name];
    
    if (_hasWorkOrder) {
        [_typeColorLbl setContent:[[BaseBundle getInstance] getStringByKey:@"ppm_work_order" inTable:nil]];
    } else {
        _typeColorLbl = nil;
    }
    
    [_statusColorLbl setContent:@"漏检"];
    
    
    NSString *timeStr = [FMUtils getDateTimeDescriptionBy:_time format:@"yyyy-MM-dd"];
    NSString *title = [[BaseBundle getInstance] getStringByKey:@"ppm_planned_maintain_time" inTable:nil];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title,timeStr]];
    [str addAttribute:NSForegroundColorAttributeName value:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3] range:NSMakeRange(0, title.length-1)];
    [str addAttribute:NSForegroundColorAttributeName value:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2] range:NSMakeRange(title.length, str.length-1)];
    [_timeLbl setText:str];
    
    
    [self updateViews];
}

- (void) setInfoWithName:(NSString *) name
            hasWorkOrder:(BOOL) hasorder
                  status:(NSInteger) status
                    time:(NSNumber *) time {
    if (name) {
        _name = [name copy];
    } else {
        _name = @"";
    }
    
    _hasWorkOrder = hasorder;
    
    _status = status;
    
    _time = [time copy];
    
    [self updateInfo];
}

//+ (CGFloat) calculateHeightBy 



@end










