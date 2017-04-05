//
//  HorizontalDisplayView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/17.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "HorizontalDisplayView.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "PhotoItem.h"
#import "UIButton+AFNetworking.h"

@interface HorizontalDisplayView ()

@property (readwrite, nonatomic, strong) UIScrollView * containerView;  //容器
@property (readwrite, nonatomic, strong) NSMutableArray * contentViewArray; //

@property (readwrite, nonatomic, assign) CGFloat itemWidth; //如果设置本参数则按固定宽度展示

@property (readwrite, nonatomic, assign) CGFloat sepWidth;

@property (readwrite, nonatomic, assign) NSInteger countShow;   //展示的个数, 如果设置本参数则按平均值算

@property (readwrite, nonatomic, assign) CGFloat padding;   //

@property (readwrite, nonatomic, strong) NSMutableArray * contentArray;
@property (readwrite, nonatomic, strong) NSMutableArray * pathArray;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, strong) NSCondition* mlock;       //异步锁

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end

@implementation HorizontalDisplayView

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
        
        _countShow = 0;
        _padding = [FMSize getInstance].defaultPadding;
        _sepWidth = _padding / 2;
        _contentViewArray = [[NSMutableArray alloc] init];
        _contentArray = [[NSMutableArray alloc] init];
        
        _mlock = [[NSCondition alloc] init];
        
        _containerView = [[UIScrollView alloc] init];
        _containerView.delaysContentTouches = NO;
        _containerView.showsHorizontalScrollIndicator = NO;
        
        
        [self addSubview:_containerView];
    }
}


- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    [_containerView setFrame:CGRectMake(_padding, _padding, width-_padding*2, height-_padding*2)];
    
    CGFloat originX = 0;
    NSInteger index = 0;
    NSInteger count = [_contentArray count];
    CGFloat itemHeight = height-_padding*2;
    CGFloat paddingTop = 0;
    
    _itemWidth = [self getItemWidth];
    paddingTop = (itemHeight - _itemWidth) / 2;
    itemHeight = _itemWidth;
    
    originX = _sepWidth;
    
    for(index=0; index<count; index++) {
        UIButton * itemBtn;
        UIImage * img = _contentArray[index];
        if(index < [_contentViewArray count]) {
            itemBtn = _contentViewArray[index];
            [itemBtn setHidden:NO];
        } else {
            itemBtn = [[UIButton alloc] init];
            
            [itemBtn addTarget:self action:@selector(onItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [_contentViewArray addObject:itemBtn];
            [_containerView addSubview:itemBtn];
        }
        [itemBtn setFrame:CGRectMake(originX, 0, _itemWidth, itemHeight)];
        itemBtn.tag = index;
        [itemBtn setImage:img forState:UIControlStateNormal];
        originX += _itemWidth;
        originX += _sepWidth;
        
    }
    _containerView.contentSize = CGSizeMake(originX, itemHeight);
    count = [_contentViewArray count];  //把多余的 view 隐藏起来
    for(; index<count; index++) {
        UIView * itemView  = _contentViewArray[index];
        [itemView setHidden:YES];
    }
    
}

- (void) setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    [self updateViews];
}

//获取 itemWidth
- (CGFloat) getItemWidth {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat itemHeight = height-_padding*2;
    CGFloat realWidth = width - _padding * 2;
    CGFloat itemWidth = 0;
    if(_countShow > 0) {
        itemWidth = (realWidth - _sepWidth * (_countShow + 1)) / _countShow;
    } else if(itemWidth == 0) {
        itemWidth = itemHeight;
    }
    
    if(itemHeight > itemWidth) {
        itemHeight = itemWidth;
    } else if(itemHeight < itemWidth) {
        itemWidth = itemHeight;
    }
    
    return itemWidth;
}

- (void) setPadding:(CGFloat)padding {
    _padding = padding;
    [self updateViews];
}

- (void) setInfoWithImageArray:(NSMutableArray *)imgs {
    _contentArray = imgs;
    [self updateViews];
}


- (void) addImage:(UIImage *) img {
    [_contentArray addObject:img];
    [self updateViews];
}

- (void) onItemClicked:(id) sender {
    UIView * view = sender;
    NSLog(@"点击了按钮");
    if(_listener) {
        [_listener onItemClick:self subView:view];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _listener = listener;
}


@end
