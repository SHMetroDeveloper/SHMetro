//
//  ReportBaseInfoView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ReportBaseInfoView.h"
#import "MarkEditView.h"
#import "SeperatorView.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"
#import "ReportServerConfig.h"

@interface ReportBaseInfoView ()

@property (readwrite, nonatomic, strong) MarkEditView * reporterView;   //申请人
@property (readwrite, nonatomic, strong) MarkEditView * phoneView;      //联系电话
@property (readwrite, nonatomic, strong) MarkEditView * orgView;        //部门
@property (readwrite, nonatomic, strong) MarkEditView * serviceTypeView;//服务类型
@property (readwrite, nonatomic, strong) MarkEditView * orderTypeView;  //工单类型
@property (readwrite, nonatomic, strong) MarkEditView * locationView;   //位置
@property (readwrite, nonatomic, strong) MarkEditView * priorityView;   //优先级

@property (readwrite, nonatomic, strong) SeperatorView * reporterSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * phoneSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * orgSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * serviceTypeSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * orderTypeSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * locationSeperatorView;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * phone;
@property (readwrite, nonatomic, strong) NSString * org;
@property (readwrite, nonatomic, strong) NSString * serviceType;
@property (readwrite, nonatomic, assign) NSInteger orderType;
@property (readwrite, nonatomic, strong) NSString * location;
@property (readwrite, nonatomic, strong) NSString * priority;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultSeperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;


@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) BOOL showBound;
@property (readwrite, nonatomic, assign) BOOL editable;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> itemClickListener;
@end


@implementation ReportBaseInfoView

- (instancetype) init {
    self = [super init];
    if(self) {
        
        
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
        
        _defaultItemHeight = 50;
//        _defaultSeperatorHeight = [FMSize getInstance].seperatorHeight;
        _defaultSeperatorHeight = 10;
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        _labelWidth = 100;
        
        _showBound = YES;
        _editable = YES;
        
        CGFloat originY = 5;
        
        _reporterView = [[MarkEditView alloc] init];
        _reporterSeperatorView = [[SeperatorView alloc] init];
        [_reporterView setShowMark:YES];
        [_reporterView setEditAble:NO];
        originY += _defaultItemHeight;
        
        _phoneView = [[MarkEditView alloc] init];
        _phoneSeperatorView = [[SeperatorView alloc] init];
        originY += _defaultItemHeight;
        
        _orgView = [[MarkEditView alloc] init];
        _orgView.tag = REPORT_BASE_INFO_ITEM_TYPE_ORG;
        _orgSeperatorView = [[SeperatorView alloc] init];
        originY += _defaultItemHeight;
        
        _locationView = [[MarkEditView alloc] init];
        _locationView.tag = REPORT_BASE_INFO_ITEM_TYPE_LOCATION;
        _locationSeperatorView = [[SeperatorView alloc] init];
        originY += _defaultItemHeight;
        
        _serviceTypeView = [[MarkEditView alloc] init];
        _serviceTypeView.tag = REPORT_BASE_INFO_ITEM_TYPE_SERVICE_TYPE;
        [_serviceTypeView setShowMark:YES];
        _serviceTypeSeperatorView = [[SeperatorView alloc] init];
        originY += _defaultItemHeight;
        
        _orderTypeView = [[MarkEditView alloc] init];
        _orderTypeView.tag = REPORT_BASE_INFO_ITEM_TYPE_ORDER_TYPE;
        [_orderTypeView setShowMark:YES];
        _orderTypeSeperatorView = [[SeperatorView alloc] init];
        originY += _defaultItemHeight;
        
        
        _priorityView = [[MarkEditView alloc] init];
        _priorityView.tag = REPORT_BASE_INFO_ITEM_TYPE_PRIORITY;
        [_priorityView setShowMark:YES];
        originY += _defaultItemHeight;
        
        [_reporterView setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"report_reporter" inTable:nil] andWidth:_labelWidth];
        [_phoneView setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"report_telno" inTable:nil] andWidth:_labelWidth];
        [_orgView setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"report_org" inTable:nil] andWidth:_labelWidth];
        [_locationView setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"report_location" inTable:nil] andWidth:_labelWidth];
        [_serviceTypeView setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"report_service_type" inTable:nil] andWidth:_labelWidth];
        [_orderTypeView setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"report_order_type" inTable:nil] andWidth:_labelWidth];
        [_priorityView setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"report_priority" inTable:nil] andWidth:_labelWidth];
        
        
        [_orgView setEditAble:NO];
        [_locationView setEditAble:NO];
        [_serviceTypeView setEditAble:NO];
        [_orderTypeView setEditAble:NO];
        [_priorityView setEditAble:NO];
        
        [_orgView setOnClickedListener:self];
        [_locationView setOnClickedListener:self];
        [_serviceTypeView setOnClickedListener:self];
        [_orderTypeView setOnClickedListener:self];
        [_priorityView setOnClickedListener:self];
        
        [self addSubview:_reporterView];
        [self addSubview:_reporterSeperatorView];
        [self addSubview:_phoneView];
        [self addSubview:_phoneSeperatorView];
        [self addSubview:_orgView];
        [self addSubview:_orgSeperatorView];
        [self addSubview:_locationView];
        [self addSubview:_locationSeperatorView];
        [self addSubview:_serviceTypeView];
        [self addSubview:_serviceTypeSeperatorView];
        [self addSubview:_orderTypeView];
        [self addSubview:_orderTypeSeperatorView];
        [self addSubview:_priorityView];
        
        [self updateViews];
        
    }
}

- (void) updateViews {
    
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat itemHeight = 0;
    CGFloat sepHeight = 0;
    CGFloat originY = sepHeight;
    
    
    itemHeight = _defaultItemHeight;
    [_reporterView setFrame:CGRectMake(0, originY, width, itemHeight)];
    [_reporterSeperatorView setFrame:CGRectMake(_paddingLeft, originY + itemHeight - _defaultSeperatorHeight, width-_paddingLeft-_paddingRight, _defaultSeperatorHeight)];
    originY += itemHeight;
    
    itemHeight = _defaultItemHeight;
    [_phoneView setFrame:CGRectMake(0, originY, width, itemHeight)];
    [_phoneSeperatorView setFrame:CGRectMake(_paddingLeft, originY + itemHeight - _defaultSeperatorHeight, width-_paddingLeft-_paddingRight, _defaultSeperatorHeight)];
    originY += itemHeight;
    
    itemHeight = _defaultItemHeight;
    [_orgView setFrame:CGRectMake(0, originY, width, itemHeight)];
    [_orgSeperatorView setFrame:CGRectMake(_paddingLeft, originY + itemHeight - _defaultSeperatorHeight, width-_paddingLeft-_paddingRight, _defaultSeperatorHeight)];
    originY += itemHeight;
    
    itemHeight = _defaultItemHeight;
    [_locationView setFrame:CGRectMake(0, originY, width, itemHeight)];
    [_locationSeperatorView setFrame:CGRectMake(_paddingLeft, originY + itemHeight - _defaultSeperatorHeight, width-_paddingLeft-_paddingRight, _defaultSeperatorHeight)];
    originY += itemHeight;
    
    itemHeight = _defaultItemHeight;
    [_serviceTypeView setFrame:CGRectMake(0, originY, width, itemHeight)];
    [_serviceTypeSeperatorView setFrame:CGRectMake(_paddingLeft, originY + itemHeight - _defaultSeperatorHeight, width-_paddingLeft-_paddingRight, _defaultSeperatorHeight)];
    originY += itemHeight;
    
    itemHeight = _defaultItemHeight;
    [_orderTypeView setFrame:CGRectMake(0, originY, width, itemHeight)];
    [_orderTypeSeperatorView setFrame:CGRectMake(_paddingLeft, originY + itemHeight - _defaultSeperatorHeight, width-_paddingLeft-_paddingRight, _defaultSeperatorHeight)];
    originY += itemHeight;
    
    itemHeight = _defaultItemHeight;
    [_priorityView setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;
    
    if(_showBound) {
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
    } else {
        self.layer.borderWidth = 0;
        self.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    
    [self updateInfo];
}

- (void) updateInfo {
    [_reporterView setContent:_name];
    [_phoneView setContent:_phone];
    [_orgView setContent:_org];
    [_locationView setContent:_location];
    [_serviceTypeView setContent:_serviceType];
    [_orderTypeView setContent:[ReportServerConfig getReportOrderTypeString:_orderType]];
    [_priorityView setContent:_priority];
}

- (void) setInfoWithName:(NSString *) userName
                andPhone:(NSString *) phone
                  andOrg:(NSString *) orgName
          andServiceType:(NSString *) serviceType
             andLocation:(NSString *) location
             andPriority:(NSString *) priority
            andOrderType:(NSInteger) orderType {
    _name = [userName copy];
    _phone = [phone copy];
    _org = [orgName copy];
    _serviceType = [serviceType copy];
    _location = [location copy];
    _priority = [priority copy];
    _orderType = orderType;
    
    [self updateViews];
}

- (void) setUserName:(NSString *) name {
    _name = [name copy];
    [self updateViews];
}

- (void) setPhone:(NSString *) phone {
    _phone = [phone copy];
    [self updateViews];
}

- (NSString *) getPhone {
    return [_phoneView getContent];
}

- (void) setOrg:(NSString *) org {
    _org = [org copy];
    [self updateViews];
}

- (NSString *) getOrg {
    return _org;
}

- (void) setServiceType:(NSString *) stype {
    _serviceType = [stype copy];
    [self updateViews];
}

- (NSString *) getServiceType {
    return _serviceType;
}

- (void) setLocation:(NSString *) location {
    _location = [location copy];
    [self updateViews];
}

- (NSString *) getLocation {
    return _location;
}

- (void) setPriority:(NSString *) priority {
    _priority = [priority copy];
    [self updateViews];
}

- (NSString *) getPriorityName {
    return _priority;
}

- (void) setOrderType:(NSInteger) orderType {
    _orderType = orderType;
    [self updateViews];
}

- (NSInteger) getOrderType {
    return _orderType;
}

- (void) onClick:(UIView *)view {
    if(view == _orgView) {
        [self onOrgItemClicked];
    } else if(view == _serviceTypeView) {
        [self onServiceTypeItemClicked];
    } else if(view == _orderTypeView) {
        [self onOrderTypeItemClicked];
    } else if (view == _locationView) {
        [self onLocationItemClicked];
    } else if(view == _priorityView) {
        [self onPriorityItemClicked];
    }
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
}

- (void) onOrgItemClicked {
    if(_editable && _itemClickListener) {
        [_itemClickListener onItemClick:self subView:_orgView];
    }
}

- (void) onServiceTypeItemClicked {
    if(_editable && _itemClickListener) {
        [_itemClickListener onItemClick:self subView:_serviceTypeView];
    }
}

- (void) onOrderTypeItemClicked {
    if(_editable && _itemClickListener) {
        [_itemClickListener onItemClick:self subView:_orderTypeView];
    }
}

- (void) onLocationItemClicked {
    if(_editable && _itemClickListener) {
        [_itemClickListener onItemClick:self subView:_locationView];
    }
}

- (void) onPriorityItemClicked {
    if(_editable && _itemClickListener) {
        [_itemClickListener onItemClick:self subView:_priorityView];
    }
}

- (void) setOnItemLickListener:(id<OnItemClickListener>) listener {
    _itemClickListener = listener;
}

+ (CGFloat) calculateHeightByLocation:(NSString*) location andWidth:(CGFloat) width {
    CGFloat height = 0;
    
    
    
    return height;
}

@end
