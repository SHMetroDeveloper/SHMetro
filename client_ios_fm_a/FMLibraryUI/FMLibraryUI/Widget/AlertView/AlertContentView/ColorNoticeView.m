//
//  ColorNoticeView.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/16.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "ColorNoticeView.h"
#import "UIButton+Bootstrap.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "BaseBundle.h"

@interface ColorNoticeView ()

@property (nonatomic, strong) UIImageView *typeImgView;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, assign) CGFloat typeWidth;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *leftButtonTitle;
@property (nonatomic, strong) NSString *rightButtonTitle;

@property (nonatomic, assign) ColorNoticeStyle style;

@property (nonatomic, weak) id<OnItemClickListener> listener;
@end

@implementation ColorNoticeView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}
- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _typeWidth = 50;
        
        _typeImgView = [[UIImageView alloc] init];
        _contentLbl = [[UILabel alloc] init];
        _leftBtn = [[UIButton alloc] init];
        _rightBtn = [[UIButton alloc] init];
        
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _contentLbl.font = [FMFont getInstance].font44;
        _contentLbl.textAlignment = NSTextAlignmentCenter;
        
        [_leftBtn addTarget:self action:@selector(onLeftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addTarget:self action:@selector(onRightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _leftBtn.tag = COLOR_NOTICE_EVENT_TYPE_LEFT_CLICK;
        _rightBtn.tag = COLOR_NOTICE_EVENT_TYPE_RIGHT_CLICK;
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        
        
        [self addSubview:_typeImgView];
        [self addSubview:_contentLbl];
        [self addSubview:_leftBtn];
        [self addSubview:_rightBtn];
    });
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat paddingTop = 25;
    CGFloat originY = 0;
    CGFloat paddingLeft = 13;
    CGFloat paddingBottom = 10;
    CGFloat defaultContentHeight = 18;
    CGFloat btnHeight = 40;
    
    CGFloat contentHeight = [FMUtils heightForStringWith:_contentLbl value:_content andWidth:width-paddingLeft * 2];
    if(contentHeight < defaultContentHeight) {
        contentHeight = defaultContentHeight;
    }
    
    originY = paddingTop;
    [_typeImgView setFrame:CGRectMake((width - _typeWidth)/2, originY, _typeWidth, _typeWidth)];
    originY += _typeWidth + paddingTop;
    
    [_contentLbl setFrame:CGRectMake(paddingLeft, originY, width-paddingLeft*2, contentHeight)];
    originY += contentHeight;
    
    CGFloat leftBtnWidth = 0;
    CGFloat rightBtnWidth = 0;
    CGFloat btnSepWidth = 0;
    if(![FMUtils isStringEmpty:_leftButtonTitle]) {
        if(![FMUtils isStringEmpty:_rightButtonTitle]) {
            btnSepWidth = 13;
            leftBtnWidth = rightBtnWidth = (width - paddingLeft * 2 - btnSepWidth) / 2;
        } else {
            leftBtnWidth = width - paddingLeft * 2;
        }
    } else {
        if(![FMUtils isStringEmpty:_rightButtonTitle]) {
            rightBtnWidth = width - paddingLeft * 2;
        }
    }
    if (leftBtnWidth > 0) {
        [_leftBtn setHidden:NO];
        [_leftBtn setFrame:CGRectMake(paddingLeft, height-btnHeight-paddingBottom, leftBtnWidth, btnHeight)];
        [_leftBtn grayStyle];
    } else {
        [_leftBtn setHidden:YES];
    }
    if (rightBtnWidth > 0) {
        [_rightBtn setHidden:NO];
        [_rightBtn setFrame:CGRectMake(width-paddingLeft-rightBtnWidth, height-btnHeight-paddingBottom, rightBtnWidth, btnHeight)];
        [_rightBtn successStyle];
    } else {
        [_rightBtn setHidden:YES];
    }
    
    [self updateInfo];
}

- (void) updateInfo {
    switch (_style) {
        case COLOR_NOTICE_STYLE_WARNING:
            [_typeImgView setImage:[[BaseBundle getInstance] getPngImageByKeyDynamic:@"icon_warning"]];
            break;
            
        default:
            break;
    }
    [_contentLbl setText:_content];
    if(_leftButtonTitle) {
        [_leftBtn setTitle:_leftButtonTitle forState:UIControlStateNormal];
    }
    if(_rightButtonTitle) {
        [_rightBtn setTitle:_rightButtonTitle forState:UIControlStateNormal];
    }
}

- (void) setInfoWithStyle:(ColorNoticeStyle) style content:(NSString *) content {
    _style = style;
    _content = content;
    [self updateInfo];
}
- (void) setLeftButtonTitle:(NSString *) leftTitle rightButtonTitle:(NSString *) rightTitle {
    _leftButtonTitle = leftTitle;
    _rightButtonTitle = rightTitle;
    [self updateViews];
}
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
}

- (void) onLeftBtnClicked {
    if(_listener) {
        [_listener onItemClick:self subView:_leftBtn];
    }
}

- (void) onRightBtnClicked {
    if(_listener) {
        [_listener onItemClick:self subView:_rightBtn];
    }
}

//计算所需要的高度
+ (CGFloat) calculateHeightByContent:(NSString *) content width:(CGFloat) width {
    CGFloat height = 0;
    CGFloat paddingTop = 25;    //icon 的上下边距
    CGFloat typeWidth = 50;     //icon 高度
    CGFloat paddingLeft = 13;   //文字左右边距
    CGFloat paddingBottom = 10; //按钮下边距
    CGFloat btnHeight = 40;     //按钮高度
    CGFloat defaultContentHeight = 18;  //文字最低高度
    CGFloat contentHeight = 0;
    
    CGFloat sepHeight = 42; //文字与底部按钮间距
    
    UILabel * testLbl = [[UILabel alloc] init];
    testLbl.font = [FMFont getInstance].font44;
    
    contentHeight = [FMUtils heightForStringWith:testLbl value:content andWidth:width-paddingLeft * 2];
    if(contentHeight < defaultContentHeight) {
        contentHeight = defaultContentHeight;
    }
    
    height = paddingTop * 2 + typeWidth + contentHeight + sepHeight + btnHeight + paddingBottom;
    return height;
}

@end
