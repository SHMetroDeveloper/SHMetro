//
//  MaintenanceItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceItemView.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "ColorLabel.h"
#import "PlannedMaintenanceServerConfig.h"
#import "BaseLabelView.h"

@interface MaintenanceItemView ()
@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * timeLbl;
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;
@property (readwrite, nonatomic, strong) ColorLabel * orderLbl;
@property (readwrite, nonatomic, strong) UIImageView * moreImgView;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * time;
@property (readwrite, nonatomic, assign) BOOL hasOrder;
@property (readwrite, nonatomic, assign) NSInteger status;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation MaintenanceItemView

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
        
        _imgWidth = [FMSize getInstance].imgWidthLevel3;
        
        //名字
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [FMFont getInstance].defaultFontLevel2;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        //时间lbl
        _timeLbl = [[BaseLabelView alloc] init];
        [_timeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"ppm_planned_maintain_time" inTable:nil] andLabelWidth:0];
        
        //工单
        _orderLbl = [[ColorLabel alloc] init];
        [_orderLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_VOILET] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_VOILET]];
        [_orderLbl setContent:[[BaseBundle getInstance] getStringByKey:@"ppm_work_order" inTable:nil]];
        
        //状态
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        
        _moreImgView = [[UIImageView alloc] init];
        [_moreImgView setImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        [self addSubview:_nameLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_orderLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_moreImgView];
    }
}



- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    if(width ==0 || height ==0) {
        return;
    }
    //根据变化设置一些控件的参数
    [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[self getStatusColor:_status] andBackgroundColor:[self getStatusColor:_status]];
    
    CGFloat sepHeight = 14;
    CGFloat padding = [FMSize getInstance].listePadding;
    
    //提前获取Lbl大小方便布局
    CGSize orderSize = CGSizeMake(0, 0);
    if(_hasOrder) {
        orderSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"ppm_work_order" inTable:nil]];
    }
    CGSize statusSize = [ColorLabel calculateSizeByInfo:[PlannedMaintenanceServerConfig getMaintenanceStatsDesc:_status]];
    CGFloat itemHeight = 20;
    sepHeight = (height - itemHeight * 2) / 3;
    CGFloat originY = sepHeight;
    CGFloat sepWidth = 7;
    
    
    [_nameLbl setFrame:CGRectMake(padding, originY, width-padding*2 - statusSize.width-orderSize.width - sepWidth*2, itemHeight)];
    if(_hasOrder) {
        [_orderLbl setFrame:CGRectMake(width-padding-statusSize.width-sepWidth-orderSize.width, originY+(itemHeight-orderSize.height)/2, orderSize.width, orderSize.height)];
        [_orderLbl setHidden:NO];
    } else {
        [_orderLbl setHidden:YES];
    }
    [_statusLbl setFrame:CGRectMake(width - padding - statusSize.width, originY+(itemHeight - statusSize.height)/2, statusSize.width, statusSize.height)];
    originY += itemHeight + sepHeight;
    
    [_timeLbl setFrame:CGRectMake(0, originY, width-_imgWidth-padding, itemHeight)];
    [_moreImgView setFrame:CGRectMake(width-padding-_imgWidth, originY+(itemHeight - _imgWidth) /2, _imgWidth, _imgWidth)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (void) updateInfo {
    [_nameLbl setText:_name];
    [_timeLbl setContent:_time];
    [_statusLbl setContent:[PlannedMaintenanceServerConfig getMaintenanceStatsDesc:_status]];
}

- (void) setInfoWithName:(NSString*) name
                    time:(NSString*) time
                  status:(NSInteger) status
                hasOrder:(BOOL) hasOrder{
    _name = [name copy];
    _time = [time copy];
    _status = status;
    _hasOrder = hasOrder;
    [self updateViews];
}

- (UIColor *) getStatusColor:(NSInteger) status {
    MaintenanceTaskStatus astatus = (MaintenanceTaskStatus)status;
    UIColor * color = [PlannedMaintenanceServerConfig getMaintenanceStatsColor:astatus];
    return color;
}

@end
