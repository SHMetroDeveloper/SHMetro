//
//  BaseNoticeView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/18.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseNoticeView.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"

@interface BaseNoticeView ()

@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) UILabel * contentLbl;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSString * content;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat titleHeight;

@property (readwrite, nonatomic, strong) UIFont * titleFont;
@property (readwrite, nonatomic, strong) UIFont * contentFont;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation BaseNoticeView

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
        
        _titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _contentFont = [FMFont fontWithSize:14];
        _titleHeight = 24;
        
        _paddingTop = 20;
        _paddingBottom = 20;
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
        _titleLbl = [[UILabel alloc] init];
        _contentLbl = [[UILabel alloc] init];
        
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L1];
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        _titleLbl.font = _titleFont;
        _contentLbl.font = _contentFont;
        
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _contentLbl.textAlignment = NSTextAlignmentCenter;
        _contentLbl.numberOfLines = 0;
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
        
        [self addSubview:_titleLbl];
        [self addSubview:_contentLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat sepHeight = 6;
    [_titleLbl setFrame:CGRectMake(_paddingLeft, _paddingTop, width-_paddingLeft-_paddingRight, _titleHeight)];
    [_contentLbl setFrame:CGRectMake(_paddingLeft, _paddingTop+_titleHeight+sepHeight, width-_paddingLeft-_paddingRight, height-_titleHeight-_paddingTop-_paddingBottom-sepHeight)];
    [self updateInfo];
}

- (void) updateInfo {
    [_titleLbl setText:_title];
    [_contentLbl setText:_content];
}

- (void) setInfoWithTitle:(NSString *) title message:(NSString *) msg {
    _title = title;
    _content = msg;
    [self updateInfo];
}

+ (CGSize) calculateSizeByTitle:(NSString *) title content:(NSString *) content width:(CGFloat) width{
    CGSize size = CGSizeMake(0, 0);
    CGFloat paddingTop = 20;
    CGFloat paddingBottom = 20;
    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    CGFloat paddingRight = paddingLeft;
    CGFloat titleHeight = 24;
    CGFloat minContentHeight = 16;
    CGFloat sepHeight = 6;
    
    UILabel * testLbl = [[UILabel alloc] init];
    testLbl.font = [FMFont fontWithSize:14];
    testLbl.numberOfLines = 0;
    
    CGFloat contentHeight = [FMUtils heightForStringWith:testLbl value:content andWidth:width-paddingLeft-paddingRight];
    if(contentHeight < minContentHeight) {
        contentHeight = minContentHeight;
    }
    
    CGFloat height = titleHeight + contentHeight + sepHeight + paddingTop + paddingBottom;
    return size = CGSizeMake(width, height);
}

@end
