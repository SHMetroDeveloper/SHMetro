//
//  RequirementDetailBaseInfoView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/24.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequirementDetailBaseInfoView.h"
#import "ColorLabel.h"
#import "BaseLabelView.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "ServiceCenterServerConfig.h"


@interface RequirementDetailBaseInfoView ()

@property (readwrite, nonatomic, strong) UILabel * requestorLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * codeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * originLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * requestTypeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * locationLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * descLbl;
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;
@property (readwrite, nonatomic, strong) UIButton * telBtn;

@property (readwrite, nonatomic, assign) CGFloat codeWidth;
@property (readwrite, nonatomic, assign) CGFloat typeWidth;
@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, strong) NSString *code;
@property (readwrite, nonatomic, assign) NSInteger status;
@property (readwrite, nonatomic, strong) NSString *type;
@property (readwrite, nonatomic, strong) NSString *desc;
@property (readwrite, nonatomic, strong) NSString *origin;
@property (readwrite, nonatomic, strong) NSString *location;
@property (readwrite, nonatomic, strong) RequirementRequestor *requestor;
@property (readwrite, nonatomic, strong) NSNumber *createDate;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end

@implementation RequirementDetailBaseInfoView

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
        
        _typeWidth = 80;
        _labelWidth = 0;
        _codeWidth = 180;
        _defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
        _padding = 15;
        
        _requestorLbl = [[UILabel alloc] init];
        _codeLbl = [[BaseLabelView alloc] init];
        _originLbl = [[BaseLabelView alloc] init];
        _descLbl = [[BaseLabelView alloc] init];
        _requestTypeLbl = [[BaseLabelView alloc] init];
        _locationLbl = [[BaseLabelView alloc] init];
        _statusLbl = [[ColorLabel alloc] init];
        _telBtn = [[UIButton alloc] init];
        
        
        [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[UIColor clearColor] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        [_statusLbl setShowCorner:YES];
        
        [_telBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"home_phone_call"] forState:UIControlStateNormal];
        _telBtn.tag = Requirement_EVENT_PHONE;
        [_telBtn addTarget:self action:@selector(onPhoneBtnClicked) forControlEvents:UIControlEventAllEvents];

        
        [_codeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_code" inTable:nil] andLabelWidth:_labelWidth];
        [_originLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_origin" inTable:nil] andLabelWidth:_labelWidth];
        [_descLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_desc" inTable:nil] andLabelWidth:_labelWidth];
        [_requestTypeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_type" inTable:nil] andLabelWidth:_labelWidth];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"requirement_location" inTable:nil] andLabelWidth:_labelWidth];

        
        UIFont *mFont = [FMFont fontWithSize:13];
        UIColor *labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _requestorLbl.font = mFont;
        _requestorLbl.textColor = labelColor;
        
        [_codeLbl setLabelFont:mFont andColor:labelColor];
        [_originLbl setLabelFont:mFont andColor:labelColor];
        [_descLbl setLabelFont:mFont andColor:labelColor];
        [_requestTypeLbl setLabelFont:mFont andColor:labelColor];
        [_locationLbl setLabelFont:mFont andColor:labelColor];
        
        
        [_codeLbl setContentFont:mFont];
        [_originLbl setContentFont:mFont];
        [_descLbl setContentFont:mFont];
        [_requestTypeLbl setContentFont:mFont];
        [_locationLbl setContentFont:mFont];
        
        
        [_codeLbl setContentColor:contentColor];
        [_originLbl setContentColor:contentColor];
        [_descLbl setContentColor:contentColor];
        [_requestTypeLbl setContentColor:contentColor];
        [_locationLbl setContentColor:contentColor];

        
        [self addSubview:_requestorLbl];
        [self addSubview:_codeLbl];
        [self addSubview:_originLbl];
        [self addSubview:_requestTypeLbl];
        [self addSubview:_locationLbl];
        [self addSubview:_descLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_telBtn];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat itemHeight = 0;
    CGFloat originY = 0;
    CGFloat sepHeight = 0;
    CGFloat descHeight;
    
    CGFloat paddingLeft = 0;
    CGFloat paddingRight = _padding;
    CGFloat itemWidth = width - paddingLeft - paddingRight;
    
    descHeight = [BaseLabelView calculateHeightByInfo:_desc font:[FMFont getInstance].font38 desc:[[BaseBundle getInstance] getStringByKey:@"requirement_desc" inTable:nil] labelFont:[FMFont getInstance].font38 andLabelWidth:_labelWidth andWidth:itemWidth];
    if(descHeight < _defaultItemHeight) {
        descHeight = _defaultItemHeight;
    }
    
    sepHeight = 10;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    originY = sepHeight;
    itemHeight = _defaultItemHeight;
    CGFloat btnWidth = [FMSize getInstance].imgWidthLevel3;
    
    CGSize statusSize = [ColorLabel calculateSizeByInfo:[ServiceCenterServerConfig getRequirementStatusDescriptionBy:_status]];
    
    [_requestorLbl setFrame:CGRectMake(padding, originY, width - padding*2, itemHeight)];
    [_statusLbl setFrame:CGRectMake(width - padding - statusSize.width, originY + (itemHeight - statusSize.height)/2, statusSize.width, statusSize.height)];
    originY += itemHeight + sepHeight;
    
    [_codeLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_requestTypeLbl setFrame:CGRectMake(0, originY, width-btnWidth-padding, itemHeight)];
    [_telBtn setFrame:CGRectMake(width-padding-btnWidth, originY + (itemHeight - btnWidth)/2, btnWidth, btnWidth)];
    originY += itemHeight + sepHeight;
    
    
    [_originLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_locationLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = descHeight;
    [_descLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (void) updateInfo {
    [_codeLbl setContent:_code];
    [_originLbl setContent:_origin];
    [_locationLbl setContent:_location];
    [_descLbl setContent:_desc];
    [_requestTypeLbl setContent:_type];
    [_statusLbl setContent:[ServiceCenterServerConfig getRequirementStatusDescriptionBy:_status]];
    UIColor * statusColor = [ServiceCenterServerConfig getColorByStatus:_status];
    [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:statusColor andBackgroundColor:statusColor];
    
    NSString *createTime = @"";
    NSString *name = @"";
    if (_createDate) {
        createTime = [FMUtils getDateTimeDescriptionBy:_createDate format:@"MM-dd hh:mm"];
    }
    if (_requestor) {
        name = _requestor.name;
    }
    [_requestorLbl setText:[NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"requirement_requestor_format" inTable:nil], name,createTime]];
}

- (void) setInfoWith:(NSString *)code
              status:(NSInteger)status
                type:(NSString *)type
                desc:(NSString *)desc
              origin:(NSString *)origin
            location:(NSString *)location
           requestor:(RequirementRequestor *) requestor
          createDate:(NSNumber *) createDate {
    
    _code = code;
    _status = status;
    _type = type;
    _desc = desc;
    _origin = origin;
    _requestor = requestor;
    _createDate = createDate;
    [self updateViews];
}

- (void) onPhoneBtnClicked {
    if(_listener) {
        [_listener onItemClick:self subView:_telBtn];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    if (listener) {
        _listener = listener;
    }
}

+ (CGFloat) calculateHeightByDesc:(NSString *) desc width:(CGFloat) width {
    CGFloat height = 0;
    CGFloat sepHeight = 10;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat itemWidth = width;
    
    CGFloat descHeight = [BaseLabelView calculateHeightByInfo:desc font:[FMFont getInstance].font38 desc:[[BaseBundle getInstance] getStringByKey:@"requirement_desc" inTable:nil] labelFont:[FMFont getInstance].font38 andLabelWidth:0 andWidth:itemWidth];
    if(descHeight < defaultItemHeight) {
        descHeight = defaultItemHeight;
    }
    height = descHeight + defaultItemHeight * 5 + sepHeight * 7;
    return height;
}

@end
