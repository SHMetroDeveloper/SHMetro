//
//  TaskAlertView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/24.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "TaskAlertView.h"
#import "FMTheme.h"


@interface TaskAlertView () <UIGestureRecognizerDelegate>

@property (readwrite, nonatomic, strong) UIView * containerView;
@property (readwrite, nonatomic, strong) NSMutableDictionary * contentViewArray;
@property (readwrite, nonatomic, strong) NSMutableDictionary * contentViewHeightArray;
@property (readwrite, nonatomic, strong) NSString * curType;


@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat contentHeight;
@property (readwrite, nonatomic, assign) AlertContentPosition contentPosition;



@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, strong) CAGradientLayer * gradientLayer;

@property (readwrite, nonatomic, weak) id<OnClickListener> listener;

@end

@implementation TaskAlertView

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
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        _containerView = [[UIView alloc] init];
        
        _contentViewArray = [[NSMutableDictionary alloc] init];
        _contentViewHeightArray = [[NSMutableDictionary alloc] init];
        
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicked:)];
        tapGesture.delegate = self;
        
        [self addGestureRecognizer:tapGesture];
        
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
    if(CGRectGetHeight(_containerView.frame) == 0) {    //初始位置是在屏幕下方，为显示动画做准备
        [_containerView setFrame:CGRectMake(0, height, width, height)];
    }
    NSArray * keys = [_contentViewArray allKeys];
    NSInteger index = 0;
    NSInteger count = [keys count];
    if(_gradientLayer) {
        [_gradientLayer setFrame:CGRectMake(0, 0, width, height)];
    }
    for(index = 0;index < count;index++) {
        NSString * key = keys[index];
        id item = [_contentViewArray valueForKey:key];
        id itemHeight = [_contentViewHeightArray valueForKey:key];
        UIView * contentView = item;
        CGFloat contentHeight = [itemHeight floatValue];
        if([key isEqualToString:_curType]) {    //需要显示的 contentView
            if(contentHeight == 0) {
                [contentView setFrame:CGRectMake(_padding, 0, width-_padding*2, height)];
            } else {
                switch (_contentPosition) {
                    case ALERT_CONTENT_POSITION_TOP:
                        [contentView setFrame:CGRectMake(_padding, 0, width-_padding*2, contentHeight)];
                        break;
                        
                    default:
                        [contentView setFrame:CGRectMake(_padding, height-contentHeight, width-_padding*2, contentHeight)];
                        break;
                }
                
            }
            
            [contentView setHidden:NO];
        } else {                                //隐藏多余的
            [contentView setHidden:YES];
        }
    }
}

- (void) updateInfo {

}

- (void) setContentView:(UIView *) contentView withKey:(NSString *) key {
    if(contentView) {
        id obj = [_contentViewArray valueForKeyPath:key];
        if(!obj) {
            [_containerView addSubview:contentView];
        } else {
            UIView * oldView = obj;
            [oldView removeFromSuperview];
        }
        CGRect frame = self.frame;
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        [contentView setFrame:CGRectMake(0, 0, width, height)];
        [_contentViewArray setValue:contentView forKeyPath:key];
    }
    
}

- (void) setContentView:(UIView *) contentView withKey:(NSString *) key andPadding:(CGFloat)padding andHeight:(CGFloat)height {
    _padding = padding;

    
    if(contentView) {
        id obj = [_contentViewArray valueForKeyPath:key];
        if(!obj) {
            [_containerView addSubview:contentView];
        } else {
            UIView * oldView = obj;
            [oldView removeFromSuperview];
        }
        CGRect frame = self.frame;
        CGFloat width = CGRectGetWidth(frame);
        CGFloat realheight = CGRectGetHeight(frame);
        [contentView setFrame:CGRectMake(padding, realheight-height, width, height)];
        [_contentViewArray setValue:contentView forKeyPath:key];
        [_contentViewHeightArray setValue:[NSNumber numberWithFloat:height] forKey:key];
    }
    
}

- (void) setContentView:(UIView *) contentView withKey:(NSString *) key andHeight:(CGFloat)height andPosition:(AlertContentPosition) position {
    _contentPosition = position;
    
    
    if(contentView) {
        id obj = [_contentViewArray valueForKeyPath:key];
        if(!obj) {
            [_containerView addSubview:contentView];
        } else {
            UIView * oldView = obj;
            [oldView removeFromSuperview];
        }
        CGRect frame = self.frame;
        CGFloat width = CGRectGetWidth(frame);
        CGFloat realheight = CGRectGetHeight(frame);
        switch (_contentPosition) {
            case ALERT_CONTENT_POSITION_TOP:
                [contentView setFrame:CGRectMake(0, 0, width, height)];
                break;
                
            default:
                [contentView setFrame:CGRectMake(0, realheight-height, width, height)];
                break;
                
        }
        
        [_contentViewArray setValue:contentView forKeyPath:key];
        [_contentViewHeightArray setValue:[NSNumber numberWithFloat:height] forKeyPath:key];
    }
    
}

- (void) setContentHeight:(CGFloat) height withKey:(NSString *) key {
    [_contentViewHeightArray setValue:[NSNumber numberWithFloat:height] forKeyPath:key];
}

- (void) removeContentViewByKey:(NSString *) key {
    id obj = [_contentViewArray valueForKeyPath:key];
    if(obj) {
        if([obj isKindOfClass:[UIView class]]) {
            UIView * view = obj;
            [view removeFromSuperview];
        }
        [_contentViewArray removeObjectForKey:key];
        [_contentViewHeightArray removeObjectForKey:key];
    }
    
}


- (void) showType:(NSString *) key {
    _curType = [key copy];
    [self performSelectorOnMainThread:@selector(updateViews) withObject:nil waitUntilDone:NO];
}

//设置是否显示渐变色背景
- (void) setShowGradientBackground:(BOOL) showGradient {
    if(showGradient) {
        if(!_gradientLayer) {
            _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
            _gradientLayer.bounds = self.bounds;
            _gradientLayer.borderWidth = 0;
            
            _gradientLayer.frame = self.bounds;
            _gradientLayer.colors = [NSArray arrayWithObjects:
                                     (id)[[UIColor whiteColor] CGColor],
                                     (id)[[UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:0.3] CGColor],  nil];
            _gradientLayer.startPoint = CGPointMake(0, 0);
            _gradientLayer.endPoint = CGPointMake(0, 1);
            
            [self.layer insertSublayer:_gradientLayer atIndex:0];
        } else {
            if(_gradientLayer) {
                [_gradientLayer removeFromSuperlayer];
                _gradientLayer = nil;
            }
        }
    }
}

//显示---按屏幕的尺寸来计算的
- (void) show {
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:0
                     animations:^{
                         [_containerView setFrame:CGRectMake(0, 0, width, height)];
                     }
                     completion:^(BOOL finished) {
                     }];
}

//移动到顶部显示，用于键盘出现的时候
- (void) moveToTopWithHeight:(CGFloat) moveHeight andPadding:(CGFloat) paddingTop {
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    [self setHidden:NO];
    
    UIView * contentView = [_contentViewArray valueForKeyPath:_curType];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:0
                     animations:^{
                         [_containerView setFrame:CGRectMake(0, -moveHeight, width, height)];
                         [contentView setFrame:CGRectMake(0, moveHeight+paddingTop, width, height-moveHeight-paddingTop)];
                     }
                     completion:^(BOOL finished) {
                     }];
}

//用于键盘出现的时候向上移动,保持高度不变
- (void) moveUp:(CGFloat) moveHeight {
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    [self setHidden:NO];
    
    UIView * contentView = [_contentViewArray valueForKeyPath:_curType];
    CGFloat contentHeight = [[_contentViewHeightArray valueForKeyPath:_curType] floatValue];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:0
                     animations:^{
                         [_containerView setFrame:CGRectMake(0, -moveHeight, width, height)];
                         [contentView setFrame:CGRectMake(0, height-contentHeight, width, contentHeight)];
                     }
                     completion:^(BOOL finished) {
                     }];
}

//移动到顶部显示，用于键盘隐藏的时候
- (void) reset {
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    [self setHidden:NO];
    UIView * contentView = [_contentViewArray valueForKeyPath:_curType];
    CGFloat contentHeight = [[_contentViewHeightArray valueForKeyPath:_curType] floatValue];
    CGFloat statusBarHeight = 20;
    if(contentHeight == 0) {
        contentHeight = height - statusBarHeight;
    }
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:0
                     animations:^{
                         [_containerView setFrame:CGRectMake(0, 0, width, height)];
                         [contentView setFrame:CGRectMake(0, height-contentHeight, width, contentHeight)];
                     }
                     completion:^(BOOL finished) {
                     }];
}


//关闭
- (void) close {
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if (firstResponder) {
        [firstResponder resignFirstResponder];
    }
    
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:0
                     animations:^{
                         [_containerView setFrame:CGRectMake(0, height, width, height)];
                     }
                     completion:^(BOOL finished) {
                         [self setHidden:YES];
                     }];
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    _listener = listener;
}

- (void) onClicked:(id) sender {
    NSLog(@"点击了 alert View");
    if(_listener) {
        [_listener onClick:self];
    }
}

#pragma mark - gesture delegate 
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL res = NO;
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        res =  NO;
    } else {
        res = YES;
    }
    return res;
}

@end
