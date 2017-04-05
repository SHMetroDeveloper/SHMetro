//
//  QuestionEditViewController.m
//
//
//  Created by 杨帆 on 28/4/14.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "QuestionEditViewController.h"
#import "UIButton+Bootstrap.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BaseTextView.h"
#import "InfoSelectViewController.h"


@interface QuestionEditViewController ()

@property (readwrite, nonatomic, assign) NSInteger mTag;

@property (readwrite, nonatomic, strong) BaseTextView * mContentView;
@property (readwrite, nonatomic, strong) UIButton * abnormalBtn;
@property (readwrite, nonatomic, strong) UIView * controlView;

@property(readwrite,nonatomic,strong) NSString * content;
@property(readwrite,nonatomic,assign) CGFloat minContentHeight;
@property(readwrite,nonatomic,assign) CGFloat controlHeight;
@property(readwrite,nonatomic,assign) CGFloat paddingLeft;

@property(readwrite,nonatomic,assign) CGFloat realWidth;
@property(readwrite,nonatomic,assign) CGFloat realHeight;

@property(readwrite,nonatomic,strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) NSString * exceptions; //常见异常


@property (readwrite, nonatomic, strong) id<OnQuestionEditFinishedListener> listener;

@end

@implementation QuestionEditViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) initViews {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    CGFloat sepHeight = [FMSize getInstance].padding30;
    CGFloat originX = 0;
    CGFloat originY = sepHeight;
    CGFloat padding = [FMSize getInstance].padding50;
    
    _controlHeight = [FMSize getSizeByPixel:144];
    _abnormalBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, _controlHeight)];
    _abnormalBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_abnormalBtn addTarget:self action:@selector(gotoSelectExceptions) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.font = [FMFont getInstance].font44;
    titleLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = [[BaseBundle getInstance] getStringByKey:@"patrol_exception_common" inTable:nil];
    CGSize titleSize = [FMUtils getLabelSizeBy:titleLabel andContent:titleLabel.text andMaxLabelWidth:_realWidth];
    [titleLabel setFrame:CGRectMake(padding, (_controlHeight-titleSize.height)/2, titleSize.width, titleSize.height)];
    
    CGFloat imgWidth = [FMSize getInstance].imgWidthLevel3;
    UIImageView * moreImg = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
    [moreImg setFrame:CGRectMake(_realWidth-imgWidth-padding, (_controlHeight-imgWidth)/2, imgWidth, imgWidth)];
    
    [_abnormalBtn addSubview:titleLabel];
    [_abnormalBtn addSubview:moreImg];
    
    originY += sepHeight + _controlHeight;
    
    
    
    _mContentView = [[BaseTextView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _minContentHeight)];
    [_mContentView setTopDesc:[[BaseBundle getInstance] getStringByKey:@"patrol_exception_place_holder" inTable:nil]];
    _mContentView.backgroundColor = [UIColor whiteColor];
    [_mContentView setOnViewResizeListener:self];
    [_mContentView setShowBounds:YES];
    [_mContentView setMinHeight:_minContentHeight];
    [_mContentView becomeFirstResponder];
    
    originY += sepHeight + _minContentHeight;

    
    [_mainContainerView addSubview:_abnormalBtn];
    [_mainContainerView addSubview:_mContentView];

    _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
    
    [self.view addSubview:_mainContainerView];

    
    [self updateViews];
}

- (void) updateViews {
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    if(width == 0) {
        return;
    }
    
    CGFloat sepHeight = [FMSize getInstance].padding30;
    CGFloat originX = 0;
    CGFloat originY = sepHeight;
    
    [_abnormalBtn setFrame:CGRectMake(originX, originY, _realWidth, _controlHeight)];
    originY += sepHeight + _controlHeight;
    
    
    CGFloat itemHeight = CGRectGetHeight(_mContentView.frame);
    [_mContentView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    _mainContainerView.contentSize = CGSizeMake(width, originY);
}

- (void) viewDidLoad {
    [super viewDidLoad];
    _paddingLeft = [FMSize getInstance].defaultPadding;
    _controlHeight = [FMSize getInstance].bottomControlHeight;
    _minContentHeight = 150;
    
    [self initViews];
    [self updateInfo];
}


//[[BaseBundle getInstance] getStringByKey:@"patrol_exception_common" inTable:nil]

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_patrol_record_edit" inTable:nil]];
    NSMutableArray * menuTitls = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil];
    [self setMenuWithArray:menuTitls];
    [self setBackAble:YES];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        //完成编辑 确定返回
        [self finishEditing];
    }
}

- (void) setContent:(NSString *) content {
    _content = content;
    [self updateInfo];
    
}

- (void) setContent:(NSString *)content withTag:(NSInteger) tag{
    _content = content;
    _mTag = tag;
    [self updateInfo];

}

- (void) setContent:(NSString *)content exceptions:(NSString *) exceptions withTag:(NSInteger) tag{
    _content = content;
    _exceptions = exceptions;
    _mTag = tag;
    [self updateInfo];
    
}


- (void) updateInfo {
    [_mContentView setContentWith:_content];
}


- (void) finishEditing {
    _content = [_mContentView getContent];
    if(_listener) {
        [_listener onQuestionEditFinishedWithTag:_mTag andDesc:_content];
    }
    [self finish];
}

- (void) gotoSelectExceptions {
    if(![FMUtils isStringEmpty:_exceptions]) {
        NSArray * exceptionArray = [_exceptions componentsSeparatedByString:@"||"];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:[[BaseBundle getInstance] getStringByKey:@"patrol_exception_common" inTable:nil], @"desc", exceptionArray, @"data", nil];
        InfoSelectViewController * infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
        [infoSelectVC setOnMessageHandleListener:self];
        [self gotoViewController:infoSelectVC];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_exception_no_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _mContentView) {
        CGRect frame = view.frame;
        CGFloat oldWidth = CGRectGetWidth(frame);
        CGFloat oldHeight = CGRectGetHeight(frame);
        if(oldWidth != newSize.width || oldHeight != newSize.height) {
            frame.size = newSize;
            view.frame = frame;
            [self updateViews];
        }
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
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
        CGRect frame = [self getContentFrame];
        frame.size.height -= _controlHeight;
        _mainContainerView.frame = frame;
    }];
}

#pragma - 设置编辑完成代理
- (void) setOnQuestionEditFinishedListener:(id<OnQuestionEditFinishedListener>) listener {
    _listener = listener;
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:@"InfoSelectViewController"]) {
            NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
            if(result) {
                NSString * info = @"";
                
                NSString * excep = [result valueForKeyPath:@"desc"];
                if(![FMUtils isStringEmpty:excep]) {
                    if(![FMUtils isStringEmpty:info]) {
                        info = [info stringByAppendingString:@"\n"];
                    }
                    info = [info stringByAppendingString:excep];
                }
                
                [self setContent:info];
            }
        }
    }
}


@end
