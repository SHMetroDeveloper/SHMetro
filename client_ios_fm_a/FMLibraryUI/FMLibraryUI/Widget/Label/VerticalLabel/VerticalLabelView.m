//
//  VerticalLabelView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/5/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "VerticalLabelView.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"

@interface VerticalLabelView ()

@property (readwrite, nonatomic, strong) UILabel * descLbl; //描述
@property (readwrite, nonatomic, strong) UILabel * contentLbl;  //内容

@property (readwrite, nonatomic, strong) UIFont * descFont;
@property (readwrite, nonatomic, strong) UIFont * contentFont;

@property (readwrite, nonatomic, assign) CGFloat sepHeight;

@property (readwrite, nonatomic, strong) NSString * desc;
@property (readwrite, nonatomic, strong) NSString * content;
@property (readwrite, nonatomic, strong) NSString * placeholder;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnClickListener> listener;
@end

@implementation VerticalLabelView

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
        
        _sepHeight = 8;
        
        _descFont = [FMFont fontWithSize:11];
        _contentFont = [FMFont fontWithSize:14];
        
        _descLbl = [[UILabel alloc] init];
        _contentLbl = [[UILabel alloc] init];
        
        _descLbl.font = _descFont;
        _contentLbl.font = _contentFont;
        
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        
        _descLbl.textAlignment = NSTextAlignmentCenter;
        _contentLbl.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_descLbl];
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
    CGFloat descHeight = 0;
    CGFloat contentHeight = 0;
    
    CGFloat sepHeight = 0;
    
    descHeight = [FMUtils heightForStringWith:_descLbl value:_desc andWidth:width];
    
    if(![FMUtils isStringEmpty:_content]) {
        contentHeight = [FMUtils heightForStringWith:_contentLbl value:_desc andWidth:width];
        sepHeight = _sepHeight;
    } else {
        contentHeight = [FMUtils heightForStringWith:_contentLbl value:_placeholder andWidth:width];
        sepHeight = _sepHeight;
    }
    
    CGFloat originY = (height - descHeight - contentHeight - sepHeight) / 2;
    [_descLbl setFrame:CGRectMake(0, originY, width, descHeight)];
    originY += descHeight + sepHeight;
    
    [_contentLbl setFrame:CGRectMake(0, originY, width, contentHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_descLbl setText:_desc];
    if(![FMUtils isStringEmpty:_content]) {
        [_contentLbl setText:_content];
        [_contentLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
    } else if(![FMUtils isStringEmpty:_placeholder]) {
        [_contentLbl setText:_placeholder];
        [_contentLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_PLACEHOLDER]];
    }
    
}

- (void) setDesc:(NSString *) desc {
    _desc = desc;
    [self updateInfo];
}
- (void) setContent:(NSString *) content {
    _content = content;
    [self updateViews];
}

- (void) setPlaceholder:(NSString *) placeholder {
    _placeholder = placeholder;
    [self updateViews];
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClicked)];
        [self addGestureRecognizer:gesture];
    }
    _listener = listener;
}

- (void) onClicked {
    if(_listener) {
        [_listener onClick:self];
    }
}
@end
