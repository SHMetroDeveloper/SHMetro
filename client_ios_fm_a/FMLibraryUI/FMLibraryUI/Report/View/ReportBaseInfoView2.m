//
//  ReportBaseInfoView2.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "ReportBaseInfoView2.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "MarkEditView2.h"
#import "SeperatorView.h"
#import "ReportServerConfig.h"

@interface ReportBaseInfoView2()

@property (readwrite, nonatomic, strong) MarkEditView2 * reporterView;   //申请人
@property (readwrite, nonatomic, strong) MarkEditView2 * phoneView;      //联系电话
@property (readwrite, nonatomic, strong) MarkEditView2 * orgView;        //部门
@property (readwrite, nonatomic, strong) MarkEditView2 * locationView;   //位置
@property (readwrite, nonatomic, strong) MarkEditView2 * serviceTypeView;//服务类型
@property (readwrite, nonatomic, strong) MarkEditView2 * orderTypeView;  //工单类型
@property (readwrite, nonatomic, strong) MarkEditView2 * priorityView;   //优先级

@property (readwrite, nonatomic, strong) SeperatorView * reporterSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * phoneSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * orgSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * serviceTypeSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * orderTypeSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * locationSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * prioritySeperatorView;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * phone;
@property (readwrite, nonatomic, strong) NSString * org;
@property (readwrite, nonatomic, strong) NSString * serviceType;
@property (readwrite, nonatomic, assign) NSInteger orderType;
@property (readwrite, nonatomic, strong) NSString * location;
@property (readwrite, nonatomic, strong) NSString * priority;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) BOOL isFirstSet;
@property (readwrite, nonatomic, weak) id<OnItemClickListener> itemClickListener;

@end

@implementation ReportBaseInfoView2

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
    if (!_isInited) {
        _isInited = YES;
    
        _reporterView = [[MarkEditView2 alloc] init];
        
        _phoneView = [[MarkEditView2 alloc] init];
        _orgView = [[MarkEditView2 alloc] init];
        _locationView = [[MarkEditView2 alloc] init];
        _serviceTypeView = [[MarkEditView2 alloc] init];
        _orderTypeView = [[MarkEditView2 alloc] init];
        _priorityView = [[MarkEditView2 alloc] init];
        
        
        [_reporterView setEditable:NO showMore:NO isMarked:YES];
        [_phoneView setEditable:YES showMore:NO isMarked:YES];
        [_orgView setEditable:NO showMore:YES isMarked:NO];
        [_locationView setEditable:NO showMore:YES isMarked:YES];
        [_serviceTypeView setEditable:NO showMore:YES isMarked:YES];
        [_orderTypeView setEditable:NO showMore:YES isMarked:YES];
        [_priorityView setEditable:NO showMore:YES isMarked:YES];
        
        _orgView.tag = REPORT_BASE_ITEM_TYPE_ORG;
        _locationView.tag = REPORT_BASE_ITEM_TYPE_LOCATION;
        _serviceTypeView.tag = REPORT_BASE_ITEM_TYPE_SERVICE_TYPE;
        _orderTypeView.tag =  REPORT_BASE_ITEM_TYPE_ORDER_TYPE;
        _priorityView.tag = REPORT_BASE_ITEM_TYPE_PRIORITY;
        
        [_orgView setOnClickListener:self];
        [_locationView setOnClickListener:self];
        [_serviceTypeView setOnClickListener:self];
        [_orderTypeView setOnClickListener:self];
        [_priorityView setOnClickListener:self];
        
        _reporterSeperatorView = [[SeperatorView alloc] init];
        _phoneSeperatorView = [[SeperatorView alloc] init];
        _orgSeperatorView = [[SeperatorView alloc] init];
        _serviceTypeSeperatorView = [[SeperatorView alloc] init];
        _orderTypeSeperatorView = [[SeperatorView alloc] init];
        _locationSeperatorView = [[SeperatorView alloc] init];
        _prioritySeperatorView = [[SeperatorView alloc] init];
        
        [_reporterSeperatorView setDotted:YES];
        [_phoneSeperatorView setDotted:YES];
        [_orgSeperatorView setDotted:YES];
        [_serviceTypeSeperatorView setDotted:YES];
        [_orderTypeSeperatorView setDotted:YES];
        [_locationSeperatorView setDotted:YES];
        [_prioritySeperatorView setDotted:YES];
        
        
        [self addSubview:_reporterView];
        [self addSubview:_phoneView];
        [self addSubview:_orgView];
        [self addSubview:_serviceTypeView];
        [self addSubview:_orderTypeView];
        [self addSubview:_locationView];
        [self addSubview:_priorityView];
        
        [self addSubview:_reporterSeperatorView];
        [self addSubview:_phoneSeperatorView];
        [self addSubview:_orgSeperatorView];
        [self addSubview:_serviceTypeSeperatorView];
        [self addSubview:_orderTypeSeperatorView];
        [self addSubview:_locationSeperatorView];
        [self addSubview:_prioritySeperatorView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if (width == 0 || height == 0) {
        return;
    }
    
    CGFloat itemHeight = 48;
    CGFloat padding = [FMSize getInstance].padding50;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat sepHeight = 0;
    
    [_reporterView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    [_reporterSeperatorView setFrame:CGRectMake(originX+padding, originY + itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
    originY += itemHeight + sepHeight;
    
    [_phoneView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    [_phoneSeperatorView setFrame:CGRectMake(originX+padding, originY+itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
    originY += itemHeight + sepHeight;
    
    [_orgView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    [_orgSeperatorView setFrame:CGRectMake(originX+padding, originY+itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
    originY += itemHeight + sepHeight;
    
    [_locationView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    [_locationSeperatorView setFrame:CGRectMake(originX+padding, originY+itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
    originY += itemHeight + sepHeight;
    
    [_orderTypeView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    [_orderTypeSeperatorView setFrame:CGRectMake(originX+padding, originY+itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
    originY += itemHeight + sepHeight;
    
    [_serviceTypeView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    [_serviceTypeSeperatorView setFrame:CGRectMake(originX+padding, originY+itemHeight, width-padding*2, seperatorHeight)];
    originY += itemHeight + sepHeight;
    
    
    
    [_priorityView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    [_prioritySeperatorView setFrame:CGRectMake(originX, originY+itemHeight, width, seperatorHeight)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (void) updateInfo {
    
    NSString * phone = [_phoneView getContent];
    if(![FMUtils isStringEmpty:phone] && ![phone isEqualToString:_phone]){
        _phone = phone;
    }
    [_reporterView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_reporter" inTable:nil] andDescription:_name];
    [_phoneView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_telno" inTable:nil] andDescription:_phone];
    [_orgView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_org" inTable:nil] andDescription:_org];
    [_locationView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_location" inTable:nil] andDescription:_location];
    [_serviceTypeView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_service_type" inTable:nil] andDescription:_serviceType];
    [_orderTypeView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_order_type" inTable:nil] andDescription:[ReportServerConfig getReportOrderTypeString:_orderType]];
    [_priorityView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_priority" inTable:nil] andDescription:_priority];
}

#pragma mark - Setter赋值方法
- (void) setUserName:(NSString *) name{
    _name = [name copy];
    [self updateViews];
}

- (void) setPhone:(NSString *) phone{
    _phone = [phone copy];
    [self updateViews];
}

- (void)setOrg:(NSString *)org {
    _org = [org copy];
    [self updateViews];
}

- (void)setLocation:(NSString *)location {
    _location = [location copy];
    [self updateViews];
}

- (void)setServiceType:(NSString *)stype {
    _serviceType = [stype copy];
    [self updateViews];
}

- (void)setOrderType:(NSInteger)orderType {
    _orderType = orderType;
    [self updateViews];
}

- (void)setPriority:(NSString *)priority {
    _priority = [priority copy];
    [self updateViews];
}

#pragma mark - Getter取值方法
- (NSString *) getPhone {
    NSString * phone = [_phoneView getContent];
    return phone;
}

- (NSString *) getName {
    NSString * name = _name;
    return name;
}

- (NSString *) getOrg {
    return _org;
}

- (NSString *) getServiceType {
    return _serviceType;
}

- (NSString *) getLocation {
    return _location;
}

- (NSString *) getPriority {
    return _priority;
}

- (NSInteger) getOrderType {
    return _orderType;
}

#pragma mark - OnClickListener Delegate
- (void)onClick:(UIView *)view {
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

#pragma mark - OnItemClickListener Delegate
- (void) setOnItemLickListener:(id<OnItemClickListener>) listener {
    _itemClickListener = listener;
}

- (void) onOrgItemClicked {
    if(_itemClickListener) {
        NSLog(@"点击了Org");
        [_itemClickListener onItemClick:self subView:_orgView];
    }
}

- (void) onServiceTypeItemClicked {
    if(_itemClickListener) {
        NSLog(@"点击了service");
        [_itemClickListener onItemClick:self subView:_serviceTypeView];
    }
}

- (void) onOrderTypeItemClicked {
    if(_itemClickListener) {
        NSLog(@"点击了order");
        [_itemClickListener onItemClick:self subView:_orderTypeView];
    }
}

- (void) onLocationItemClicked {
    if(_itemClickListener) {
        NSLog(@"点击了location");
        [_itemClickListener onItemClick:self subView:_locationView];
    }
}

- (void) onPriorityItemClicked {
    if(_itemClickListener) {
        NSLog(@"点击了priority");
        [_itemClickListener onItemClick:self subView:_priorityView];
    }
}

+ (CGFloat) calculateHeightByItemCount:(NSInteger)count {
    CGFloat height = 0;
    CGFloat itemHeight = 48;
    height = count*itemHeight;
    return height;
}

@end





