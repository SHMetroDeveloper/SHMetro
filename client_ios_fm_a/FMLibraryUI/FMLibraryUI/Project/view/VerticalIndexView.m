//
//  VerticalIndexView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/28.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "VerticalIndexView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"

@interface VerticalIndexView ()

@property (readwrite, nonatomic, strong) NSMutableArray * keyViewArray;
@property (readwrite, nonatomic, strong) NSMutableArray * keys;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, strong) UIColor * keyColor;
@property (readwrite, nonatomic, strong) UIFont * keyFont;
@property (readwrite, nonatomic, assign) VerticalIndexLocationType type;
@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;
@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation VerticalIndexView

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
        
        _keyColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
        _keyFont = [FMFont getInstance].defaultFontLevel4;
        _paddingTop = 0;
        _paddingBottom = 0;
        _paddingLeft = 0;
        _paddingRight = 0;
        _itemHeight = 0;
        
        _keyViewArray = [[NSMutableArray alloc] init];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat itemWidth = width-_paddingLeft - _paddingRight;
    NSInteger index = 0;
    CGFloat originY = _paddingTop;
    CGFloat sepHeight = 0;

    if(_itemHeight == 0) {
        _itemHeight = itemWidth;
    }
    
    for(NSString * key in _keys) {
        UILabel * keyLbl;
        if(index < [_keyViewArray count]) {
            keyLbl = _keyViewArray[index];
            [keyLbl setHidden:NO];
        } else {
            keyLbl = [[UILabel alloc] init];
            keyLbl.textColor = _keyColor;
            keyLbl.font = _keyFont;
            keyLbl.textAlignment = NSTextAlignmentCenter;
            keyLbl.userInteractionEnabled = YES;
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onKeyClicked:)];
            [keyLbl addGestureRecognizer:tapGesture];
            [_keyViewArray addObject:keyLbl];
            [self addSubview:keyLbl];
        }
        [keyLbl setFrame:CGRectMake(_paddingLeft, originY, itemWidth, _itemHeight)];
        [keyLbl setText:[key uppercaseString]];
        keyLbl.tag = index;
        originY += _itemHeight + sepHeight;
        index++;
    }
    for(; index < [_keyViewArray count]; index++) {
        UILabel *keyLbl = _keyViewArray[index];
        [keyLbl setHidden:YES];
    }
}

- (void) setKeyWithArray:(NSMutableArray *)keys {
    _keys = keys;
    [self updateViews];
}

- (void) setType:(VerticalIndexLocationType)type {
    _type = type;
    [self updateViews];
}


- (void) setItemHeight:(CGFloat)itemHeight {
    _itemHeight = itemHeight;
    [self updateViews];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _listener = listener;
}

- (void) onKeyClicked:(UITapGestureRecognizer *) sender {
    if(sender) {
        UIView * keyView = sender.view;
        if(_listener) {
            [_listener onItemClick:self subView:keyView];
        }
    }
}

- (void) OnClicked:(id) sender {
    NSLog(@"index clicked.");
    
}

@end
