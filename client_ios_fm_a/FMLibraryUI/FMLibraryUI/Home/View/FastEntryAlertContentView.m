//
//  FastEntryAlertContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "FastEntryAlertContentView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "ImageItemView.h"




@interface FastEntryAlertContentView () <OnClickListener>

@property (readwrite, nonatomic, strong) UIScrollView * contentContainerView;


@property (readwrite, nonatomic, strong) NSMutableArray * itemViewArray;    //
@property (readwrite, nonatomic, strong) NSMutableArray * itemArray;        //存储数据

@property (readwrite, nonatomic, assign) NSInteger column;  //每行展示的个数

@property (readwrite, nonatomic, assign) CGFloat itemWidth;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, assign) id<OnItemClickListener> listener;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation FastEntryAlertContentView

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
        
        _column = 3;
        _itemArray = [[NSMutableArray alloc] init];
        _itemViewArray = [[NSMutableArray alloc] init];
        
        _contentContainerView = [[UIScrollView alloc] init];
        
        _contentContainerView.delaysContentTouches = NO;
        
        [self addSubview:_contentContainerView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    _itemWidth = width * 1.0 / _column;
    _itemHeight = _itemWidth;
    
    [_contentContainerView setFrame:CGRectMake(0, 0, width, height)];
    
    NSInteger count = [_itemArray count];
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat sepHeight = padding;
    NSInteger index = 0;
    CGFloat originX = 0;
    
    if(count < _column) {
        originX = (width - _itemWidth * count)/2;
    }
    CGFloat originY = 100;
    CGFloat iconWidth = 60;
    BOOL newLine = NO;
    
    for(index=0; index<count; index++) {
        ImageItemView * itemView;
        FastEntryItem * item = _itemArray[index];
        if(index < [_itemViewArray count]) {
            itemView = _itemViewArray[index];
            [itemView setHidden:NO];
        } else {
            itemView = [[ImageItemView alloc] init];
            [itemView setLogoWidth:iconWidth];
            [itemView setOnClickListener:self];
            [_contentContainerView addSubview:itemView];
            [_itemViewArray addObject:itemView];
        }
        [itemView setFrame:CGRectMake(originX, originY, _itemWidth, _itemHeight)];
        [itemView setInfoWithName:item.name andLogo:item.icon andHighlightLogo:item.iconHighlight];
        itemView.tag = item.key;
        
        originX += _itemWidth;
        newLine = NO;
        if(originX + _itemWidth > width) {
            originY += _itemHeight + sepHeight;
            originX = 0;
            newLine = YES;
        }
    }
    if(count > 0 && !newLine) {
        originY += _itemHeight;
    }
    count = [_itemViewArray count];
    for(; index<count; index++) {
        ImageItemView * itemView = _itemViewArray[index];
        [itemView setHidden:YES];
    }
    
    _contentContainerView.contentSize = CGSizeMake(width, originY);
}



- (void) updateInfo {
    
}

- (void) addItemWith:(FastEntryItem *)item {
    [_itemArray addObject:item];
    [self updateViews];
}


- (void) setItemsWith:(NSMutableArray *) itemArray {
    _itemArray = itemArray;
    [self updateViews];
}

- (void) clearAllItems {
    if(_itemArray) {
        [_itemArray removeAllObjects];
        [self updateViews];
    }
}

- (void) onClick:(UIView *)view {
    if([view isKindOfClass:[ImageItemView class]]) {
        [self notifyItemClicked:view];
    }
}

- (void) onClicked:(id) sender {
    [self notifyItemClicked:nil];
}

- (void) notifyItemClicked:(UIView*) view {
    if(_listener) {
        [_listener onItemClick:self subView:view];
    }
}



- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:tapGesture];
    }
    _listener = listener;
}

@end
