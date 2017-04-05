//
//  MaintenanceDetailOrderItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceDetailOrderItemView.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "ColorLabel.h"
#import "BaseLabelView.h"
#import "WorkOrderServerConfig.h"

@interface MaintenanceDetailOrderItemView ()


@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * applicantNameLbl;
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * locationLbl;

//@property (readwrite, nonatomic, strong) UILabel * phoneLbl;
//@property (readwrite, nonatomic, strong) UIImageView * phoneImgView;

@property (readwrite, nonatomic, strong) ColorLabel * priorityLbl;

@property(readwrite, nonatomic, strong) MaintenanceDetailOrderModel * model;
@property (readwrite, nonatomic, assign) CGFloat timeWidth;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation MaintenanceDetailOrderItemView

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
        _timeWidth = 100;
        
        _imgWidth = [FMSize getInstance].imgWidthLevel2;
        
        _codeLbl = [[UILabel alloc]init];
        _applicantNameLbl = [[BaseLabelView alloc]init];
        _statusLbl = [[ColorLabel alloc]init];
        _timeLbl = [[UILabel alloc]init];
        _locationLbl = [[BaseLabelView alloc]init];
//        _phoneLbl = [[UILabel alloc]init];
//        _phoneImgView = [[UIImageView alloc] init];
        
        _priorityLbl = [[ColorLabel alloc] init];
        
        _codeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _timeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        [_applicantNameLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"requirement_req_person" inTable:nil] andLabelWidth:0];
        [_locationLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"requirement_req_loaction" inTable:nil] andLabelWidth:0];
        
        UIFont * font = [FMFont getInstance].defaultFontLevel2;
        _timeLbl.font = font;
        _codeLbl.font = font;
//        [_phoneLbl setFont:font];
        
        _timeLbl.textAlignment = NSTextAlignmentRight;
        
        [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
//        [_phoneImgView setImage:[[FMTheme getInstance] getImageByName:@"home_my_phone"]];
        
        
        [self addSubview:_codeLbl];
        [self addSubview:_applicantNameLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_locationLbl];
//        [self addSubview:_phoneLbl];
//        [self addSubview:_phoneImgView];
        [self addSubview:_priorityLbl];
    }
}

- (void)updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat paddingTop = 16;
    CGFloat paggingLeft = [FMSize getInstance].defaultPadding;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat itemHeight = 0;
    CGFloat originY = 0;
    CGFloat originX = paggingLeft;
    CGFloat sepHeight = 0;
    CGFloat sepWidth = 5;
    CGFloat locationHeight = [BaseLabelView calculateHeightByInfo:_model.location font:nil desc: [[BaseBundle getInstance] getStringByKey:@"requirement_req_loaction" inTable:nil] labelFont:nil andLabelWidth:0 andWidth:width-paggingLeft];
    if(locationHeight < defaultItemHeight) {
        locationHeight = defaultItemHeight;
    }
    
    sepHeight = (height - defaultItemHeight * 2 - locationHeight - paddingTop * 2) / 2;
    originY = paddingTop;
    
    CGFloat codeWidth = [FMUtils widthForString:_codeLbl value:_model.code];
    CGSize statusSize = [ColorLabel calculateSizeByInfo:[WorkOrderServerConfig getOrderStatusDesc:_model.status]];
//                         _model.status];
    CGFloat nameWidth = width-paggingLeft;
    
    itemHeight = defaultItemHeight;
    [_codeLbl setFrame:CGRectMake(originX, originY, codeWidth, itemHeight)];
    originX += codeWidth + sepWidth;
    [_statusLbl setFrame:CGRectMake(originX, originY + (itemHeight - statusSize.height)/2, statusSize.width, statusSize.height)];
    [_timeLbl setFrame:CGRectMake(width-paggingLeft-_timeWidth, originY, _timeWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    
    originX = paggingLeft;
    [_applicantNameLbl setFrame:CGRectMake(0, originY, nameWidth, itemHeight)];
    originX += nameWidth + sepWidth;
    
//    [_phoneImgView setFrame:CGRectMake(originX, originY + (itemHeight - _imgWidth)/2, _imgWidth, _imgWidth)];
//    originX += _imgWidth;
//    CGFloat phoneWidth = width-paggingLeft-originX;
//    [_phoneLbl setFrame:CGRectMake(originX, originY, phoneWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = locationHeight;
    [_locationLbl setFrame:CGRectMake(0, originY, width-paggingLeft*2, itemHeight)];
    
    [self updateInfo];
}

- (void) setInfoWith:(MaintenanceDetailOrderModel *) model {
    _model = model;
    [self updateViews];
}


- (void) updateInfo {
    [_codeLbl setText:_model.code];
    [_applicantNameLbl setContent:_model.applicant];
    [_timeLbl setText:_model.time];
    [_locationLbl setContent:_model.location];
//    [_phoneLbl setText:_model.phone];
    [_statusLbl setContent:[WorkOrderServerConfig getOrderStatusDesc:_model.status]];
    [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[WorkOrderServerConfig getOrderStatusColor:_model.status] andBackgroundColor:[WorkOrderServerConfig getOrderStatusColor:_model.status]];
}

+ (CGFloat) calculateHeightByModel:(MaintenanceDetailOrderModel *) model andWidth:(CGFloat) width {
    CGFloat height = 0;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat sepHeight = 14;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat paddingTop = 16;
    UILabel * locationLbl = [[UILabel alloc] init];
    locationLbl.font = [FMFont getInstance].defaultFontLevel2;
    locationLbl.numberOfLines = 0;
    
    CGFloat  locationHeight = [FMUtils heightForStringWith:locationLbl value:model.location andWidth:width-padding * 2];
    if(locationHeight < defaultItemHeight) {
        locationHeight = defaultItemHeight;
    }
    height = locationHeight + defaultItemHeight * 2 + sepHeight * 2 + paddingTop * 2;
    return height;
}

@end
