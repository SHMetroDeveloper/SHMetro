//
//  BaseTabbarView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseTabbarView.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "SeperatorView.h"



@interface BaseTabbarView ()

@property (readwrite, nonatomic, strong) NSMutableArray * btnArray;
@property (readwrite, nonatomic, strong) NSMutableArray * seperatorArray;

@property (readwrite, nonatomic, strong) SeperatorView * bottomSeperator;   // BASE_TABBAR_STYLE_BOTTOM_LINE 样式使用
@property (readwrite, nonatomic, strong) SeperatorView * selectedSeperator;

@property (readwrite, nonatomic, strong) NSMutableArray * dataArray;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, assign) BaseTabbarStyle style;
@property (readwrite, nonatomic, assign) NSInteger curIndex;

@property (readwrite, nonatomic, strong) UIColor* themeColor;    //主题颜色

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end

@implementation BaseTabbarView

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
        
        _style = BASE_TABBAR_STYLE_DEFAULT;
        _themeColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
        
        _bottomSeperator = [[SeperatorView alloc] init];
        _selectedSeperator = [[SeperatorView alloc] init];
        
        _btnArray = [[NSMutableArray alloc] init];
        _seperatorArray  = [[NSMutableArray alloc] init];
        
        [_selectedSeperator setLineColor:_themeColor];
        
        
        
        _curIndex = -1;
        
        [self addSubview:_bottomSeperator];
        [self addSubview:_selectedSeperator];
        
        [self updateStyle];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    NSInteger index = 0;
    CGFloat originX = 0;
    CGFloat seperatorWidth = [FMSize getInstance].seperatorHeight;
    CGFloat btnWidth = 0;
    
    [_bottomSeperator setFrame:CGRectMake(0, height-seperatorWidth, width, seperatorWidth)];
    
    
    for(id obj in _dataArray) {
        SeperatorView * seperator;
        UIButton * btnItem;
        NSString * name;
        if([obj isKindOfClass:[NSString class]]) {
            name = obj;
            
        }
        if(index < [_btnArray count]) {
            btnItem = _btnArray[index];
            [btnItem setHidden:NO];
        } else {
            btnItem = [[UIButton alloc] init];
            [btnItem.titleLabel setFont:[FMFont setFontByPX:48]];
            [btnItem addTarget:self action:@selector(onBtnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_btnArray addObject:btnItem];
            [self addSubview:btnItem];
        }
        if(index < [_dataArray count] - 1) {
            if(index < [_seperatorArray count]) {
                seperator = _seperatorArray[index];
                [seperator setHidden:NO];
            } else {
                seperator = [[SeperatorView alloc] init];
                [seperator setLineColor:_themeColor];
                [seperator setShowLeftBound:YES];
                [_seperatorArray addObject:seperator];
                [self addSubview:seperator];
            }
        }
        
        btnWidth = [self getBtnWidth:index];
        btnItem.tag = index;
        [btnItem setFrame:CGRectMake(originX, 0, btnWidth-seperatorWidth, height)];
        [seperator setFrame:CGRectMake(originX+btnWidth-seperatorWidth, 0, seperatorWidth, height)];
        [seperator setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND]];
        
        //清除之前的样式
        [btnItem setBackgroundColor:self.backgroundColor];
        [btnItem setTitleColor:_themeColor forState:UIControlStateNormal];
        
        [btnItem setTitle:name forState:UIControlStateNormal];
        switch (_style) {
            case BASE_TABBAR_STYLE_DEFAULT:
                if(index == _curIndex) {
                    [btnItem setBackgroundColor:_themeColor];
                    [btnItem setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
                } else {
                    [btnItem setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE]];
                    [btnItem setTitleColor:_themeColor forState:UIControlStateNormal];
                }
                break;
            case BASE_TABBAR_STYLE_BOTTOM_LINE:
                if(index == _curIndex) {
                    CGFloat seperatorHeight = seperatorWidth * 2;
                    CGFloat tmpWidth = CGRectGetWidth(_selectedSeperator.frame);
                    if(tmpWidth == 0) {//首次直接赋值
                        [_selectedSeperator setFrame:CGRectMake(originX, height-seperatorHeight, btnWidth, seperatorHeight)];
                    } else {    //之后就采用动画形式切换
                        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
                            [_selectedSeperator setFrame:CGRectMake(originX, height-seperatorHeight, btnWidth, seperatorHeight)];
                        }];
                    }
                    [btnItem setTitleColor:_themeColor forState:UIControlStateNormal];
                } else {
                    [btnItem setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT] forState:UIControlStateNormal];
                }
                break;
            default:
                break;
        }
        
        originX += btnWidth;
        index++;
    }
    for(;index<[_btnArray count];index++) {
        UIButton * btnItem = _btnArray[index];
        [btnItem setHidden:YES];
        if(index < [_seperatorArray count]) {
            SeperatorView * seperator = _seperatorArray[index];
            //            [seperator setHidden:YES];
        }
    }
    for(;index<[_seperatorArray count];index++) {
        SeperatorView * seperator = _seperatorArray[index];
        //        [seperator setHidden:YES];
    }
    
    
}

- (void) setSelected:(NSInteger) position {
    if(position != _curIndex) {
        _curIndex = position;
        [self updateViews];
    }
}

- (void) setStyle:(BaseTabbarStyle)style {
    _style = style;
    [self updateStyle];
}

- (CGFloat) getBtnWidth:(NSInteger) position {
    CGFloat width = 0;
    CGFloat realWidth = CGRectGetWidth(self.frame);
    NSInteger count = [_dataArray count];
    if(count > 0) {
        CGFloat tmpWidth = realWidth / count;
        if(position < count - 1) {
            width = (NSInteger)(tmpWidth*(position+1)) - (NSInteger)(tmpWidth*position);
        } else {
            width = realWidth - (NSInteger)(tmpWidth*position);
        }
    }
    return width;
}

- (void) updateStyle {
    [_bottomSeperator setHidden:YES];
    [_selectedSeperator setHidden:YES];
    
    switch(_style) {
        case BASE_TABBAR_STYLE_DEFAULT:
            [_selectedSeperator setLineColor:_themeColor];
            self.layer.borderColor = [_themeColor CGColor];
            self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
            self.layer.cornerRadius = 3;
            self.clipsToBounds = YES;
            break;
        case BASE_TABBAR_STYLE_BOTTOM_LINE:
            self.layer.borderWidth = 0;
            self.layer.cornerRadius = 0;
            self.clipsToBounds = YES;
            [_bottomSeperator setHidden:NO];
            [_selectedSeperator setHidden:NO];
            break;
    }
}

- (void) setInfoWithArray:(NSArray *) array {
    _dataArray = [[NSMutableArray alloc] initWithArray:array];
    [self updateViews];
    
    [self bringSubviewToFront:_bottomSeperator];
    [self bringSubviewToFront:_selectedSeperator];
}

- (void) setThemeColor:(UIColor *)themeColor {
    _themeColor = themeColor;
    [self updateViews];
    [self updateStyle];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
}

- (void) onBtnItemClicked:(id) sender {
    UIButton * btn = sender;
    NSInteger position = btn.tag;
    if(_curIndex != position) {
        [self setSelected:position];
        if(_listener) {
            [_listener onItemClick:self subView:btn];
        }
    }
}


@end
