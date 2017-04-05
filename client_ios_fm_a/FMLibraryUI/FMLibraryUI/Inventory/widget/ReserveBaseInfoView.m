//
//  ReserveBaseInfoView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ReserveBaseInfoView.h"
#import "BaseLabelView.h"
#import "BaseTextView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "SeperatorView.h"
#import "OnClickListener.h"

@interface ReserveBaseInfoView () <OnViewResizeListener, OnClickListener>

@property (readwrite, nonatomic, strong) BaseLabelView * personLbl; //预订人
@property (readwrite, nonatomic, strong) BaseLabelView * timeLbl;   //预定时间
@property (readwrite, nonatomic, strong) BaseTextView * noteLbl;    //

@property (readwrite, nonatomic, strong) SeperatorView * personSeperatorView;   //分割线
@property (readwrite, nonatomic, strong) SeperatorView * timeSeperatorView;     //

@property (readwrite, nonatomic, strong) NSString * person;
@property (readwrite, nonatomic, strong) NSNumber * time;
@property (readwrite, nonatomic, strong) NSString * note;

@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat minNoteHeight;
@property (readwrite, nonatomic, assign) CGFloat labelWidth;
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, assign) ReserveBaseInfoViewType viewType;

@property (readwrite, nonatomic, assign) BOOL editable;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end

@implementation ReserveBaseInfoView

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
        _labelWidth = 80;
        _minNoteHeight = 140;
        _defaultItemHeight = 40;
        _padding = [FMSize getInstance].defaultPadding;
        _seperatorHeight = [FMSize getInstance].seperatorHeight;
        _viewType = RESERVE_BASE_INFO_VIEW_TYPE_RESERVE;
        
        _personLbl = [[BaseLabelView alloc] init];
        _timeLbl = [[BaseLabelView alloc] init];
        _noteLbl = [[BaseTextView alloc] init];
        
        _timeLbl.tag = RESERVE_BASE_INFO_TYPE_TIME;
        [_timeLbl setOnClickListener:self];
        
        _personSeperatorView = [[SeperatorView alloc] init];
        _timeSeperatorView = [[SeperatorView alloc] init];
        
        
        [_noteLbl setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]];
        
        [_noteLbl setMinHeight:_minNoteHeight];
        [_noteLbl setOnViewResizeListener:self];
        
        [self updateViewDesc];
        
        [self addSubview:_personLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_noteLbl];
        [self addSubview:_personSeperatorView];
        [self addSubview:_timeSeperatorView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat originY = 0;
    CGFloat itemHeight = 0;
    
    itemHeight = _defaultItemHeight;
    [_personLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    [_personSeperatorView setFrame:CGRectMake(_padding, (originY + itemHeight-_seperatorHeight), width-_padding*2, _seperatorHeight)];
    originY += itemHeight;
    
    itemHeight = _defaultItemHeight;
    [_timeLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    [_timeSeperatorView setFrame:CGRectMake(_padding, (originY + itemHeight-_seperatorHeight), width-_padding*2, _seperatorHeight)];
    originY += itemHeight;
    
    itemHeight = CGRectGetHeight(_noteLbl.frame);
    if(itemHeight < _minNoteHeight) {
        itemHeight = _minNoteHeight;
    }
    [_noteLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
}

//更新标签提示信息
- (void) updateViewDesc {
    switch(_viewType) {
        case RESERVE_BASE_INFO_VIEW_TYPE_RESERVE:
            [_personLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_person" inTable:nil] andLabelWidth:_labelWidth];
            [_timeLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_time" inTable:nil] andLabelWidth:_labelWidth];
            [_noteLbl setTopDesc:[[BaseBundle getInstance] getStringByKey:@"label_note" inTable:nil]];
            break;
        case RESERVE_BASE_INFO_VIEW_TYPE_DELIVERY:
            [_personLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_receive_person_colon" inTable:nil] andLabelWidth:_labelWidth];
            [_timeLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_receive_time" inTable:nil] andLabelWidth:_labelWidth];
            [_noteLbl setTopDesc:[[BaseBundle getInstance] getStringByKey:@"label_note" inTable:nil]];
            break;
    }
}

- (void) updateInfo {
    [_personLbl setContent:_person];
    NSString * strTime = [FMUtils getDayStr:[FMUtils timeLongToDate:_time]];
    [_timeLbl setContent:strTime];
    [_noteLbl setContentWith:_note];
    
    [self updateViewDesc];
}

- (void) setShowBound:(BOOL) showBound {
    if(showBound) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    } else {
        self.layer.borderWidth = 0;
    }
}

- (void) setViewType:(ReserveBaseInfoViewType) type {
    _viewType = type;
    [self updateViewDesc];
}

- (void) setInfoWith:(NSString *) userName
                time:(NSNumber *) time
                note:(NSString *) note {
    
    _person = userName;
    _time = time;
    _note = note;
    [self updateInfo];
}

- (void) setUserName:(NSString *) userName {
    _person = userName;
    [_personLbl setContent:_person];
}

- (void) setTime:(NSNumber *) time {
    if(time) {
        _time = time;
    } else {
        _time = nil;
    }
    
    NSString * strTime = @"";
    if(_time) {
        strTime = [FMUtils getDayStr:[FMUtils timeLongToDate:_time]];
    }
    [_timeLbl setContent:strTime];
}

- (void) setEditable:(BOOL) editable {
    _editable = editable;
    [_noteLbl setEditAble:_editable];
}

- (NSString *) getNote {
    _note = [_noteLbl getContent];
    return _note;
}

- (void) notifySelectTime {
    if(_listener) {
        [_listener onItemClick:self subView:_timeLbl];
    }
}


- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _noteLbl) {
        CGRect frame = view.frame;
        frame.size = newSize;
        _noteLbl.frame = frame;
        
        CGRect mainFrame = self.frame;
        CGFloat mainHeight = _defaultItemHeight * 2 + newSize.height;
        CGSize mainSize = CGSizeMake(CGRectGetWidth(mainFrame), mainHeight);
                                     
        [self notifyViewNeedResized:mainSize];
    }
}

- (void) onClick:(UIView *)view {
    if(view == _timeLbl) {
        [self notifySelectTime];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _listener = listener;
}

@end
