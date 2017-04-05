//
//  BulletinHeaderView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/4.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinHeaderView.h"
#import "FMUtilsPackages.h"
#import "BaseBundle.h"
#import "SeperatorView.h"

@interface BulletinHeaderView ()
@property (nonatomic, strong) UIButton *readBtn;
@property (nonatomic, strong) UIButton *unreadBtn;

@property (nonatomic, strong) SeperatorView *bottomSeperator;
@property (nonatomic, strong) SeperatorView *centerSeperator;
@property (nonatomic, strong) UIView *heighlightCursor;

@property (nonatomic, assign) NSInteger currentHeaderType;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation BulletinHeaderView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _currentHeaderType = BULLETIN_HEADER_TYPE_READ_NO;
        
        _unreadBtn = [UIButton new];
        _unreadBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_unreadBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"bulletin_notice_unread" inTable:nil] forState:UIControlStateNormal];
        [_unreadBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] forState:UIControlStateNormal];
        _unreadBtn.titleLabel.font = [FMFont getInstance].font44;
        [_unreadBtn addTarget:self action:@selector(selectUnReadHeader) forControlEvents:UIControlEventTouchUpInside];
        
        _readBtn = [UIButton new];
        _readBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_readBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"bulletin_notice_read" inTable:nil] forState:UIControlStateNormal];
        [_readBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3] forState:UIControlStateNormal];
        _readBtn.titleLabel.font = [FMFont getInstance].font44;
        [_readBtn addTarget:self action:@selector(selectReadHeader) forControlEvents:UIControlEventTouchUpInside];
        
        _bottomSeperator = [[SeperatorView alloc] init];
        
        _centerSeperator = [[SeperatorView alloc] init];
        [_centerSeperator setShowLeftBound:YES];
        
        _heighlightCursor = [UIView new];
        _heighlightCursor.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
        
        [self addSubview:_readBtn];
        [self addSubview:_unreadBtn];
        [self addSubview:_bottomSeperator];
        [self addSubview:_centerSeperator];
        [self addSubview:_heighlightCursor];
        
        [self updateView];
    }
}

- (void) updateView {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat seperatorSize = [FMSize getInstance].seperatorHeight;
    
    [_unreadBtn setFrame:CGRectMake(0, 0, width/2, height)];
    
    [_readBtn setFrame:CGRectMake(width/2, 0, width/2, height)];
    
    [_bottomSeperator setFrame:CGRectMake(0, height-seperatorSize, width, seperatorSize)];
    
    [_centerSeperator setFrame:CGRectMake(width/2, 0, seperatorSize, height)];
    
    if (_currentHeaderType == BULLETIN_HEADER_TYPE_READ_YES) {
        [UIView animateWithDuration:0.3 animations:^{
            [_readBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] forState:UIControlStateNormal];
            [_unreadBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3] forState:UIControlStateNormal];
            [_heighlightCursor setFrame:CGRectMake(width/2, height-1, width/2, 1)];
        }];
    } else if (_currentHeaderType == BULLETIN_HEADER_TYPE_READ_NO) {
        [UIView animateWithDuration:0.3 animations:^{
            [_readBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3] forState:UIControlStateNormal];
            [_unreadBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] forState:UIControlStateNormal];
            [_heighlightCursor setFrame:CGRectMake(0, height-1, width/2, 1)];
        }];
    }
}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle {
    _leftButtonTitle = leftButtonTitle;
    [_unreadBtn setTitle:_leftButtonTitle forState:UIControlStateNormal];
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle {
    _rightButtonTitle = rightButtonTitle;
    [_readBtn setTitle:_rightButtonTitle forState:UIControlStateNormal];
}

- (void) selectReadHeader {
    _currentHeaderType = BULLETIN_HEADER_TYPE_READ_YES;
    [self updateView];
    _actionBlock(BULLETIN_HEADER_TYPE_READ_YES);
}

- (void) selectUnReadHeader {
    _currentHeaderType = BULLETIN_HEADER_TYPE_READ_NO;
    [self updateView];
    _actionBlock(BULLETIN_HEADER_TYPE_READ_NO);
}

+ (CGFloat) getHeaderHeight {
    CGFloat height = 44;
    return height;
}

@end
