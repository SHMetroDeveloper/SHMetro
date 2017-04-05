

#import "ResizeableViewGroup.h"
#import "SeperatorView.h"
#import "FMUtils.h"
#import "FMTheme.h"



@interface ResizeableViewGroup ()

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingRight;  //文本框到右边界的距离宽度
@property (readwrite, nonatomic, assign) CGFloat paddingTop;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;  //文本框到右边界的距离宽度

//@property (readwrite, nonatomic, strong) UILabel * seperator;   //上下 view 之间的分割线

@property (readwrite, nonatomic, assign) BOOL showSeperator;
@property (readwrite, nonatomic, assign) BOOL showBounds;

@end

@implementation ResizeableViewGroup

- (instancetype) init {
    self = [super init];
    if(self) {
        _paddingLeft = 5;       //默认左边距为 5
        _paddingRight = 5;      //默认右边距为 5
        _paddingTop = 5;        //默认上边距
        _paddingBottom = 5;     //默认下边距
        
        _showSeperator = YES;
        _showBounds = YES;
        
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        _paddingLeft = 5;       //默认左边距为 5
        _paddingRight = 5;      //默认右边距为 5
        _paddingTop = 5;        //默认上边距
        _paddingBottom = 5;     //默认下边距
        
        _showSeperator = YES;
        _showBounds = YES;
        
        //        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        
        [self updateBounds];
        [self updateSubviews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateBounds];
    [self updateSubviews];
}

- (void) updateBounds {
    if(_showBounds) {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
    } else {
        self.layer.borderWidth = 0;
    }
}

- (void) updateSubviews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat originX = _paddingLeft;
    CGFloat originY = _paddingTop;
    CGFloat sepHeight = 0;
    
    NSInteger i = 0;
    NSArray * subViews = [self subviews];
    for(UIView * view in subViews) {      //重新添加
        if([view isKindOfClass:[ResizeableView class]]) {
            ResizeableView * rView = (ResizeableView *) view;
            CGFloat rheight = [rView getCurrentHeight];
            CGRect rFrame = CGRectMake(originX, originY, width-_paddingLeft-_paddingRight, rheight);
            originY += rheight;
            [rView setFrame:rFrame];
        } else if([view isKindOfClass:[SeperatorView class]]){
            if(_showSeperator) {
                [view setHidden:NO];
                CGRect sFrame = view.frame;
                sFrame.origin.x = originX;
                sFrame.origin.y = originY;
                view.frame = sFrame;
            } else {
                [view setHidden:YES];
            }
        } else {
            CGRect sFrame = view.frame;
            sFrame.origin.x = originX;
            sFrame.origin.y = originY;
            view.frame = sFrame;
        }
    }
}


- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom {
    _paddingLeft = left;
    _paddingRight = right;
    _paddingTop = top;
    _paddingBottom = bottom;
    [self updateSubviews];
}



- (CGFloat) getCurrentHeight {
    CGFloat inputHeight = 0;
    
    inputHeight += _paddingTop + _paddingBottom;
    return inputHeight;
}

- (void) addSubview:(UIView *) view {
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    if(_showSeperator) {
        NSInteger count = [[self subviews] count];
        if(count > 0) {
            SeperatorView * sepView = [[SeperatorView alloc] initWithFrame:CGRectMake(_paddingLeft, 0, width-_paddingLeft-_paddingRight, 1)];
            [sepView setBackgroundColor:[UIColor colorWithRed:0xe9/255.0 green:0xe9/255.0 blue:0xe9/255.0 alpha:1.0f]];
            [super addSubview:sepView];
        }
        height += 1;
    }
    if([view isKindOfClass:[ResizeableView class]]) {
        ResizeableView * rView = (ResizeableView*)view;
        [rView setOnViewResizeListener:self];
        height += [rView getCurrentHeight];
    } else {
        height += CGRectGetHeight(view.frame);
    }
    
    [super addSubview:view];
    [self updateSubviews];
    if(self.resizeListener) {
        [self.resizeListener onViewSizeChanged:self newSize:CGSizeMake(width, height)];
    }
}



- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if([view isKindOfClass:[ResizeableView class]]) {
        CGRect frame = view.frame;
        if(frame.size.width != newSize.width || frame.size.height != newSize.height) {
            CGFloat height = self.frame.size.height - frame.size.height + newSize.height;
            CGFloat width = self.frame.size.width;
            frame.size = newSize;
            view.frame = frame;
            
            [self updateSubviews];
            //
            if(self.resizeListener) {
                [self.resizeListener onViewSizeChanged:self newSize:CGSizeMake(width, height)];
            }
        }
        
    }
}

@end
