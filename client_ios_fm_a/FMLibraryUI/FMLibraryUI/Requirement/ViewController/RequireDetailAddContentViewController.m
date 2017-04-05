//
//  RequireDetailAddContentViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/26.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequireDetailAddContentViewController.h"
#import "UIButton+Bootstrap.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseTextView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseBundle.h"


@interface RequireDetailAddContentViewController ()

@property(readwrite,nonatomic,strong) BaseTextView * mContentView;

//@property(readwrite,nonatomic,strong) UIButton * mOKBtn;
//@property(readwrite,nonatomic,strong) UIView * controlView;


@property(nonatomic,strong) NSString * content;

@property(readwrite,nonatomic,assign) CGFloat minContentHeight;
@property(readwrite,nonatomic,assign) CGFloat controlHeight;
@property(readwrite,nonatomic,assign) CGFloat paddingLeft;

@property(readwrite,nonatomic,assign) CGFloat realWidth;
@property(readwrite,nonatomic,assign) CGFloat realHeight;

@property(readwrite,nonatomic,strong) UIView * mainContainerView;
@property(readwrite,nonatomic,strong) UIScrollView * mainContentView;
@property(readwrite,nonatomic,strong) id<OnMessageHandleListener> resultHandler;
@end

@implementation RequireDetailAddContentViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void) initViews {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    CGFloat originY = 10;
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    
    _mainContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight-_controlHeight)];
    _mainContentView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    _mContentView = [[BaseTextView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _minContentHeight)];
    [_mContentView setMaxTextLength:1000];
    _mContentView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    [_mContentView setTopDesc:[[BaseBundle getInstance] getStringByKey:@"requirement_content_placeholder" inTable:nil]];
    
    CGRect controlFrame = CGRectMake(0, _realHeight-_controlHeight, _realWidth, _controlHeight);
    
//    _controlView = [[UIView alloc] initWithFrame:controlFrame];
//    _controlView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
//    
//    _mOKBtn = [[UIButton alloc] initWithFrame:CGRectMake(_paddingLeft, originY/2, _realWidth-_paddingLeft*2, _controlHeight- originY)];
//    
//    
//    [_mOKBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil] forState:UIControlStateNormal];
//    [_mOKBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK] forState:UIControlStateNormal];
//    
//    [_mOKBtn primaryStyle];
//    [_mOKBtn addTarget:self action:@selector(finishEditing) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_controlView addSubview:_mOKBtn];
    
    [_mContentView becomeFirstResponder];
    [_mContentView setOnViewResizeListener:self];
    [_mContentView setShowBounds:YES];
    [_mContentView setMinHeight:_minContentHeight];
    [_mContentView becomeFirstResponder];
    
    [_mainContentView addSubview:_mContentView];
    
    [_mainContainerView addSubview:_mainContentView];
//    [_mainContainerView addSubview:_controlView];
    
    
    [self.view addSubview:_mainContainerView];
    
    [self updateViews];
}

- (void) updateViews {
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat originY = 10;
    CGFloat itemHeight = CGRectGetHeight(_mContentView.frame);
    [_mContentView setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    _mainContentView.contentSize = CGSizeMake(width, originY);
}

- (void) viewDidLoad {
    [super viewDidLoad];
    _paddingLeft = [FMSize getInstance].defaultPadding;
    _controlHeight = 0;
    _minContentHeight = 150;
    
    [self initViews];
    [self updateInfo];
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_requirement_content" inTable:nil]];
    [self setBackAble:YES];
    NSArray * menuTextArray = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil], nil];
    [self setMenuWithArray:menuTextArray];
}


- (void) onMenuItemClicked:(NSInteger)position {
    [self finishEditing];
}


- (void) setContent:(NSString *) content {
    _content = content;
    [self updateInfo];
    
}

- (void) updateInfo {
    [_mContentView setContentWith:_content];
}


- (void) finishEditing {
    [self handleResult];
    [self finish];
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _mContentView) {
        CGRect frame = view.frame;
        frame.size = newSize;
        view.frame = frame;
        [self updateViews];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _resultHandler = handler;
}

- (void) handleResult {
    if(_resultHandler) {
        NSString* result = [_mContentView getContent];
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:@"RequireDetailAddContentViewController" forKeyPath:@"msgOrigin"];
        [msg setValue:result forKeyPath:@"result"];
        [_resultHandler handleMessage:msg];
    }
}


- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
            CGRect frame = [self getContentFrame];
            frame.size.height = _realHeight  -keyboardSize.height;
            _mainContainerView.frame = frame;
            [_mainContentView setFrame:CGRectMake(0, 0, _realWidth, frame.size.height-_controlHeight)];
//            [_controlView setFrame:CGRectMake(0, frame.size.height-_controlHeight, _realWidth, _controlHeight)];
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
        CGRect frame = [self getContentFrame];
        _mainContainerView.frame = frame;
        [_mainContentView setFrame:CGRectMake(0, 0, _realWidth, frame.size.height-_controlHeight)];
//        [_controlView setFrame:CGRectMake(0, frame.size.height-_controlHeight, _realWidth, _controlHeight)];
    }];
}


@end


