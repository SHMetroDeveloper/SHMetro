//
//  DAPagesContainerTopBar.m
//  DAPagesContainerScrollView
//
//  Created by Daria Kopaliani on 5/29/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAPagesContainerTopBar.h"
#import "FMTheme.h"


@interface DAPagesContainerTopBar ()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *itemViews;
@property (strong, nonatomic) NSArray *indicatorViews;


- (void)layoutItemViews;

@end


@implementation DAPagesContainerTopBar

CGFloat const DAPagesContainerTopBarItemViewWidth = 100.;
CGFloat const DAPagesContainerTopBarItemsOffset = 30.;

CGFloat const DAPagesContainerTopBarIndicatorWidth = 1.;
CGFloat const DAPagesContainerTopBarIndicatorOffset = 8;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.indicatorColor = [UIColor blackColor];
        self.itemSelectedColor = [UIColor colorWithRed:3/255.0 green:121/255.0 blue:254/255.0 alpha:100];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        self.font = [UIFont systemFontOfSize:14];
        self.itemTitleColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Public

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index
{
    CGPoint center = ((UIView *)self.itemViews[index]).center;
    CGPoint offset = [self contentOffsetForSelectedItemAtIndex:index];
    center.x -= offset.x - (CGRectGetMinX(self.scrollView.frame));
    return center;
}

- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index
{
    if (self.itemViews.count < index || self.itemViews.count == 1) {
        return CGPointZero;
    } else {
        CGFloat totalOffset = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame);
        return CGPointMake(index * totalOffset / (self.itemViews.count - 1) - DAPagesContainerTopBarIndicatorWidth, 0.);
//        CGFloat offset = 0;
//        for(NSInteger i = 0;i<index && i < self.itemViews.count;i++) {
//            CGRect rec = ((UIView *)self.itemViews[index]).frame;
//            offset += CGRectGetWidth(rec);
//            if(i<self.indicatorViews.count) {
//                offset += CGRectGetWidth(((UILabel *)self.indicatorViews[i]).frame);
//            }
//        }
//        return CGPointMake(offset, 0);
    }
}

- (CGFloat) getItemWidthAtIndex:(NSUInteger)index {
    CGFloat width = 0;
    if(index < self.itemViews.count) {
        width = ((UIView *)self.itemViews[index]).frame.size.width;
    }
    return width;
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor
{
    if (![_itemTitleColor isEqual:itemTitleColor]) {
        _itemTitleColor = itemTitleColor;
        for (UIButton *button in self.itemViews) {
            [button setTitleColor:itemTitleColor forState:UIControlStateNormal];
        }
    }
}

#pragma mark * Overwritten setters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundImageView.image = backgroundImage;
}

- (void)setItemTitles:(NSArray *)itemTitles
{
    if (_itemTitles != itemTitles) {
        _itemTitles = itemTitles;
        NSMutableArray *mutableItemViews = [NSMutableArray arrayWithCapacity:itemTitles.count];
        NSMutableArray *mutableIndicatorViews = [NSMutableArray arrayWithCapacity:itemTitles.count-1];
        for (NSUInteger i = 0; i < itemTitles.count; i++) {
            UIButton *itemView = [self addItemView];
            [itemView setTitle:itemTitles[i] forState:UIControlStateNormal];
            [mutableItemViews addObject:itemView];
            if(i<itemTitles.count-1) {
                UILabel * indicatorView = [self addIndicatorView];
                if(indicatorView) {
                    [mutableIndicatorViews addObject:indicatorView];
                }
            }
        }
        self.itemViews = [NSArray arrayWithArray:mutableItemViews];
        self.indicatorViews = [NSArray arrayWithArray:mutableIndicatorViews];
        [self layoutItemViews];
    }
}

- (void)setFont:(UIFont *)font
{
    if (![_font isEqual:font]) {
        _font = font;
        for (UIButton *itemView in self.itemViews) {
            [itemView.titleLabel setFont:font];
        }
    }
}

#pragma mark - Private

- (UIButton *)addItemView
{
    CGFloat width = [self getTopBarItemWidth];
//    width = DAPagesContainerTopBarItemViewWidth;
    CGRect frame = CGRectMake(0., 0., width, CGRectGetHeight(self.frame));
    UIButton *itemView = [[UIButton alloc] initWithFrame:frame];
    [itemView addTarget:self action:@selector(itemViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    itemView.titleLabel.font = self.font;
    [itemView setTitleColor:self.itemTitleColor forState:UIControlStateNormal];
    [self.scrollView addSubview:itemView];
    return itemView;
}

- (UILabel *) addIndicatorView {
    CGFloat height = CGRectGetHeight(self.frame) - DAPagesContainerTopBarIndicatorOffset * 2;
    CGRect frame = CGRectMake(0, DAPagesContainerTopBarIndicatorOffset, DAPagesContainerTopBarIndicatorWidth, height);
    
    UILabel * indicatorView = [[UILabel alloc] initWithFrame:frame];
    [indicatorView setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L8]];
    [self.scrollView addSubview:indicatorView];
    return indicatorView;
}

- (void)itemViewTapped:(UIButton *)sender
{
//    [sender setBackgroundColor: self.itemSelectedColor];
    [self.delegate itemAtIndex:[self.itemViews indexOfObject:sender] didSelectInPagesContainerTopBar:self];
    
    
}

- (CGFloat) getTopBarItemWidth {
    CGFloat width = 0;
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    NSInteger itemCount = [self.itemTitles count];
    if(itemCount > 3) {
        itemCount = 3;
    }
    width = (frameWidth - DAPagesContainerTopBarIndicatorWidth * (itemCount-1)) / itemCount;
    
    return width;
}

- (void)layoutItemViews
{
    CGFloat x = DAPagesContainerTopBarItemsOffset;
    x = 0;
    
    for (NSUInteger i = 0; i < self.itemViews.count; i++) {
        CGFloat width = [self.itemTitles[i] sizeWithFont:self.font].width;
        CGFloat minWidth = [self getTopBarItemWidth];
        if(width<minWidth) {
            width = minWidth;
        }
        UIView *itemView = self.itemViews[i];
        itemView.frame = CGRectMake(x, 0., width, CGRectGetHeight(self.frame));
//        x += width + DAPagesContainerTopBarItemsOffset;
        x += width;
        if(i < self.indicatorViews.count) {
            UILabel *indicatorView = self.indicatorViews[i];
            indicatorView.frame = CGRectMake(x, DAPagesContainerTopBarIndicatorOffset, DAPagesContainerTopBarIndicatorWidth, CGRectGetHeight(self.frame) - DAPagesContainerTopBarIndicatorOffset*2);
            x += DAPagesContainerTopBarIndicatorWidth;
        }
    }
    self.scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.scrollView.frame));
    CGRect frame = self.scrollView.frame;
    
//    if (CGRectGetWidth(self.frame) > x) {
//        frame.origin.x = (CGRectGetWidth(self.frame) - x) / 2.;
//        frame.size.width = x;
//    } else {
        frame.origin.x = 0.;
        frame.size.width = CGRectGetWidth(self.frame);
//    }
    self.scrollView.frame = frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutItemViews];
}

#pragma mark * Lazy getters

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:_backgroundImageView belowSubview:self.scrollView];
    }
    return _backgroundImageView;
}

@end