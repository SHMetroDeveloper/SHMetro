//
//  ColorsDescLabel.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/15.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ColorsDescLabel.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"
//#import "BaseTimeLabel.h"
#import "SeperatorView.h"
#import "BaseLabelView.h"

typedef NS_ENUM(NSInteger, ColorDescLabelItemType) {
    COLOR_DESC_LABEL_ITEM_UNKNOW,
    COLOR_DESC_LABEL_ITEM_COLOR,        //颜色
    COLOR_DESC_LABEL_ITEM_DESC          //说明
};

@interface ColorsDescLabel ()

@property (readwrite, nonatomic, strong) UIView * labelContainerView;   //方便整体布局
@property (readwrite, nonatomic, strong) NSMutableArray * lblArray;
@property (readwrite, nonatomic, strong) NSMutableArray * colorArray;
@property (readwrite, nonatomic, strong) NSMutableArray * descArray;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, strong) UIFont * mFont;

@property (readwrite, nonatomic, assign) ColorDescLayoutType layoutType;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation ColorsDescLabel

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
        
        _defaultItemHeight = 20;
        _paddingTop = [FMSize getInstance].defaultPadding * 2;
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _mFont = [FMFont getInstance].defaultFontLevel3;
        
        _labelContainerView = [[UIView alloc] init];
        
        [self addSubview:_labelContainerView];
        
    }
}

//获取需要展示的颜色的个数
- (NSInteger) getColorCount {
    NSInteger count = [_colorArray count];
    if(count > [_descArray count]) {
        count = [_descArray count];
    }
    return count;
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    NSInteger count = [self getColorCount];
    NSInteger index = 0;
    CGFloat originY = 0;
    CGFloat originX = 0;
    CGFloat sepHeight = 5;
    
    CGFloat colorWidth = 8;
    CGFloat sepWidth = 5;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGFloat itemWidth = 0;
    CGFloat itemHeight = 15;
    
    if(sepHeight > padding) {
        sepHeight = padding;
    }
    UILabel * testLbl = [[UILabel alloc] init];
    [testLbl setFont:[FMFont getInstance].defaultFontLevel3];
    if(!_lblArray) {
        _lblArray = [[NSMutableArray alloc] init];
    }
    {
        originX = _paddingLeft;
        if(_layoutType == COLOR_DESC_LAYOUT_HORIZONTAL) {
            originY = (height - itemHeight) / 2;
        } else {
            originY = (height - itemHeight * count + sepHeight * (count-1)) / 2;
        }
        
        for(index = 0;index<count;index++) {
            UIView* colorItemView;
            UILabel * colorLbl;
            UILabel * descLbl;
            NSString * desc = _descArray[index];
            CGFloat descWidth = [FMUtils widthForString:testLbl value:desc];
            
            itemWidth = descWidth + colorWidth + sepWidth;
            
            if(index<[_lblArray count]) {
                colorItemView = _lblArray[index];
            }
            if(!colorItemView) {
                colorItemView = [[UIView alloc] init];
                colorLbl = [[UILabel alloc] init];
                descLbl = [[UILabel alloc] init];
                
                [descLbl setFont:_mFont];
                
                colorLbl.tag = COLOR_DESC_LABEL_ITEM_COLOR;
                descLbl.tag = COLOR_DESC_LABEL_ITEM_DESC;
                
                [colorItemView addSubview:colorLbl];
                [colorItemView addSubview:descLbl];
                [self addSubview:colorItemView];
                
                [_lblArray addObject:colorItemView];
            } else {
                for(UIView * subView in [colorItemView subviews]) {
                    if(subView.tag == COLOR_DESC_LABEL_ITEM_COLOR) {
                        colorLbl = (UILabel *)subView;
                    } else if(subView.tag == COLOR_DESC_LABEL_ITEM_DESC) {
                        descLbl = (UILabel *)subView;
                    }
                    if(colorLbl && descLbl) {
                        break;
                    }
                }
                [colorItemView setHidden:NO];
            }
            
            [colorItemView setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
            [colorLbl setFrame:CGRectMake(0, (itemHeight - colorWidth) / 2, colorWidth, colorWidth)];
            [descLbl setFrame:CGRectMake((colorWidth+sepWidth), 0, (itemWidth-colorWidth-sepWidth), itemHeight)];
            
            
            [colorLbl setBackgroundColor:_colorArray[index]];
            [descLbl setText:_descArray[index]];
            
            if(_layoutType == COLOR_DESC_LAYOUT_HORIZONTAL) {
                originX += itemWidth + sepWidth;
            } else if(_layoutType == COLOR_DESC_LAYOUT_VERTICAL) {
                originY += itemHeight + sepHeight;
            }
            
        }
    }
    
    if(_layoutType == COLOR_DESC_LAYOUT_HORIZONTAL) {
        self.contentSize = CGSizeMake(originX, height);
    } else if(_layoutType == COLOR_DESC_LAYOUT_VERTICAL) {
        self.contentSize = CGSizeMake(width, originY);
    }
    
    
    count = [_lblArray count];
    for(;index<count;index++) {
        UIView * view = _lblArray[index];
        [view setHidden:YES];
    }
}



- (void) setColors:(NSMutableArray *) colorArray desc:(NSMutableArray *) descArray {
    _colorArray = [colorArray copy];
    _descArray = [descArray copy];
    [self updateViews];
}

- (void) setLayoutType:(ColorDescLayoutType)layoutType {
    _layoutType = layoutType;
}

- (void) setPaddingTop:(CGFloat)paddingTop {
    _paddingTop = paddingTop;
}

@end