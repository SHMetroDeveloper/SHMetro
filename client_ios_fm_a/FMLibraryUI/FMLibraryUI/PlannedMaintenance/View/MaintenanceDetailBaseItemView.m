//
//  MaintenanceDetailBaseItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceDetailBaseItemView.h"
#import "BaseLabelView.h"
#import "BaseBundle.h"

@interface MaintenanceDetailBaseItemView ()
@property (readwrite, nonatomic, strong) BaseLabelView * nameLbl;       //名称
@property (readwrite, nonatomic, strong) BaseLabelView * influenceLbl;  //影响
@property (readwrite, nonatomic, strong) BaseLabelView * periodLbl;     //周期
@property (readwrite, nonatomic, strong) BaseLabelView * firstTimeLbl;  //首次维保时间
@property (readwrite, nonatomic, strong) BaseLabelView * nextTimeLbl;   //下次维保时间
@property (readwrite, nonatomic, strong) BaseLabelView * workTimeLbl;   //耗时
@property (readwrite, nonatomic, strong) BaseLabelView * genStatusLbl;  //自动生成工单状态
@property (readwrite, nonatomic, strong) BaseLabelView * aheadLbl;      //提前时间

@property (readwrite, nonatomic, strong) MaintenanceDetailBaseModel * model;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation MaintenanceDetailBaseItemView

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
        
        _paddingLeft = 15;
        _paddingTop = 18;
        
        
        _nameLbl = [[BaseLabelView alloc] init];
        _influenceLbl = [[BaseLabelView alloc] init];
        _periodLbl = [[BaseLabelView alloc] init];
        _firstTimeLbl = [[BaseLabelView alloc] init];
        _nextTimeLbl = [[BaseLabelView alloc] init];
        _workTimeLbl = [[BaseLabelView alloc] init];
        _genStatusLbl = [[BaseLabelView alloc] init];
        _aheadLbl = [[BaseLabelView alloc] init];
        
        CGFloat labelWidth = 0;
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"maintenance_location" inTable:nil] andLabelWidth:labelWidth];
        [_influenceLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"maintenance_effect" inTable:nil] andLabelWidth:labelWidth];
        [_periodLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"maintenance_cycle" inTable:nil] andLabelWidth:labelWidth];
        [_firstTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"maintenance_first_time" inTable:nil] andLabelWidth:labelWidth];
        [_nextTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"maintenance_next_time" inTable:nil] andLabelWidth:labelWidth];
        [_workTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"maintenance_used_time" inTable:nil] andLabelWidth:labelWidth];
        [_genStatusLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"maintenance_auto_order" inTable:nil] andLabelWidth:labelWidth];
        [_aheadLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"maintenance_day_shift" inTable:nil] andLabelWidth:labelWidth];
        
        
        [self addSubview:_nameLbl];
        [self addSubview:_influenceLbl];
        [self addSubview:_periodLbl];
        [self addSubview:_firstTimeLbl];
        [self addSubview:_nextTimeLbl];
        [self addSubview:_workTimeLbl];
        [self addSubview:_genStatusLbl];
        [self addSubview:_aheadLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat defaultItemHeight = 16;
    NSInteger influenceHeight = [BaseLabelView calculateHeightByInfo:_model.influence font:nil desc:[[BaseBundle getInstance] getStringByKey:@"maintenance_effect" inTable:nil] labelFont:nil andLabelWidth:0 andWidth:width-_paddingLeft];
    if(influenceHeight < defaultItemHeight) {
        influenceHeight = defaultItemHeight;
    }
    CGFloat sepHeight = (height - influenceHeight - defaultItemHeight * 7 - _paddingTop * 2) / 7;
    
    CGFloat originY = _paddingTop;
    CGFloat itemHeight = defaultItemHeight;
    [_nameLbl setFrame:CGRectMake(0, originY, width-_paddingLeft, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = influenceHeight;
    [_influenceLbl setFrame:CGRectMake(0, originY, width-_paddingLeft, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_periodLbl setFrame:CGRectMake(0, originY, width-_paddingLeft, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_firstTimeLbl setFrame:CGRectMake(0, originY, width-_paddingLeft, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_nextTimeLbl setFrame:CGRectMake(0, originY, width-_paddingLeft, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_workTimeLbl setFrame:CGRectMake(0, originY, width-_paddingLeft, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_genStatusLbl setFrame:CGRectMake(0, originY, width-_paddingLeft, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_aheadLbl setFrame:CGRectMake(0, originY, width-_paddingLeft, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (void) updateInfo {
    [_nameLbl setContent:_model.name];
    [_influenceLbl setContent:_model.influence];
    [_periodLbl setContent:_model.period];
    [_firstTimeLbl setContent:_model.dateFirstTodoDesc];
    [_nextTimeLbl setContent:_model.dateNextTodoDesc];
    [_workTimeLbl setContent:_model.estimatedWorkingTime];
    [_genStatusLbl setContent:_model.genStatusDesc];
    [_aheadLbl setContent:_model.aheadDesc];
}

- (void) setInfoWith:(MaintenanceDetailBaseModel *) model {
    _model = model;
    [self updateViews];
}

+ (CGFloat) calculateHeightByModel:(MaintenanceDetailBaseModel *) model width:(CGFloat) width{
    CGFloat height = 0;
    CGFloat paddingTop = 18;
    CGFloat paddingRight = 15;//右边距
    CGFloat defaultItemHeight = 16;
    CGFloat sepHeight = 14;
    NSInteger influenceHeight = [BaseLabelView calculateHeightByInfo:model.influence font:nil desc:[[BaseBundle getInstance] getStringByKey:@"maintenance_effect" inTable:nil] labelFont:nil andLabelWidth:0 andWidth:width-paddingRight];
    if(influenceHeight < defaultItemHeight) {
        influenceHeight = defaultItemHeight;
    }
    height = influenceHeight + defaultItemHeight * 7 + paddingTop * 2 + sepHeight * 7;
    
    return height;
}

@end
