//
//  DemandListView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequirementItemView.h"
#import "BaseLabelView.h"
#import "ColorLabel.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "ServiceCenterServerConfig.h"


@interface RequirementItemView ()
@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;
@property (readwrite, nonatomic, strong) UIImageView * originImgView;


@property (readwrite, nonatomic, assign) NSInteger originSource;

@property (readwrite, nonatomic, strong) RequirementEntity * requirement;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation RequirementItemView

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
    if(!_isInited) {
        _isInited = YES;
        
        UIFont * bigFont = [FMFont getInstance].font44;
        UIFont * smallFont = [FMFont getInstance].font38;
        UIColor *darkColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        UIColor *lighrColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        //需求编号
        _codeLbl = [[UILabel alloc] init];
        _codeLbl.font = bigFont;
        _codeLbl.textColor = darkColor;
        _codeLbl.textAlignment = NSTextAlignmentLeft;
        
        
        //时间
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.font = smallFont;
        _timeLbl.textColor = lighrColor;;
        _timeLbl.textAlignment = NSTextAlignmentLeft;
        
        
        //需求描述
        _descLbl = [[UILabel alloc] init];
        _descLbl.font = smallFont;
        _descLbl.textColor = darkColor;
        _descLbl.textAlignment = NSTextAlignmentLeft;
        _descLbl.numberOfLines = 1;
        
        
        //需求来源
        _originImgView = [[UIImageView alloc] init];
        
        
        //需求状态
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setShowCorner:YES];

        [self addSubview:_codeLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_descLbl];
        [self addSubview:_originImgView];
        [self addSubview:_statusLbl];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat codeHeight = 19;
    CGFloat itemHeight = 16;
    CGFloat codeWidth = 0;
    CGFloat imgWidth = 16;
    CGFloat sepWidth = 5;
    CGFloat sepHeight = 14;  //14
    
    CGFloat originY = sepHeight;
    CGFloat originX = padding;
    
    
    codeWidth = [FMUtils widthForString:_codeLbl value:_requirement.code];
    [_codeLbl setFrame:CGRectMake(originX, originY, codeWidth, codeHeight)];
    originX += codeWidth + sepWidth*6;
    
    [_originImgView setFrame:CGRectMake(originX, originY+(codeHeight-imgWidth)/2, imgWidth, imgWidth)];
    
    CGSize statusSize = [ColorLabel calculateSizeByInfo:[_requirement getStatusDescription]];
    UIColor * statusColor = [ServiceCenterServerConfig getColorByStatus:_requirement.status];

    [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:statusColor andBackgroundColor:statusColor];
    [_statusLbl setFrame:CGRectMake(width-statusSize.width-padding, originY+(codeHeight-statusSize.height)/2, statusSize.width, statusSize.height)];
    
    originY += codeHeight + sepHeight;
    originX = padding;
    
    [_timeLbl setFrame:CGRectMake(originX, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_descLbl setFrame:CGRectMake(originX, originY, width-padding*2, itemHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    if(_requirement) {
        [_codeLbl setText:_requirement.code];
        
        [_descLbl setText:_requirement.desc];
        
        _originSource = _requirement.origin;
        switch (_originSource) {
            case 0:
                [_originImgView setImage:[[FMTheme getInstance] getImageByName:@"webOrigin"]];
                break;
            case 1:
                [_originImgView setImage:[[FMTheme getInstance] getImageByName:@"mobileOrigin"]];
                break;
            case 2:
                [_originImgView setImage:[[FMTheme getInstance] getImageByName:@"wechatOrigin"]];
                break;
            case 3:
                [_originImgView setImage:[[FMTheme getInstance] getImageByName:@"mailOrigin"]];  //TODO:此处图标需要更换为邮件的图标
                break;
        }
        [_statusLbl setContent:[_requirement getStatusDescription]];
        [_timeLbl setText:[_requirement getTimeDescription]];
    }
}

- (void) setInfoWith:(RequirementEntity *) requirement {
    _requirement = requirement;
    [self updateViews];
}

+ (CGFloat) getItemHeight {
    CGFloat height = 0;
    CGFloat codeHeight = 19;
    CGFloat itemHeight = 16;
    CGFloat padding = 14;
    
    height = codeHeight + itemHeight*2 + padding*4;
    
    return height;
}


@end
