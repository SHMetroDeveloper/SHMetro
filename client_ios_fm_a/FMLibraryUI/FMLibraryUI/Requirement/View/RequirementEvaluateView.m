//
//  RequirementEvaluateView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/29.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequirementEvaluateView.h"
#import "BaseTextView.h"
#import "BaseRadioBoxView.h"
#import "BaseDataEntity.h"
#import "UIButton+Bootstrap.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "FMUtils.h"

@interface RequirementEvaluateView () <OnViewResizeListener>

@property (readwrite, nonatomic, strong) UIScrollView * contentContainerView;
@property (readwrite, nonatomic, strong) BaseRadioBoxView * radioBox;
@property (readwrite, nonatomic, strong) BaseTextView * commentView;
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UILabel * titleLbl;
@property (nonatomic, strong) UILabel * contentTitleLbl;

@property (readwrite, nonatomic, strong) UIView * controlView;

@property (readwrite, nonatomic, strong) UIButton * okBtn;
//@property (readwrite, nonatomic, strong) UIButton * cancelBtn;


@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat minCommentHeight;


@property (readwrite, nonatomic, strong) NSMutableArray * gradeArray;   //满意度数组
@property (readwrite, nonatomic, strong) NSMutableArray * descArray;   //满意度描述

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end

@implementation RequirementEvaluateView

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
        _controlHeight = [FMSize getInstance].bottomControlHeight;
        _btnHeight = [FMSize getInstance].btnBottomControlHeight;
        _minCommentHeight = 120;
        _defaultItemHeight = 30;
        
        _gradeArray = [[NSMutableArray alloc] init];
        
        //主容器
        _contentContainerView = [[UIScrollView alloc] init];
        
        
        
        //单选区
        _radioBox = [[BaseRadioBoxView alloc] init];
        _radioBox.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        
        
        //编辑区
        _commentView = [[BaseTextView alloc] init];
        _commentView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_commentView setTopDesc:[[BaseBundle getInstance] getStringByKey:@"requirement_evaluate_comment" inTable:nil]];
        [_commentView setShowBounds:YES];
        [_commentView setShowCorner:YES];
        [_commentView setOnViewResizeListener:self];
        
        
        
        _controlView = [[UIView alloc] init];
        
        _titleView = [UIView new];
        _titleView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _titleLbl = [UILabel new];
        _titleLbl.font = [FMFont getInstance].font42;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"requirement_satisfaction_title" inTable:nil];
        
        _contentTitleLbl = [UILabel new];
        _contentTitleLbl.font = [FMFont getInstance].font42;
        _contentTitleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _contentTitleLbl.text = [[BaseBundle getInstance] getStringByKey:@"requirement_satisfaction" inTable:nil];
        
        _okBtn = [[UIButton alloc] init];
        
        [_okBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil] forState:UIControlStateNormal];
        
//        [_radioBox setTitle:[[BaseBundle getInstance] getStringByKey:@"requirement_satisfaction" inTable:nil]];
//        [_radioBox setShowBound:YES];
        
        
//        [_contentContainerView addSubview:_titleLbl];
        [_titleView addSubview:_titleLbl];
        
        [_contentContainerView addSubview:_titleView];
        [_contentContainerView addSubview:_contentTitleLbl];
        [_contentContainerView addSubview:_radioBox];
        [_contentContainerView addSubview:_commentView];
        
        [_okBtn addTarget:self action:@selector(onOkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _okBtn.tag = REQUIREMENT_EVALUATE_TYPE_OK;
        
        
        [_controlView addSubview:_okBtn];
        
        
        [self addSubview:_contentContainerView];
        [self addSubview:_controlView];
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    NSInteger count = [self getDescCount];
    CGFloat itemHeight = [BaseRadioBoxView calculateHeightByCount:count];
    CGFloat sepHeight = [FMSize getInstance].padding50;
    CGFloat btnWidth = (width - _padding * 2);
    
    if(!_descArray || [_descArray count] == 0) {
        _descArray = [self getDescArray];
        [_radioBox setInfoWith:_descArray];
    }
    
    CGFloat originY = 0;
    
    
    CGSize titleSize = [FMUtils getLabelSizeBy:_titleLbl andContent:_titleLbl.text andMaxLabelWidth:width];
    
    
    [_titleView setFrame:CGRectMake(0, 0, width, [FMSize getSizeByPixel:120])];
    [_titleLbl setFrame:CGRectMake([FMSize getInstance].padding40, ([FMSize getSizeByPixel:120] - titleSize.height)/2, titleSize.width, titleSize.height)];
    originY += [FMSize getSizeByPixel:120] + [FMSize getInstance].padding50;
    
    [_contentTitleLbl setFrame:CGRectMake([FMSize getInstance].padding70, originY, titleSize.width, titleSize.height)];
    originY += [FMSize getInstance].padding60 + titleSize.height;
    
    
    [_radioBox setFrame:CGRectMake(([FMSize getSizeByPixel:100] - [FMSize getInstance].defaultPadding), originY, width - ([FMSize getSizeByPixel:100] - [FMSize getInstance].defaultPadding)*2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = CGRectGetHeight(_commentView.frame);
    if(itemHeight < _minCommentHeight) {
        itemHeight = _minCommentHeight;
    }
    [_commentView setFrame:CGRectMake(_padding, originY, width-_padding*2, itemHeight)];
    originY += itemHeight + _padding;
    
    [_contentContainerView setFrame:CGRectMake(0, 0, width, height-_controlHeight)];
    _contentContainerView.contentSize = CGSizeMake(width, originY);
    [_controlView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    
    [_okBtn setFrame:CGRectMake(_padding, (_controlHeight-_btnHeight)/2, btnWidth, _btnHeight)];
    
    [_okBtn primaryStyle];
}

//获取满意度描述信息数组
- (NSMutableArray *) getDescArray {
    NSMutableArray * res;
    if(_gradeArray) {
        res = [[NSMutableArray alloc] init];
        for(SatisfactionType * satisfaction in _gradeArray) {
            [res addObject:satisfaction.degree];
        }
    }
    return res;
}

//获取满意度描述信息数量
- (NSInteger) getDescCount {
    NSInteger count = 0;
    if(_gradeArray) {
        count = [_gradeArray count];
    }
    return count;
}

- (void) setInfoWithSatisfactionArray:(NSMutableArray *) array {
    _gradeArray = array;
    _descArray = nil;
    [self updateViews];
}
- (SatisfactionType *) getSelectedSatisfaction {
    SatisfactionType * type;
    if(_gradeArray && [_gradeArray count] > 0) {
        NSInteger curIndex = [_radioBox getSelectedIndex];
        if(curIndex >= 0 && curIndex < [_gradeArray count]) {
            type = _gradeArray[curIndex];
        }
    }
    return type;
}
- (NSString *) getCommentOfSelectedSatisfaction {
    NSString * res = [_commentView getContent];
    return res;
}

- (void) onOkBtnClicked {
    if(_listener) {
        [_listener onItemClick:self subView:_okBtn];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _commentView) {
        CGRect frame = _commentView.frame;
        CGSize oldSize = frame.size;
        
        if(oldSize.width != newSize.width || oldSize.height != newSize.height) {
            frame.size = newSize;
            _commentView.frame = frame;
            [self updateViews];
        }
    }
}


+ (CGFloat) calculateHeightBySatisfactionArrayCount:(NSInteger )count {
    CGFloat height = 0;
    
    CGFloat titleHeight = [FMSize getSizeByPixel:120];
    CGFloat titleLblHeight = 18.3f;
    CGFloat padding1 = [FMSize getInstance].padding50;
    CGFloat padding2 = [FMSize getInstance].padding60;
    CGFloat itemHeight = [BaseRadioBoxView calculateHeightByCount:count];
    CGFloat minHeight = 120;
    CGFloat sepHeight = [FMSize getInstance].padding50;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat bottomControlHeight = [FMSize getInstance].bottomControlHeight;
    
    height = titleHeight + padding1 + titleLblHeight + padding2 + itemHeight + sepHeight + minHeight + padding + bottomControlHeight;
    
    return height;
}

@end
