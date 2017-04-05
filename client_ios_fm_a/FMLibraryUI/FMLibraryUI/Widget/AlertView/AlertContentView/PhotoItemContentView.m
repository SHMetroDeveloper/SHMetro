//
//  PhotoItemContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "PhotoItemContentView.h"
#import "PhotoItemModel.h"
#import "ImageItemView.h"
#import "FMTheme.h"

@interface PhotoItemContentView () <OnClickListener>

@property (readwrite, nonatomic, strong) NSMutableArray * itemViewArray;

@property (readwrite, nonatomic, strong) NSMutableArray * models;

@property (readwrite, nonatomic, assign) CGFloat itemWidth;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat sepWidth;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;
@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation PhotoItemContentView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self updateViews];
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
        
        _itemViewArray = [[NSMutableArray alloc] init];
        _itemWidth = 80;
        _imgWidth = 55;
        _paddingTop = 26;
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
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
    NSInteger count = [_models count];
    
    CGFloat sepWidth = (width -_itemWidth * count) / (count + 1);
    if (count > 4) {
        sepWidth = (width -_itemWidth * 4) / (4 + 1);
    }
    CGFloat originX = sepWidth;
    CGFloat originY = _paddingTop;

    for(PhotoItemModel * model in _models) {
        ImageItemView * itemView = nil;
        if(index < [_itemViewArray count]) {
            itemView = _itemViewArray[index];
            [itemView setHidden:NO];
        } else {
            itemView = [[ImageItemView alloc] init];
            [itemView setLogoWidth:_imgWidth];
            [itemView setOnClickListener:self];
            [_itemViewArray addObject:itemView];
            [self addSubview:itemView];
        }
        
        itemView.tag = index;
        if (index > 3) {
            if (index%4 == 0) {
                originX = sepWidth;
                originY += _itemWidth + _paddingTop;
                [itemView setFrame:CGRectMake(originX, originY, _itemWidth, _itemWidth)];
                originX += _itemWidth + sepWidth;
            } else {
                [itemView setFrame:CGRectMake(originX, originY, _itemWidth, _itemWidth)];
                originX += _itemWidth + sepWidth;
            }
        } else {
//            [itemView setFrame:CGRectMake(originX, originY, _itemWidth, height-_paddingTop * 2)];
            [itemView setFrame:CGRectMake(originX, originY, _itemWidth, _itemWidth)];
            originX += _itemWidth + sepWidth;
        }
        
        [itemView setInfoWithName:model.name andLogo:model.img andHighlightLogo:model.imgHighlight];
        index++;
    }
    for(;index < [_itemViewArray count];index++) {
        ImageItemView * itemView = _itemViewArray[index];
        [itemView setHidden:YES];
    }
}

- (PhotoItemModel *) getModelByTag:(NSInteger) tag {
    PhotoItemModel * model = nil;
    if(tag >= 0 && tag < [_models count]) {
        model = _models[tag];
    }
    return model;
}

- (void) setInfoWith:(NSMutableArray *) array {
    _models = array;
    [self updateViews];
}

- (void) onClick:(UIView *)view {
    if(_listener) {
        [_listener onItemClick:self subView:view];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
}

+ (CGFloat) getContentHeightByModelCount:(NSInteger)count {
    CGFloat contentHeight = 0;
    CGFloat paddingTop = 26;
    CGFloat itemWidth = 80;
    
    NSInteger rowNumber = count/4;
    if (count%4 > 0) {
        rowNumber ++;
    }
    contentHeight = rowNumber*itemWidth + (rowNumber + 1)*paddingTop;
    
    return contentHeight;
}


@end
