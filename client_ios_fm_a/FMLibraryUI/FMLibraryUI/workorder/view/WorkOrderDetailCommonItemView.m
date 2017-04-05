//
//  WorkOrderDetailCommonItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  工单详情部分的 基本信息

#import "WorkOrderDetailCommonItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseLabelView.h"
#import "ResizeableLabelView.h"
#import "ColorLabel.h"
#import "WorkOrderServerConfig.h"
#import "SeperatorView.h"



@interface WorkOrderDetailCommonItemView ()

@property (readwrite, nonatomic, strong) NSString * createTime; //工单创建时间
@property (readwrite, nonatomic, strong) NSString * contact;    //申请人
@property (readwrite, nonatomic, strong) NSString * telno;      //联系电话
@property (readwrite, nonatomic, strong) NSString * org;        //部门
@property (readwrite, nonatomic, strong) NSString * serviceType;//服务类型
@property (readwrite, nonatomic, strong) NSString * location;   //位置
@property (readwrite, nonatomic, strong) NSString * estimateTime; //预估时间
@property (readwrite, nonatomic, strong) NSString * reserveTime; //预约时间
@property (readwrite, nonatomic, strong) NSString * desc;       //问题描述
@property (readwrite, nonatomic, assign) WorkOrderStatus status;
@property (readwrite, nonatomic, assign) NSInteger priority;

@property (readwrite, nonatomic, strong) BaseLabelView * createTimeLbl;
@property (readwrite, nonatomic, strong) UILabel * priorityLbl;   //优先级
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;//状态
@property (readwrite, nonatomic, strong) BaseLabelView * reserveTimeLbl;    //预约时间
@property (readwrite, nonatomic, strong) BaseLabelView * locationLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * descLbl;

@property (readwrite, nonatomic, strong) SeperatorView * expandSeperator;

//@property (readwrite, nonatomic, strong) BaseLabelView * contactLbl;
@property (readwrite, nonatomic, strong) UIButton * telnoBtn;
@property (readwrite, nonatomic, strong) UIImageView * telnoIV;
@property (readwrite, nonatomic, strong) BaseLabelView * orgLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * serviceTypeLbl;



@property (readwrite, nonatomic, strong) BaseLabelView * estimateTimeLbl;   //预估时间

@property (readwrite, nonatomic, assign) CGFloat telnoWidth;    //联系人所占宽度
@property (readwrite, nonatomic, assign) CGFloat imgWidth;      //图片所占宽度

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, strong) UIFont * font;

@property (readwrite, nonatomic, assign) BOOL expand;   //是否展开

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> itemListener;
@end

@implementation WorkOrderDetailCommonItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initSubViews];
        [self updateSubViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubViews];
}

- (void) initSubViews {
    if(!_isInited) {
        _isInited = YES;
        
        _telnoWidth = 30;
        _labelWidth = 0;
        _imgWidth = 18;
        
        _font = [FMFont fontWithSize:13];
        
        
        _createTimeLbl = [[BaseLabelView alloc] init];
        _telnoBtn = [[UIButton alloc] init];
        _telnoIV = [[UIImageView alloc] init];
        _orgLbl = [[BaseLabelView alloc] init];
        _serviceTypeLbl = [[BaseLabelView alloc] init];
        _locationLbl = [[BaseLabelView alloc] init];
        _descLbl = [[BaseLabelView alloc] init];
        _reserveTimeLbl = [[BaseLabelView alloc] init];
        _estimateTimeLbl = [[BaseLabelView alloc] init];
        _priorityLbl = [[UILabel alloc] init];
        _statusLbl = [[ColorLabel alloc] init];
        _expandSeperator = [[SeperatorView alloc] init];
        
        [_createTimeLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        _priorityLbl.font = [FMFont getInstance].defaultFontLevel3;
        _priorityLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        [_orgLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_detail_common_org" inTable:nil] andLabelWidth:_labelWidth];
        [_serviceTypeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_detail_common_serviceType" inTable:nil] andLabelWidth:_labelWidth];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_detail_common_location" inTable:nil] andLabelWidth:_labelWidth];
        [_descLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_detail_common_desc" inTable:nil] andLabelWidth:_labelWidth];
        
        [_reserveTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_detail_common_time_reserve" inTable:nil] andLabelWidth:_labelWidth];
        [_estimateTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_detail_common_time_estimate" inTable:nil] andLabelWidth:_labelWidth];
        
        [_createTimeLbl setContentFont:_font];
        [_reserveTimeLbl setContentFont:_font];
        [_locationLbl setContentFont:_font];
        [_descLbl setContentFont:_font];
        [_orgLbl setContentFont:_font];
        [_serviceTypeLbl setContentFont:_font];
        [_estimateTimeLbl setContentFont:_font];
        
        [_orgLbl setLabelFont:_font andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        [_serviceTypeLbl setLabelFont:_font andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        [_locationLbl setLabelFont:_font andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        [_descLbl setLabelFont:_font andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        
        [_reserveTimeLbl setLabelFont:_font andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        
        [_estimateTimeLbl setLabelFont:_font andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        
        _telnoIV.image = [[FMTheme getInstance] getImageByName:@"home_phone_call"];
        
        [_telnoBtn addSubview:_telnoIV];
        [_telnoBtn addTarget:self action:@selector(onTelnoButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_createTimeLbl];
//        [self addSubview:_contactLbl];
        [self addSubview:_priorityLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_reserveTimeLbl];
        [self addSubview:_telnoBtn];
        [self addSubview:_locationLbl];
        [self addSubview:_descLbl];
        
        [self addSubview:_expandSeperator];
        
        [self addSubview:_orgLbl];
        [self addSubview:_serviceTypeLbl];
        
        
        [self addSubview:_estimateTimeLbl];
        
    }
}

- (void) updateSubViews {
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat originY = 0;
    CGFloat sepHeight = 9;
    CGFloat itemHeight = 0;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight + 5;
    CGFloat sepWidth = 10;  //优先级与状态之间的间隔
    CGFloat paddingTop = 13;
    CGFloat paddingBottom = paddingTop;
    
    NSString * strStatus = [WorkOrderServerConfig getOrderStatusDesc:_status];
    CGSize statusSize = [ColorLabel calculateSizeByInfo:strStatus];
    NSString * strPriority = [WorkOrderServerConfig getOrderPriorityLevelDesc:_priority];
    CGFloat priorityWidth = [FMUtils widthForString:_priorityLbl value:strPriority];
    
    originY = paddingTop;
    
    itemHeight = defaultItemHeight;
    [_createTimeLbl setFrame:CGRectMake(0, originY, width - _paddingRight-statusSize.width-priorityWidth, itemHeight)];
    [_statusLbl setFrame:CGRectMake(width-_paddingRight-statusSize.width, originY + (itemHeight-statusSize.height)/2 , statusSize.width, statusSize.height)];
    [_priorityLbl setFrame:CGRectMake(width-_paddingRight-statusSize.width-priorityWidth-sepWidth*1.5, originY , priorityWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    
    itemHeight = defaultItemHeight;
    [_reserveTimeLbl setFrame:CGRectMake(0, originY, width - _paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    if(![FMUtils isStringEmpty:_location]) {
        itemHeight = [BaseLabelView calculateHeightByInfo:_location font:_font desc:[[BaseBundle getInstance] getStringByKey:@"report_location" inTable:nil] labelFont:_font andLabelWidth:_labelWidth andWidth:width - _paddingRight-_telnoWidth];
    }
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_locationLbl setFrame:CGRectMake(0, originY, width - _paddingRight-_telnoWidth, itemHeight)];
    
    [_telnoIV setFrame:CGRectMake((_telnoWidth - _imgWidth)/2, (_telnoWidth - _imgWidth)/2, _imgWidth, _imgWidth)];
    [_telnoBtn setFrame:CGRectMake(width - _telnoWidth - _paddingRight, originY + (itemHeight - _telnoWidth)/2, _telnoWidth, _telnoWidth)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    if(![FMUtils isStringEmpty:_desc]) {
        itemHeight = [BaseLabelView calculateHeightByInfo:_desc font:_font desc:[[BaseBundle getInstance] getStringByKey:@"label_desc" inTable:nil] labelFont:_font andLabelWidth:_labelWidth andWidth:width - _paddingRight];
    }
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_descLbl setFrame:CGRectMake(0, originY, width - _paddingRight, itemHeight)];
    originY += itemHeight + paddingBottom;
    
    if(_expand) {
        
        CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
        [_expandSeperator setFrame:CGRectMake(0, originY, width, seperatorHeight)];
        
//        originY += seperatorHeight;
        
        originY += paddingTop;
        itemHeight = [BaseLabelView calculateHeightByInfo:_org font:_font desc:[[BaseBundle getInstance] getStringByKey:@"report_org" inTable:nil] labelFont:_font andLabelWidth:_labelWidth andWidth:width-_paddingRight];
        if(itemHeight < defaultItemHeight) {
            itemHeight = defaultItemHeight;
        }
        [_orgLbl setFrame:CGRectMake(0, originY, width-_paddingRight, itemHeight)];
        originY += itemHeight + sepHeight;
        
        itemHeight = [BaseLabelView calculateHeightByInfo:_serviceType font:_font desc:[[BaseBundle getInstance] getStringByKey:@"report_service_type" inTable:nil] labelFont:_font andLabelWidth:_labelWidth andWidth:width-_paddingRight];
        if(itemHeight < defaultItemHeight) {
            itemHeight = defaultItemHeight;
        }
        [_serviceTypeLbl setFrame:CGRectMake(0, originY, width-_paddingRight, itemHeight)];
        originY += itemHeight + sepHeight;
        
        
        itemHeight = defaultItemHeight;
        [_estimateTimeLbl setFrame:CGRectMake(0, originY, width - _paddingRight, itemHeight)];
        originY += itemHeight + paddingBottom;
        
        [_expandSeperator setHidden:NO];
        [_orgLbl setHidden:NO];
        [_serviceTypeLbl setHidden:NO];
    } else {
        [_expandSeperator setHidden:YES];
        [_orgLbl setHidden:YES];
        [_serviceTypeLbl setHidden:YES];
    }
    
    if(originY != height) {
        CGSize newSize = CGSizeMake(width, originY);
        [self notifyViewNeedResized:newSize];
    }
    
    [self updateInfo];
}

- (void) setExpand:(BOOL)expand {
    if(_expand != expand) {
        _expand = expand;
        [self updateSubViews];
    }
}

- (void) setInfoWithCreateTime:(NSString*) createTime
                       contact:(NSString*) contact
                         telno:(NSString*) telno
                           org:(NSString*) org
                   serviceType:(NSString*) serviceType
                      location:(NSString*) location
                  estimateTime:(NSString*) estimateTime
                   reserveTime:(NSString*) reserveTime
                          desc:(NSString*) desc
                      priority:(NSInteger) priority
                        status:(NSInteger) status{
    if(![FMUtils isStringEmpty:createTime]) {
        _createTime = createTime;
    } else {
        _createTime = @"";
    }
    
    if(![FMUtils isStringEmpty:contact]) {
        _contact = contact;
    } else {
        _contact = @"";
    }
    if(![FMUtils isStringEmpty:telno]) {
        _telno = telno;
    } else {
        _telno = @"";
    }
    if(![FMUtils isStringEmpty:org]) {
        _org = org;
    } else {
        _org = @"";
    }
    if(![FMUtils isStringEmpty:serviceType]) {
        _serviceType = serviceType;
    } else {
        _serviceType = @"";
    }
    if(![FMUtils isStringEmpty:location]) {
        _location = location;
    } else {
        _location = @"";
    }
    if(![FMUtils isStringEmpty:estimateTime]) {
        _estimateTime = estimateTime;
    } else {
        _estimateTime = @"";
    }
    if(![FMUtils isStringEmpty:reserveTime]) {
        _reserveTime = reserveTime;
    } else {
        _reserveTime = @"";
    }
    if(![FMUtils isStringEmpty:desc]) {
        _desc = desc;
    } else {
        _desc = @"";
    }
    _priority = priority;
    _status = status;
    [self updateSubViews];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self updateSubViews];
}

- (void) updateInfo {
    [_createTimeLbl setContent:[self getCreateDesc]];
//    [_contactLbl setContent:_contact];
    [_orgLbl setContent:_org];
    [_serviceTypeLbl setContent:_serviceType];
    [_locationLbl setContent:_location];
    [_descLbl setContent:_desc];
    
    [_reserveTimeLbl setContent:_reserveTime];
    [_estimateTimeLbl setContent:_estimateTime];
    
    
    NSString * strStatus = [WorkOrderServerConfig getOrderStatusDesc:_status];
    UIColor * statusColor = [WorkOrderServerConfig getOrderStatusColor:_status];
    if(![FMUtils isStringEmpty:strStatus]) {
        [_statusLbl setContent:strStatus];
        [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:statusColor andBackgroundColor:statusColor];
        [_statusLbl setHidden:NO];
    } else {
        [_statusLbl setHidden:YES];
    }
    
    NSString * strPriority = [WorkOrderServerConfig getOrderPriorityLevelDesc:_priority];
    if(![FMUtils isStringEmpty:strPriority]) {
        [_priorityLbl setText:strPriority];
        [_priorityLbl setHidden:NO];
    } else {
        [_priorityLbl setHidden:YES];
    }
    
    if([FMUtils isStringEmpty:_telno]) {
        [_telnoBtn setHidden:YES];
    } else {
        [_telnoBtn setHidden:NO];
    }
}

//获取创建信息描述
- (NSString *) getCreateDesc {
    NSString * res = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"order_detail_create_desc" inTable:nil], _contact, _createTime];
    
    return res;
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _itemListener = listener;
}

- (void) onTelnoButtonClicked {
    if(_itemListener) {
        [_itemListener onItemClick:self subView:_telnoBtn];
    }
}

//依据位置信息和问题描述来计算所需要的高度
+ (CGFloat) calculateHeightByLocation:(NSString *) location
                              andDesc:(NSString *) desc
                                  org:(NSString *) org
                          serviceType:(NSString *) serviceType
                             andWidth:(CGFloat) width
                       andPaddingLeft:(CGFloat) paddingLeft
                      andPaddingRight:(CGFloat) paddingRight
                               expand:(BOOL) expand{
    CGFloat height = 0;
    CGFloat sepHeight = 9;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight + 5;
    CGFloat labelWidth = 0;
    CGFloat locationHeight = defaultItemHeight;
    CGFloat descHeight = defaultItemHeight;
    CGFloat telnoWidth = 30;
    CGFloat paddingTop = 13;
    CGFloat paddingBottom = paddingTop;
    UIFont * font = [FMFont fontWithSize:13];
    if(![FMUtils isStringEmpty:location]) {
        locationHeight = [BaseLabelView calculateHeightByInfo:location font:font desc:[[BaseBundle getInstance] getStringByKey:@"report_location" inTable:nil] labelFont:font andLabelWidth:labelWidth andWidth:(width-paddingRight-telnoWidth)];
        if(locationHeight < defaultItemHeight) {
            locationHeight = defaultItemHeight;
        }
    }
    if(![FMUtils isStringEmpty:desc]) {
        descHeight = [BaseLabelView calculateHeightByInfo:desc font:font desc:[[BaseBundle getInstance] getStringByKey:@"label_desc" inTable:nil] labelFont:font andLabelWidth:labelWidth andWidth:(width-paddingRight)];
        if(descHeight < defaultItemHeight) {
            descHeight = defaultItemHeight;
        }
    }
    height = defaultItemHeight * 2 + locationHeight + descHeight +  sepHeight * 3 + paddingTop + paddingBottom;
    if(expand) {
        CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
        CGFloat orgHeight = [BaseLabelView calculateHeightByInfo:org font:font desc:[[BaseBundle getInstance] getStringByKey:@"report_org" inTable:nil] labelFont:font andLabelWidth:labelWidth andWidth:width-paddingRight];
        if(orgHeight < defaultItemHeight) {
            orgHeight = defaultItemHeight;
        }
        CGFloat serviceTypeHeight = [BaseLabelView calculateHeightByInfo:serviceType font:font desc:[[BaseBundle getInstance] getStringByKey:@"report_service_type" inTable:nil] labelFont:font andLabelWidth:labelWidth andWidth:width-paddingRight];
        if(serviceTypeHeight < defaultItemHeight) {
            serviceTypeHeight = defaultItemHeight;
        }
        height += orgHeight + serviceTypeHeight + defaultItemHeight + sepHeight * 2 + seperatorHeight + paddingTop + paddingBottom;
    }
    return height;
}
@end

