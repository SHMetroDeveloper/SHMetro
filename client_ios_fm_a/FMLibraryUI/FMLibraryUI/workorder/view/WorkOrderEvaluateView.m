//
//  WorkOrderEvaluateView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/18.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "WorkOrderEvaluateView.h"
#import "BaseLabelView.h"
#import "BaseTextView.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "UIButton+Bootstrap.h"
#import "HCSStarRatingView.h"

typedef NS_ENUM(NSInteger, starRatingType) {
    STAR_RATING_TIMELINESS,  //时效性
    STAR_RATING_SERVICE,     //服务质量
    STAR_RATING_WORK,        //工作质量
};

@interface WorkOrderEvaluateView () <OnViewResizeListener>

@property (readwrite, nonatomic, strong) BaseLabelView * titleLbl;

@property (readwrite, nonatomic, strong) UIScrollView * contentContainerView;

@property (readwrite, nonatomic, strong) UILabel * timelinessLbl;   //及时性
@property (readwrite, nonatomic, strong) HCSStarRatingView * timelinessStarRating;
@property (readwrite, nonatomic, strong) UILabel * timelinessScoreLbl;

@property (readwrite, nonatomic, strong) UILabel * serviceLbl;      //服务质量
@property (readwrite, nonatomic, strong) HCSStarRatingView * serviceStarRating;
@property (readwrite, nonatomic, strong) UILabel * serviceScoreLbl;

@property (readwrite, nonatomic, strong) UILabel * workLbl;         //工作质量
@property (readwrite, nonatomic, strong) HCSStarRatingView * workStarRating;
@property (readwrite, nonatomic, strong) UILabel * workScoreLbl;

@property (readwrite, nonatomic, strong) BaseTextView * commentView; //评论

@property (readwrite, nonatomic, strong) UIView * controlContainerView;
@property (readwrite, nonatomic, strong) UIButton * okBtn;
@property (readwrite, nonatomic, strong) UIButton * cancelBtn;

@property (readwrite, nonatomic, assign) CGFloat timelinessScore;
@property (readwrite, nonatomic, assign) CGFloat serviceScore;
@property (readwrite, nonatomic, assign) CGFloat workScore;

@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat labelWidth;
@property (readwrite, nonatomic, assign) CGFloat scoreWidth;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, assign) CGFloat scoreMax;  //评分最大值

@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultInputHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;
@end

@implementation WorkOrderEvaluateView

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
        
        UIFont * msgFont = [FMFont getInstance].defaultFontLevel2;
        UIColor * starColor = [UIColor colorWithRed:253/255.0 green:148/255.0 blue:38/255.0 alpha:1.0];
        _padding = [FMSize getInstance].defaultPadding;
        _labelWidth = 80;
        _btnWidth = 70;
        _btnHeight = 30;
        _scoreWidth = 40;
        _titleHeight = 40;
        _controlHeight = 40;
        _defaultInputHeight = 120;
        _scoreMax = 15;
        _timelinessScore = 2.5;
        _serviceScore = 2.5;
        _workScore = 2.5;
        
        //及时性
        _timelinessLbl = [[UILabel alloc] init];
        [_timelinessLbl setFont:msgFont];
        [_timelinessLbl setText:[[BaseBundle getInstance] getStringByKey:@"order_evaluate_timeliness" inTable:nil]];
        
        _timelinessScoreLbl = [[UILabel alloc] init];
        [_timelinessScoreLbl setFont:msgFont];
        _timelinessScoreLbl.textAlignment = NSTextAlignmentCenter;
        [_timelinessScoreLbl setText:[[NSString alloc] initWithFormat:@"%.1f", _timelinessScore]];
        
        _timelinessStarRating = [[HCSStarRatingView alloc] init];
        _timelinessStarRating.maximumValue = 5;
        _timelinessStarRating.minimumValue = 0;
        _timelinessStarRating.value = 2.5;
        _timelinessStarRating.tintColor = starColor;
        _timelinessStarRating.allowsHalfStars = YES;
        _timelinessStarRating.tag = STAR_RATING_TIMELINESS;
        _timelinessStarRating.emptyStarImage = [[[FMTheme getInstance] getImageByName:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _timelinessStarRating.filledStarImage = [[[FMTheme getInstance] getImageByName:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_timelinessStarRating addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
        
        //服务质量
        _serviceLbl = [[UILabel alloc] init];
        [_serviceLbl setFont:msgFont];
        [_serviceLbl setText:[[BaseBundle getInstance] getStringByKey:@"order_evaluate_service" inTable:nil]];
        
        _serviceScoreLbl = [[UILabel alloc] init];
        [_serviceScoreLbl setFont:msgFont];
        _serviceScoreLbl.textAlignment = NSTextAlignmentCenter;
        [_serviceScoreLbl setText:[[NSString alloc] initWithFormat:@"%.1f", _serviceScore]];
        
        _serviceStarRating = [[HCSStarRatingView alloc] init];
        _serviceStarRating.maximumValue = 5;
        _serviceStarRating.minimumValue = 0;
        _serviceStarRating.value = 2.5;
        _serviceStarRating.tintColor = starColor;
        _serviceStarRating.allowsHalfStars = YES;
        _serviceStarRating.tag = STAR_RATING_SERVICE;
        _serviceStarRating.emptyStarImage = [[[FMTheme getInstance] getImageByName:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _serviceStarRating.filledStarImage = [[[FMTheme getInstance] getImageByName:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_serviceStarRating addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
        
        //工作质量
        _workLbl = [[UILabel alloc] init];
        [_workLbl setFont:msgFont];
        [_workLbl setText:[[BaseBundle getInstance] getStringByKey:@"order_evaluate_work" inTable:nil]];
        
        _workScoreLbl = [[UILabel alloc] init];
        [_workScoreLbl setFont:msgFont];
        _workScoreLbl.textAlignment = NSTextAlignmentCenter;
        [_workScoreLbl setText:[[NSString alloc] initWithFormat:@"%.1f", _workScore]];
        
        _workStarRating = [[HCSStarRatingView alloc] init];
        _workStarRating.maximumValue = 5;
        _workStarRating.minimumValue = 0;
        _workStarRating.value = 2.5;
        _workStarRating.tintColor = starColor;
        _workStarRating.allowsHalfStars = YES;
        _workStarRating.tag = STAR_RATING_WORK;
        _workStarRating.emptyStarImage = [[[FMTheme getInstance] getImageByName:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _workStarRating.filledStarImage = [[[FMTheme getInstance] getImageByName:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_workStarRating addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    
        
        
        _contentContainerView = [[UIScrollView alloc] init];
        
        _commentView = [[BaseTextView alloc] init];
        [_commentView setLeftDesc:nil andLabelWidth:0];
        [_commentView setShowBounds:YES];
        [_commentView setMinHeight:_defaultInputHeight];
        [_commentView setOnViewResizeListener:self];
        [_commentView setTopDesc:[[BaseBundle getInstance] getStringByKey:@"order_evaluate_option" inTable:nil]];
        
        [_contentContainerView addSubview:_timelinessLbl];
        [_contentContainerView addSubview:_timelinessScoreLbl];
        [_contentContainerView addSubview:_timelinessStarRating];
        
        [_contentContainerView addSubview:_serviceLbl];
        [_contentContainerView addSubview:_workScoreLbl];
        [_contentContainerView addSubview:_serviceStarRating];
        
        [_contentContainerView addSubview:_workLbl];
        [_contentContainerView addSubview:_serviceScoreLbl];
        [_contentContainerView addSubview:_workStarRating];
        
        [_contentContainerView addSubview:_commentView];
        
        
        
        
        
        
        _okBtn = [[UIButton alloc] init];
        _okBtn.tag = ORDER_EVALUATE_TYPE_OK;
        [_okBtn.titleLabel setFont:msgFont];
        [_okBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(onOkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.tag = ORDER_EVALUATE_TYPE_CANCEL;
        [_cancelBtn.titleLabel setFont:msgFont];
        [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(onCancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _controlContainerView = [[UIView alloc] init];
        [_controlContainerView addSubview:_okBtn];
        [_controlContainerView addSubview:_cancelBtn];
        
        //标题
        _titleLbl = [[BaseLabelView alloc] init];
        [_titleLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_evaluate_score" inTable:nil] andLabelWidth:_labelWidth];
        _titleLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [_titleLbl setShowBounds:YES];
        
        [self addSubview:_titleLbl];
        [self addSubview:_contentContainerView];
        [self addSubview:_controlContainerView];
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
    CGFloat itemHeight;
    CGFloat originX = 0;
    
    CGFloat originYSub = 0;
    CGFloat originXSub = 0;
    CGFloat defaultItemHeight = 30;
    
    itemHeight = _titleHeight;
    [_titleLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;
    
    itemHeight = height - _titleHeight - _controlHeight;
    [_contentContainerView setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;
    
    originYSub = _padding;
    originXSub = _padding * 2;
    
    itemHeight = defaultItemHeight;
    [_timelinessLbl setFrame:CGRectMake(originXSub, originYSub, _labelWidth, itemHeight)];
    originXSub += _labelWidth;
    [_timelinessStarRating setFrame:CGRectMake(originXSub, originYSub, width-originXSub- _scoreWidth -_padding, itemHeight)];
    originXSub += width-originXSub- _scoreWidth -_padding;
    [_timelinessScoreLbl setFrame:CGRectMake(originXSub, originYSub, _scoreWidth, itemHeight)];
    originYSub += itemHeight + _padding;
    originXSub = _padding * 2;
    
    itemHeight = defaultItemHeight;
    [_serviceLbl setFrame:CGRectMake(originXSub, originYSub, _labelWidth, itemHeight)];
    originXSub += _labelWidth;
    [_serviceStarRating setFrame:CGRectMake(originXSub, originYSub, width-originXSub-_scoreWidth -_padding, itemHeight)];
    originXSub += width-originXSub- _scoreWidth -_padding;
    [_serviceScoreLbl setFrame:CGRectMake(originXSub, originYSub, _scoreWidth, itemHeight)];
    originYSub += itemHeight + _padding;
    originXSub = _padding * 2;
    
    itemHeight = defaultItemHeight;
    [_workLbl setFrame:CGRectMake(originXSub, originYSub, _labelWidth, itemHeight)];
    originXSub += _labelWidth;
    [_workStarRating setFrame:CGRectMake(originXSub, originYSub, width-originXSub- _scoreWidth -_padding, itemHeight)];
    originXSub += width-originXSub- _scoreWidth -_padding;
    [_workScoreLbl setFrame:CGRectMake(originXSub, originYSub, _scoreWidth, itemHeight)];
    originYSub += itemHeight + _padding;
    
    originXSub = _padding * 2;
    itemHeight = defaultItemHeight;
//    [_commentLbl setFrame:CGRectMake(originXSub, originYSub, _labelWidth, itemHeight)];
//    originXSub += _labelWidth;
    itemHeight = CGRectGetHeight(_commentView.frame);
    if(itemHeight < _defaultInputHeight) {
        itemHeight = _defaultInputHeight;
    }
    [_commentView setFrame:CGRectMake(originXSub, originYSub, width-originXSub*2, itemHeight)];
    originYSub += itemHeight + _padding;
    
    _contentContainerView.contentSize = CGSizeMake(width, originYSub);
    
    
    itemHeight = _controlHeight;
    [_controlContainerView setFrame:CGRectMake(0, originY, width, itemHeight)];
    originX = width - _btnWidth * 2 - _padding * 2;
    [_okBtn setFrame:CGRectMake(originX, (itemHeight - _btnHeight)/2, _btnWidth, _btnHeight)];
    [_okBtn primaryStyle];
    originX += _btnWidth + _padding;
    [_cancelBtn setFrame:CGRectMake(originX, (itemHeight - _btnHeight)/2, _btnWidth, _btnHeight)];
    [_cancelBtn primaryStyle];
    originX += _btnWidth + _padding;
}

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _listener = listener;
    
}

#pragma --- 评分改变
- (void) didChangeValue:(HCSStarRatingView *) sender {
    starRatingType type = sender.tag;
    NSString * ratingString = [NSString stringWithFormat:@"%.1f", sender.value];
    switch (type) {
        case STAR_RATING_TIMELINESS:
            _timelinessScoreLbl.text = ratingString;
            break;
        case STAR_RATING_SERVICE:
            _serviceScoreLbl.text = ratingString;
            break;
        case STAR_RATING_WORK:
            _workScoreLbl.text = ratingString;
            break;
    }
}

#pragma --- 点击
- (void) onOkButtonClicked {
    if(_listener) {
        [_listener onItemClick:self subView:_okBtn];
    }
}

- (void) onCancelButtonClicked {
    if(_listener) {
        [_listener onItemClick:self subView:_cancelBtn];
    }
}

#pragma --- 评论内容高度变化
- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _commentView) {
        CGRect frame = view.frame;
        frame.size = newSize;
        view.frame = frame;
        [self updateViews];
    }
}

@end
