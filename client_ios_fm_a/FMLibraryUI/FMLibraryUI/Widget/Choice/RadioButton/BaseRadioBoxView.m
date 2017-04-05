//
//  BaseRadioBoxView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseRadioBoxView.h"
#import "BaseLabelView.h"
#import "BaseRadioButtonView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "OnClickListener.h"

typedef NS_ENUM(NSInteger, RadioBoxValueType) {
    RADIO_BOX_VALUE_TYPE_INDEX_CHANGE,
};


@interface BaseRadioBoxView () <OnClickListener>
@property (readwrite, nonatomic, strong) BaseLabelView * titleLbl;
@property (readwrite, nonatomic, strong) NSMutableArray * radioBtnArray;
@property (readwrite, nonatomic, strong) NSMutableArray * descArray;
@property (readwrite, nonatomic, strong) NSString * title;

@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) NSInteger selectedIndex;


@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, weak) id<OnValueChangedListener> valueListener;
@end

@implementation BaseRadioBoxView


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
        
        _radioBtnArray = [[NSMutableArray alloc] init];
        
        _itemHeight = [FMSize getInstance].listItemInfoHeight;
        
        _titleHeight = 40;
        
        _titleLbl = [[BaseLabelView alloc] init];
        
        [self addSubview:_titleLbl];
    }
}

- (void) updateViews {
    
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    NSInteger count = [_descArray count];
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGFloat sepHeight = (height-_itemHeight*count-_titleHeight)/count;
    CGFloat originY = 0;
    CGFloat originX = 0;
    CGFloat itemHeight = 0;
    
    if(![FMUtils isStringEmpty:_title]) {
        itemHeight = _titleHeight;
    }
//    sepHeight = (height-_itemHeight*count-itemHeight)/count;
    sepHeight = [FMSize getInstance].padding40;
    
    [_titleLbl setFrame:CGRectMake(padding, originY, width-padding*2, itemHeight)];
    originY += itemHeight;
    
    for(NSInteger index = 0 ; index < count ; index++) {
        BaseRadioButtonView * radioLbl;
        NSString * desc = _descArray[index];
        if(index<[_radioBtnArray count]) {
            radioLbl = _radioBtnArray[index];
            [radioLbl setHidden:NO];
        } else {
            radioLbl = [[BaseRadioButtonView alloc] init];
            [_radioBtnArray addObject:radioLbl];
            [radioLbl setOnClickListener:self];
            [self addSubview:radioLbl];
        }
        originX = padding;
        itemHeight = _itemHeight;
        [radioLbl setFrame:CGRectMake(originX, originY, width-padding*2, itemHeight)];
        originY += itemHeight + sepHeight;
        
        radioLbl.tag = index;
        [radioLbl setDesc:desc];
        if(_selectedIndex == index) {
            [radioLbl setSelected:YES];
        } else {
            [radioLbl setSelected:NO];
        }
    }
    for(NSInteger index = [_descArray count];index<[_radioBtnArray count];index++) {
        BaseRadioButtonView * radioLbl = _radioBtnArray[index];
        [radioLbl setHidden:YES];
    }
    
}

- (void) updateInfo {
    if(_title) {
        [_titleLbl setContent:_title];
    }
}

- (void) setTitle:(NSString *) title {
    _title = title;
    [self updateInfo];
}
- (void) setInfoWith:(NSMutableArray *)descArray {
    _descArray = descArray;
    [self updateViews];
}

- (void) setSelectIndex:(NSInteger) index {
    _selectedIndex = index;
    [self updateViews];
}

- (NSInteger) getSelectedIndex {
    return _selectedIndex;
}

- (void) setShowBound:(BOOL) showBound {
    if(showBound) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    } else {
        self.layer.borderWidth = 0;
    }
}

- (void) notifyValueChanged {
    NSLog(@"selected index : %ld", _selectedIndex);
    if(_valueListener) {
        [_valueListener onValueChanged:self type:RADIO_BOX_VALUE_TYPE_INDEX_CHANGE value:[NSNumber numberWithInteger:_selectedIndex]];
    }
}

- (void) onClick:(UIView *)view {
    if([view isKindOfClass:[BaseRadioButtonView class]]) {
        NSInteger index = view.tag;
        if(index != _selectedIndex) {
            _selectedIndex = index;
            [self updateViews];
            [self notifyValueChanged];
        }
    }
}



- (void) setOnValueChangedListener:(id<OnValueChangedListener>)listener {
    _valueListener = listener;
}

+ (CGFloat) calculateHeightByCount:(NSInteger) count {
    CGFloat height = 0;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat padding = [FMSize getInstance].padding40;
    
    if (count > 0) {
        height = count * itemHeight + (count-1) * padding;
    }
    
    return height;
}

@end
