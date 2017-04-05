//
//  FMGridImageView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/25.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "FMGridImageView.h"
#import "FMImageUnitView.h"
#import "FMTheme.h"

#define smallPhoneWidth 320   //5S的屏幕宽度为320

@interface FMGridImageView ()

@property (readwrite, nonatomic, strong) NSMutableArray * imagesArray;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat itemWidth;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@end

@implementation FMGridImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self initViews];
}

- (void) initViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if (width == 0 || height == 0) {
        return;
    }
    
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    _imagesArray = [[NSMutableArray alloc ] init];
    
    CGFloat x, y;
    CGFloat padding = 15;
    
    NSInteger column;
    if (_realWidth > smallPhoneWidth) {
        column = 4;
    } else {
        column = 3;
    }
    
    _itemWidth = (_realWidth - padding*(column+1))/column;
    _itemHeight = _itemWidth;
    
    for (int index = 0; index < column ; index++) {
        x = _itemWidth*(index) + padding*(index+1);
        y = padding;
        
        FMImageUnitView * imageUnitView = [[FMImageUnitView alloc] initWithFrame:CGRectMake(x, y, _itemWidth, _itemHeight)];
        imageUnitView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [self addSubview:imageUnitView];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [imageUnitView addGestureRecognizer:longPressRecognizer];
        
        imageUnitView.imageButton.tag = index;
        [imageUnitView.imageButton addTarget:self action:@selector(onClickImage:) forControlEvents:UIControlEventTouchUpInside];
        
        imageUnitView.deleteButton.tag = index;
        [imageUnitView.deleteButton addTarget:self action:@selector(onClickImageDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        imageUnitView.hidden = YES;
        
        [_imagesArray addObject:imageUnitView];
    }
}

- (void)layoutSubviews {
    CGFloat x, y;
    CGFloat padding = 15;
    NSInteger column;
    
    if (_realWidth > smallPhoneWidth) {
        column = 4;
    } else {
        column = 3;
    }
    for (int index = 0; index < column; index++) {
        x = _itemWidth*(index) + padding*(index+1);
        y = padding;
        FMImageUnitView * imageUnitView = [_imagesArray objectAtIndex:index];
        imageUnitView.frame = CGRectMake(x, y, _itemWidth, _itemHeight);
        imageUnitView.imageButton.frame = imageUnitView.bounds;
        imageUnitView.imageView.frame = imageUnitView.bounds;
    }
}

- (void)updateWithImages:(NSMutableArray *)images {
    for (FMImageUnitView * unit in _imagesArray) {
        unit.deleteButton.hidden = NO;
        unit.hidden = YES;
    }
    
    if (!images || images.count == 0) {      //如果没有照片则显示一个添加照片式样
        FMImageUnitView * imageUnitView = [_imagesArray objectAtIndex:0];
        imageUnitView.hidden = NO;
        imageUnitView.imageView.contentMode = UIViewContentModeScaleToFill;
        imageUnitView.imageView.image = [[FMTheme getInstance] getImageByName:@"photoAdd"];
        imageUnitView.deleteButton.hidden = YES;
    } else {        //包含图片的时候
        for (int i = 0; i < _imagesArray.count; i++) {
            FMImageUnitView * imageUnitView = [_imagesArray objectAtIndex:i];
            if (i < images.count){
                imageUnitView.hidden = NO;
                imageUnitView.imageView.image = [images objectAtIndex:i];
            }
            if ((i == (_imagesArray.count-1)) && (images.count >= _imagesArray.count)) {
                imageUnitView.hidden = NO;
                imageUnitView.imageView.contentMode = UIViewContentModeScaleToFill;
                imageUnitView.imageView.image = [[FMTheme getInstance] getImageByName:@"photoAdd"];
                imageUnitView.deleteButton.hidden = YES;
            }
        }
        if (images.count < _imagesArray.count) {
            FMImageUnitView * imageUnitView = [_imagesArray objectAtIndex:(images.count)];
            imageUnitView.hidden = NO;
            imageUnitView.imageView.contentMode = UIViewContentModeScaleToFill;
            imageUnitView.imageView.image = [[FMTheme getInstance] getImageByName:@"photoAdd"];
            imageUnitView.deleteButton.hidden = YES;
        }
    }
}

- (void) onClickImage:(UIView *) sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onClick:)]) {
        [_delegate onClick:sender.tag];
    }
}

- (void) onClickImageDelete:(UIView *) sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onDeleteClikc:)]) {
        [_delegate onDeleteClikc:sender.tag];
    }
}

-(void) onLongPress:(UILongPressGestureRecognizer *) recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan){
        FMImageUnitView *view = (FMImageUnitView *)recognizer.view;
        if (_delegate && [_delegate respondsToSelector:@selector(onLongPress:)]) {
            [_delegate onLongPress:view.imageButton.tag];
        }
    }
}



+ (CGFloat) getHeightBymaxWidth:(CGFloat) maxWidth {
    CGFloat realheigth = 0;
    CGFloat itemWidth;
    CGFloat itemHeight;
    CGFloat padding = 20;
    
    if (maxWidth > 320) {
        itemWidth = (maxWidth - padding*5)/4;
        itemHeight = itemWidth;
        realheigth = itemHeight + (padding)*2;
    } else {
        itemWidth = (maxWidth - padding*4)/3;
        itemHeight = itemWidth;
        realheigth = itemHeight + (padding)*2;
    }
    return realheigth;
}

@end










