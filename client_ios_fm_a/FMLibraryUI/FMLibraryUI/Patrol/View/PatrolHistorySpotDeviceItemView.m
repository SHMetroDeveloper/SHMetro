//
//  PatrolHistorySpotDeviceItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/30.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistorySpotDeviceItemView.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "BaseBundle.h"

@interface PatrolHistorySpotDeviceItemView ()

@property (readwrite, nonatomic, strong) NSString * name;  //名称
@property (readwrite, nonatomic, strong) NSString * code;    //编码
@property (readwrite, nonatomic, strong) NSString * system;  //所属系统

@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * systemLbl;


@property (readwrite, nonatomic, strong) UIFont * nameFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;


@end

@implementation PatrolHistorySpotDeviceItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        _nameFont  = [FMFont getInstance].defaultFontLevel2;
        
        _nameLbl = [[UILabel alloc] init];
        _codeLbl = [[UILabel alloc] init];
        _systemLbl = [[UILabel alloc] init];
        
        [self updateSubViews];
        
        [self addSubview:_codeLbl];
        [self addSubview:_nameLbl];
        [self addSubview:_systemLbl];
    }
    return self;
}

- (void) updateSubViews {
    CGRect frame = self.frame;
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGFloat itemHeight = height/2;
    if(!_system) {
        itemHeight = height;
    }
    [_codeLbl setFrame:CGRectMake(_paddingLeft, 0, (width - _paddingLeft - _paddingRight)*2/5, itemHeight)];
    [_nameLbl setFrame:CGRectMake((width - _paddingLeft - _paddingRight)*2/5 + _paddingLeft, 0, (width - _paddingLeft - _paddingRight)*3/5, itemHeight)];
    [_systemLbl setFrame:CGRectMake(_paddingLeft, itemHeight, width, height - itemHeight)];
    
    [_codeLbl setFont:_nameFont];
    [_nameLbl setFont:_nameFont];
    [_systemLbl setFont:_nameFont];
    
    [self updateInfo];
    
}

- (void) setInfoWithName:(NSString*) name
                    code:(NSString*) code
                  system:(NSString*) system {
    _name = name;
    _code = code;
    _system = system;
    [self updateSubViews];
}

- (void) updateInfo {
    if(_name) {
        _nameLbl.text = [[NSString alloc] initWithFormat:@"%@", _name];
    }
    if(_code) {
        _codeLbl.text = [[NSString alloc] initWithFormat:@"%@", _code];;
    }
    if(_system) {
        [_systemLbl setHidden:NO];
        _systemLbl.text = [[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_system" inTable:nil], _system];
    } else {
        [_systemLbl setHidden:YES];
    }
}



- (void) setFont:(UIFont*) font {
    _nameFont = font;
    
    _codeLbl.font = _nameFont;
    _nameLbl.font = _nameFont;
    _systemLbl.font = _nameFont;
}

- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right {
    _paddingLeft = left;
    _paddingRight = right;
    [self updateSubViews];
}

@end
