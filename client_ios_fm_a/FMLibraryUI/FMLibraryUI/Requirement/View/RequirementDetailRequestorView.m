//
//  RequirementDetailRequestorView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/25.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequirementDetailRequestorView.h"
#import "BaseLabelView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMUtils.h"

@interface RequirementDetailRequestorView ()

@property (readwrite, nonatomic, strong) BaseLabelView * nameLbl;       //
@property (readwrite, nonatomic, strong) BaseLabelView * appellationLbl;//称谓
@property (readwrite, nonatomic, strong) BaseLabelView * positionLbl;   //职位
@property (readwrite, nonatomic, strong) BaseLabelView * orgLbl;        //部门
@property (readwrite, nonatomic, strong) BaseLabelView * telphoneLbl;   //电话
@property (readwrite, nonatomic, strong) BaseLabelView * mobileLbl;     //手机

@property (readwrite, nonatomic, strong) RequirementRequestor * requestor;

@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat labelWidth;
@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation RequirementDetailRequestorView

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
        
        _padding = [FMSize getInstance].defaultPadding;
        _labelWidth = 40;
        _defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
        
        _nameLbl = [[BaseLabelView alloc] init];
        _appellationLbl = [[BaseLabelView alloc] init];
        _positionLbl = [[BaseLabelView alloc] init];
        _orgLbl = [[BaseLabelView alloc] init];
        _telphoneLbl = [[BaseLabelView alloc] init];
        _mobileLbl = [[BaseLabelView alloc] init];
        
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_requestor_name" inTable:nil] andLabelWidth:_labelWidth];
        [_appellationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_requestor_appellation" inTable:nil] andLabelWidth:_labelWidth];
        [_positionLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_requestor_position" inTable:nil] andLabelWidth:_labelWidth];
        [_orgLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_requestor_org" inTable:nil] andLabelWidth:_labelWidth];
        [_telphoneLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_requestor_phone" inTable:nil] andLabelWidth:_labelWidth];
        [_mobileLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_requestor_mobile" inTable:nil] andLabelWidth:_labelWidth];
        
        
        [self addSubview:_nameLbl];
        [self addSubview:_appellationLbl];
        [self addSubview:_positionLbl];
        [self addSubview:_orgLbl];
        [self addSubview:_telphoneLbl];
        [self addSubview:_mobileLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat itemHeight;
    CGFloat sepHeight = (height-_defaultItemHeight*3)/4;
    CGFloat originY = sepHeight;
    
    itemHeight = _defaultItemHeight;
    [_nameLbl setFrame:CGRectMake(_padding, originY, width/2-_padding, itemHeight)];
    [_appellationLbl setFrame:CGRectMake(width/2, originY, width/2-_padding, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = _defaultItemHeight;
    [_positionLbl setFrame:CGRectMake(_padding, originY, width/2-_padding, itemHeight)];
    [_orgLbl setFrame:CGRectMake(width/2, originY, width/2-_padding, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = _defaultItemHeight;
    [_telphoneLbl setFrame:CGRectMake(_padding, originY, width/2-_padding, itemHeight)];
    [_mobileLbl setFrame:CGRectMake(width/2, originY, width/2-_padding, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (void) updateInfo {
    if(_requestor) {
        [_nameLbl setContent:_requestor.name];
        [_appellationLbl setContent:_requestor.appellation];
        [_positionLbl setContent:_requestor.position];
        [_orgLbl setContent:_requestor.department];
        [_telphoneLbl setContent:_requestor.telephone];
        [_mobileLbl setContent:_requestor.mobile];
    }
}



- (void) setInfoWith:(RequirementRequestor *) requestor {
    _requestor = requestor;
    [self updateInfo];
}

@end
