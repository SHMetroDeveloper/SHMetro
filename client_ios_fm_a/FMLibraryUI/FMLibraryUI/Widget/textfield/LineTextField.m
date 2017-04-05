//
//  LineTextField.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/30.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "LineTextField.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"

typedef void (^ActionHandler) (UIAlertAction * action);

@interface LineTextField ()

@property (readwrite, nonatomic, strong) UILabel * bottomLine;  //底部分割线

@property (readwrite, nonatomic, strong) UIColor * lineColor;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (nonatomic, copy) void(^myBlock)(void);

@end

@implementation LineTextField

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
        
        _lineColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7];
        
        _bottomLine = [[UILabel alloc] init];
        
        _bottomLine.backgroundColor = _lineColor;
        
        self.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        self.font = [FMFont getInstance].defaultFontLevel2;
        
        [self addSubview:_bottomLine];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat lineHeight = [FMSize getInstance].seperatorHeight;
    [_bottomLine setFrame:CGRectMake(0, height-lineHeight, width, lineHeight)];
}

//- (void)touchTextField:(){
//
//}

- (void) setLineColor:(UIColor *) color {
    _lineColor = color;
    _bottomLine.backgroundColor = _lineColor;
}



@end


