//
//  FMSignView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/14.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "FMSignView.h"
#import "UIButton+Bootstrap.h"
#import "HBDrawingBoard.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "BaseBundle.h"

@interface FMSignView () <UIGestureRecognizerDelegate>

@property (readwrite, nonatomic, strong) UIView * controlView;
@property (readwrite, nonatomic, strong) UIButton * revokeBtn;  //撤销
@property (readwrite, nonatomic, strong) UIButton * cleanBtn;  //清除

@property (readwrite, nonatomic, strong) HBDrawingBoard * signView; //签字板

@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;

@property (readwrite, nonatomic, assign) BOOL isInited;


@end

@implementation FMSignView

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
        
        _btnHeight = 24;
        _btnWidth = 60;
        _controlHeight = _btnHeight + [FMSize getInstance].defaultPadding;
        
        _controlView = [[UIView alloc] init];
        _revokeBtn = [[UIButton alloc] init];
        _cleanBtn = [[UIButton alloc] init];
        
        _signView = [[HBDrawingBoard alloc] init];
        
        _controlView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        [_revokeBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        [_cleanBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        
        [_revokeBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT] forState:UIControlStateNormal];
        [_cleanBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT] forState:UIControlStateNormal];
        
        [_revokeBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_revoke" inTable:nil] forState:UIControlStateNormal];
        [_cleanBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_clean" inTable:nil] forState:UIControlStateNormal];
        
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actiondo:)];
        tapGesture.delegate = self;
        [_signView addGestureRecognizer:tapGesture];
        
        
//        UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actiondo:)];
//        panGesture.delegate = self;
//        [_signView addGestureRecognizer:panGesture];
        
        _signView.lineColor = [UIColor blackColor];
        _signView.lineWidth = 2.0f;
        
        [_revokeBtn addTarget:self action:@selector(onRevokeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_cleanBtn addTarget:self action:@selector(onCleanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setUserInteractionEnabled:YES];
        
        
        [_controlView addSubview:_revokeBtn];
        [_controlView addSubview:_cleanBtn];
        
        [self addSubview:_controlView];
        [self addSubview:_signView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat originY = 0;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    [_controlView setFrame:CGRectMake(0, 0, width, _controlHeight)];
    
    CGFloat originX = width - padding - _btnWidth;
    [_cleanBtn setFrame:CGRectMake(originX, (_controlHeight-_btnHeight)/2, _btnWidth, _btnHeight)];
    originX -= padding + _btnWidth;
    [_revokeBtn setFrame:CGRectMake(originX, (_controlHeight-_btnHeight)/2, _btnWidth, _btnHeight)];
    originY += _controlHeight;
    
    [_cleanBtn defaultStyle];
    [_revokeBtn defaultStyle];
    
    [_signView setFrame:CGRectMake(0, originY, width, height-_controlHeight)];
}

- (UIImage *) getSignImage {
    UIImage * img = [_signView getScreenImg];
    return img;
}

- (void) setShowBounds:(BOOL) show {
    if(show) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    } else {
        self.layer.borderWidth = 0;
    }
}


- (void) actiondo:(id) sender {
    //拦截触摸事件， 不需要写处理代码
    NSLog(@"点击了 FMSignView. ");
}

//点击撤销按钮
- (void) onRevokeButtonClicked:(id) sender {
    [_signView backToLastDraw];
}

//点击清除按钮
- (void) onCleanButtonClicked:(id) sender {
    [_signView clearAll];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
   NSLog(@"touchesMoved");
}
@end
