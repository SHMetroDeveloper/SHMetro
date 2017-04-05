//
//  RequirementDetailEvaluateViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 10/25/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "RequirementDetailEvaluateViewController.h"
#import "CaptionTextView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "BaseStarRatingView.h"
#import "SeperatorView.h"
#import "RequirementManagerBusiness.h"

@interface RequirementDetailEvaluateViewController () <OnViewResizeListener>

@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (nonatomic, strong) BaseStarRatingView *qualityStarRatingView;
@property (nonatomic, strong) BaseStarRatingView *speedStarRatingView;
@property (nonatomic, strong) BaseStarRatingView *attitudeStarRatingView;

@property (nonatomic, strong) CaptionTextView * descView;    //描述

@property (nonatomic, strong) RequirementManagerBusiness *business;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, assign) CGFloat markHeight;    //评分高度

@property (nonatomic, assign) CGFloat defaultDescHeight;    //默认描述高度

@property (nonatomic, strong) NSNumber *reqId;

@property(readwrite,nonatomic,strong) id<OnMessageHandleListener> resultHandler;

@end

@implementation RequirementDetailEvaluateViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_requirement_detail_evaluate" inTable:nil]];
    NSArray * menus = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_menu_evaluate" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (position == 0) {
        [self evaluate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _markHeight = 38;
        _defaultDescHeight = 174;
        
        _business = [[RequirementManagerBusiness alloc] init];
        
        CGFloat originY = 0;
        CGFloat paddingTop = [FMSize getInstance].defaultPadding;
        
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
//        originY += paddingTop;
        
        
        _qualityStarRatingView = [[BaseStarRatingView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _markHeight)];
        [_qualityStarRatingView setRating:5];
        [_qualityStarRatingView setName: [[BaseBundle getInstance] getStringByKey:@"requirement_evaluate_quality" inTable:nil]];
        _qualityStarRatingView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        originY += _markHeight;
        
        
        _speedStarRatingView = [[BaseStarRatingView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _markHeight)];
        [_speedStarRatingView setRating:5];
        [_speedStarRatingView setName: [[BaseBundle getInstance] getStringByKey:@"requirement_evaluate_speed" inTable:nil]];
        _speedStarRatingView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        originY += _markHeight;
        
        
        _attitudeStarRatingView = [[BaseStarRatingView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _markHeight)];
        [_attitudeStarRatingView setRating:5];
        [_attitudeStarRatingView setName: [[BaseBundle getInstance] getStringByKey:@"requirement_evaluate_attitude" inTable:nil]];
        _attitudeStarRatingView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        originY += _markHeight;
        
        SeperatorView *seperator = [[SeperatorView alloc] init];
        [seperator setFrame:CGRectMake(0, originY - [FMSize getInstance].seperatorHeight, _realWidth, [FMSize getInstance].seperatorHeight)];
        
        
        _descView = [[CaptionTextView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _defaultDescHeight)];
        [_descView setTitle:[[BaseBundle getInstance] getStringByKey:@"requirement_evaluate_desc" inTable:nil]];
        [_descView setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"requirement_evaluate_desc_placeholder" inTable:nil]];
        [_descView setOnViewResizeListener:self];
        originY += _defaultDescHeight;
        
        
        [_mainContainerView addSubview:_qualityStarRatingView];
        [_mainContainerView addSubview:_speedStarRatingView];
        [_mainContainerView addSubview:_attitudeStarRatingView];
        [_mainContainerView addSubview:seperator];
        
        [_mainContainerView addSubview:_descView];
        _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateLayout {
    CGFloat descHeight = CGRectGetHeight(_descView.frame);
    CGFloat paddingTop = [FMSize getInstance].defaultPadding;
    CGFloat originY = paddingTop + _markHeight*3;
    
    [_descView setFrame:CGRectMake(0, originY, _realWidth, descHeight)];
    
    originY += descHeight;
    
    _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
}


- (void) setInfoWithRequirementId:(NSNumber *)reqId {
    _reqId = reqId;
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _descView) {
        CGRect frame = _descView.frame;
        frame.size = newSize;
        [_descView setFrame:frame];
        [self updateLayout];
    }
}

- (void) evaluate {
    RequirementEvaluateRequestParam *param = [[RequirementEvaluateRequestParam alloc] init];
    param.reqId = _reqId;
    param.quality = [_qualityStarRatingView getRateValue];
    param.speed = [_speedStarRatingView getRateValue];
    param.attitude = [_attitudeStarRatingView getRateValue];
    param.desc = [_descView text];
    
    __weak typeof(self) weakSelf = self;
    [_business evaluateOperateTypeByparam:param Success:^(NSInteger key, id object) {
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"requirement_evaluate_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [weakSelf handleResult];
        [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"requirement_evaluate_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _resultHandler = handler;
}

- (void) handleResult {
    if(_resultHandler) {
        NSNumber *successTag = [NSNumber numberWithBool:YES];
        NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
        [msg setValue:@"RequirementDetailEvaluateViewController" forKeyPath:@"msgOrigin"];
        [msg setValue:successTag forKeyPath:@"result"];
        [_resultHandler handleMessage:msg];
    }
}

@end


