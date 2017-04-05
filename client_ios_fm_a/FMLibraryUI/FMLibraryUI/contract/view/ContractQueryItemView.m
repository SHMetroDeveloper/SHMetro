//
//  ContractQueryItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractQueryItemView.h"
#import "ColorLabel.h"
#import "FMUtilsPackages.h"
#import "ContractServerConfig.h"
#import "BaseLabelView.h"


@interface ContractQueryItemView ()
@property (readwrite, nonatomic, strong) UILabel * codeLbl;     //合同编码
@property (readwrite, nonatomic, strong) UILabel * nameLbl;     //合同名称
@property (readwrite, nonatomic, strong) BaseLabelView *typeLbl;  //合同类型
@property (readwrite, nonatomic, strong) BaseLabelView *timeLbl;     //合同有效时间
//@property (readwrite, nonatomic, strong) UILabel * typeLbl;     //合同类型

@property (readwrite, nonatomic, strong) ColorLabel * paymentLbl;  //收付类型
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;    //合同状态

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, strong) ContractEntity * contract;
@end

@implementation ContractQueryItemView

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
        
        _codeLbl = [[UILabel alloc] init];
        _codeLbl.font = [FMFont getInstance].listCodeFont;
        _codeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [FMFont getInstance].listDescFont;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _timeLbl = [[BaseLabelView alloc] init];
        [_timeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"contract_time_life" inTable:nil] andLabelWidth:0];
        
        
        _typeLbl = [[BaseLabelView alloc] init];
        [_typeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"contract_category" inTable:nil] andLabelWidth:0];
        
//        _typeLbl = [[UILabel alloc] init];
//        _typeLbl.font = [FMFont getInstance].listDescFont;
//        _typeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        
        _paymentLbl = [[ColorLabel alloc] init];
        
        
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        
        
        [self addSubview:_codeLbl];
        [self addSubview:_nameLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_typeLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_paymentLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat itemHeight = 16;
    CGFloat sepHeight = (height - itemHeight * 4) / 5;
    CGFloat originY = sepHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat sepWidth = 6;
    
    CGSize statusSize = [ColorLabel calculateSizeByInfo:[ContractServerConfig getStatusDesc:_contract.status]];
    CGSize paymentSize = [ColorLabel calculateSizeByInfo:[ContractServerConfig getPaymentDesc:_contract.payment]];
    
//    CGFloat typeWidth = [FMUtils widthForString:_typeLbl value:_contract.type];
    CGFloat codeWidth = [FMUtils widthForString:_codeLbl value:_contract.code];
    
    
    [_codeLbl setFrame:CGRectMake(padding, originY, codeWidth, itemHeight)];
//    [_typeLbl setFrame:CGRectMake(padding+codeWidth+sepWidth*2, originY, typeWidth, itemHeight)];
    
    [_paymentLbl setFrame:CGRectMake(width-padding-statusSize.width-sepWidth-paymentSize.width, originY+(itemHeight-paymentSize.height)/2, paymentSize.width, paymentSize.height)];
    [_statusLbl setFrame:CGRectMake(width-padding-statusSize.width, originY+(itemHeight-statusSize.height)/2, statusSize.width, statusSize.height)];
    originY += itemHeight + sepHeight;
    
    [_nameLbl setFrame:CGRectMake(padding, originY, width-padding * 2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_typeLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_timeLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (void) updateInfo {
    [_codeLbl setText:_contract.code];
    [_nameLbl setText:_contract.name];
    
    [_typeLbl setContent:_contract.type];
    [_timeLbl setContent:[self getTimeDescription]];
    
    UIColor * color = [self getStatusColor:_contract.status];
    [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:color andBackgroundColor:color];
    [_statusLbl setContent:[ContractServerConfig getStatusDesc:_contract.status]];
    
    color = [self getPaymentColor:_contract.payment];
    [_paymentLbl setTextColor:[UIColor whiteColor] andBorderColor:color andBackgroundColor:color];
    [_paymentLbl setContent:[ContractServerConfig getPaymentDesc:_contract.payment]];
}

- (void) setInfoWithContract:(ContractEntity *) contract {
    _contract = contract;
    [self updateViews];
}

- (UIColor *) getStatusColor:(NSInteger) status {
    ContractStatusType contractStatus = (ContractStatusType)status;
    UIColor * color = [ContractServerConfig getStatusColor:contractStatus];
    return color;
}

- (UIColor *) getPaymentColor:(BOOL) isPayment {
    UIColor * color;
    if(isPayment) {
        color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
    } else {
        color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
    }
    return color;
}

- (NSString *) getTimeDescription {
    NSString * res = @"";
    if(_contract.startTime) {
        if(_contract.endTime) {
            res = [[NSString alloc] initWithFormat:@"%@~%@", [FMUtils getDayStr:[FMUtils timeLongToDate:_contract.startTime]], [FMUtils getDayStr:[FMUtils timeLongToDate:_contract.endTime]]];
        } else {
            res = [[NSString alloc] initWithFormat:@"%@~", [FMUtils getDayStr:[FMUtils timeLongToDate:_contract.startTime]]];
        }
    } else {
        if(_contract.endTime) {
            res = [[NSString alloc] initWithFormat:@"~%@", [FMUtils getDayStr:[FMUtils timeLongToDate:_contract.endTime]]];
        }
    }
    return res;
}

+ (CGFloat) getItemHeight {
    CGFloat height = 0;
    CGFloat codeHeight = 19;
    CGFloat itemHeight = 16;
    CGFloat padding = 14;
    
    height = codeHeight + itemHeight*3 + padding*5;
    
    return height;
}

@end
