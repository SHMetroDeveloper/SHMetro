//
//  ContractProfileCollectionViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "ContractProfileCollectionViewCell.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"

@interface ContractProfileCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) SeperatorView *rightSeperator;
@property (nonatomic, strong) SeperatorView *bottomSeperator;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation ContractProfileCollectionViewCell

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
//        [self initViews];
//        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self initViews];
    [self updateViews];
}

- (void)initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _titleLbl = [UILabel new];
        _titleLbl.font = [FMFont getInstance].font38;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        
        _contentLbl = [UILabel new];
        _contentLbl.font = [FMFont setFontByPX:72];
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
        _contentLbl.textAlignment = NSTextAlignmentCenter;
        
        _rightSeperator = [[SeperatorView alloc] init];
        [_rightSeperator setShowRightBound:YES];
        
        _bottomSeperator = [[SeperatorView alloc] init];
        
        [self addSubview:_titleLbl];
        [self addSubview:_contentLbl];
        
        [self addSubview:_rightSeperator];
        [self addSubview:_bottomSeperator];
    }
}

- (void)updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat sepHeight = 13;
    CGFloat paddingTop = [FMSize getInstance].defaultPadding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight + 0.2;
    CGFloat titleHeight = 17;
    CGFloat contentHeight = 32;
    
    CGFloat originX = 0;
    CGFloat originY = (height - titleHeight - contentHeight - sepHeight)/2;
    
    [_titleLbl setFrame:CGRectMake(originX, originY, width, titleHeight)];
    originY += sepHeight + titleHeight;
    
    [_contentLbl setFrame:CGRectMake(originX, originY, width, contentHeight)];
    
    [_rightSeperator setFrame:CGRectMake(width-seperatorHeight, paddingTop, seperatorHeight, height-paddingTop*2)];
    
    [_bottomSeperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
}

- (void)setTitleWith:(NSString *)title {
    [_titleLbl setText:title];
}

- (void)setContentWith:(NSString *)content {
    [_contentLbl setText:@"0"];
    if (![FMUtils isStringEmpty:content]) {
        [_contentLbl setText:content];
    }
}

+ (CGFloat)getItemHeight {
    CGFloat height = 83;
    
    return height;
}

@end
