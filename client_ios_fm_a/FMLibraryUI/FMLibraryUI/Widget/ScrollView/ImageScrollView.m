//
//  ImageScrollView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/10.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ImageScrollView.h"
#import "FMSize.h"

@interface ImageScrollView () <UIScrollViewDelegate>

@property (readwrite, nonatomic, strong) UIPageControl * pageControl;
@property (readwrite, nonatomic, strong) UIScrollView * imgContainerView;

@property (readwrite, nonatomic, strong) NSMutableArray * imgViewArray; //存储ImageView,便于资源重用

@property (readwrite, nonatomic, strong) NSMutableArray * imgArray; //存储Image

@property (readwrite, nonatomic, assign) NSInteger currentImgIndex; //当前展示的 Image 序号

@property (readwrite, nonatomic, assign) CGFloat imgWidth;  //
@property (readwrite, nonatomic, assign) CGFloat imgHeight;

@property (readwrite, nonatomic, assign) CGFloat controlWidth;  //
@property (readwrite, nonatomic, assign) CGFloat controlHeight;

@property (readwrite, nonatomic, strong) NSTimer * timer;
@property (readwrite, nonatomic, assign) CGFloat timeDelay;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation ImageScrollView

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
        
        _controlWidth = 0;
        _controlHeight = 20;
        _timeDelay = 3;
        
        _currentImgIndex = 0;
        _imgArray = [[NSMutableArray alloc] init];
        _imgViewArray = [[NSMutableArray alloc] init];
        
        _imgContainerView = [[UIScrollView alloc] init];
        _imgContainerView.pagingEnabled = YES;  //按页展示
        _imgContainerView.showsHorizontalScrollIndicator = NO;
        _imgContainerView.delegate = self;
        
        
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_imgContainerView];
        [self addSubview:_pageControl];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    if(width == 0 || height == 0) {
        return;
    }
        _imgWidth = width;
        _imgHeight = height;
    
    _controlWidth = [self getControlWidth];
    [_imgContainerView setFrame:CGRectMake(0, 0, width, height)];
    [_pageControl setFrame:CGRectMake(width - _controlWidth - padding, height-_controlHeight, _controlWidth, _controlHeight)];
    
    CGFloat originX = 0;
    NSInteger index = 0;
    NSInteger count = [self getImageCount];
    _pageControl.numberOfPages = count;
    _pageControl.currentPage = _currentImgIndex;
    
    for(index=0;index<count;index++) {
        UIImage * img = [self getImageBy:index];
        UIImageView * imgView;
        if(index < [_imgViewArray count]) {
            imgView = _imgViewArray[index];
            [imgView setHidden:NO];
        }
        if(!imgView) {
            imgView = [[UIImageView alloc] init];
            [_imgViewArray addObject:imgView];
            [_imgContainerView addSubview:imgView];
        }
        [imgView setFrame:CGRectMake(originX, 0, _imgWidth, _imgHeight)];
        
        [imgView setImage:img];
        originX += _imgWidth;
    }
    _imgContainerView.contentSize = CGSizeMake(originX, _imgHeight);
    count = [_imgViewArray count];  //把多余的View 隐藏起来
    for(;index<count;index++) {
        UIImageView * imgView = _imgViewArray[index];
        [imgView setHidden:YES];
    }
}

- (void) initTimer {
    if(!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeDelay target:self selector:@selector(showNextPage) userInfo:nil repeats:YES];
    }
}
              
- (void) showNextPage {
    _currentImgIndex++;
    if(_currentImgIndex == [self getImageCount]) {
        _currentImgIndex = 0;
    }
    [self updatePage];
}

//根据当前 Page 值更新视图
- (void) updatePage {
    CGFloat originX = _imgWidth * _currentImgIndex;
    CGRect frame = CGRectMake(originX, 0, _imgWidth, _imgHeight);
    [_imgContainerView scrollRectToVisible:frame animated:YES];
}

- (CGFloat) getControlWidth {
    CGFloat width = 16 * [self getImageCount];
    return width;
}

//获取待展示的图片数量
- (NSInteger) getImageCount {
    return [_imgArray count];
}

//获取指定位置需要展示的图片
- (UIImage *) getImageBy:(NSInteger) index {
    UIImage * img;
    if(index >= 0 && index < [self getImageCount]) {
        img = _imgArray[index];
    }
    return img;
}

//
- (void) start {
    [self initTimer];
}

- (void) stop {
    [_timer invalidate];
    _timer = nil;
}

- (void) setImages:(NSMutableArray *) images {
    _imgArray = images;
    [self updateViews];
}
- (void) addImage:(UIImage *) image {
    [_imgArray addObject:image];
    [self updateViews];
}
- (void) clearAllImage {
    [_imgArray removeAllObjects];
    [self updateViews];
}

-(void)pageChanged:(id)sender{
    UIPageControl* control = (UIPageControl*)sender;
    _currentImgIndex = control.currentPage;
    [self updatePage];
}

#pragma --- scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"滚动结束");
    CGFloat pageWidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _currentImgIndex = currentPage;
    _pageControl.currentPage = _currentImgIndex;
}

@end
