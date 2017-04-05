//
//  FMDrawView.m
//  SignUpTest
//
//  Created by 林江锋 on 16/3/7.
//  Copyright © 2016年 Master_Lyn. All rights reserved.
//

#import "FMDrawView.h"
#import "HBDrawingBoard.h"
#import "HBDrawCommon.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "BaseBundle.h"

@interface FMDrawView ()
@property (readwrite, nonatomic, strong) UIView * toolBarView;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UIButton * clearBtn;
@property (readwrite, nonatomic, strong) UIButton * revokeBtn;

@property (readwrite, nonatomic, strong) UIView * contentView;
@property (readwrite, nonatomic, strong) UIImageView * boardImageView;
@property (readwrite, nonatomic, strong) UIImage * backgroundImg;
@property (readwrite, nonatomic, strong) HBDrawingBoard *drawBoard;

@property (readwrite, nonatomic, strong) UIView * controlView;
@property (readwrite, nonatomic, strong) UIButton * cancelBtn;
@property (readwrite, nonatomic, strong) UIButton * doneBtn;

@property (readwrite, nonatomic, assign) CGFloat realHeight;
@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat buttonHeight;
@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat toolBarHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) id<OnItemClickListener> clickListener;

@end

@implementation FMDrawView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self initViews];
    [self updateViews];
}

- (void) initViews {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if (width == 0 || height == 0) {
        return;
    }
    
    if (!_isInited) {
        _isInited = YES;
        
        CGRect frame = self.frame;
        _realHeight = CGRectGetHeight(frame);
        _realWidth = CGRectGetWidth(frame);
        _controlHeight = 50;
        _buttonHeight = 40;
        _toolBarHeight = 40;
        
        //toolBar界面
        _toolBarView = [[UIView alloc] init];
        _toolBarView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
        
          //撤销按钮
        _revokeBtn = [[UIButton alloc] init];
        [_revokeBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_revoke" inTable:nil] forState:UIControlStateNormal];
        [_revokeBtn setTitleColor:[UIColor colorWithRed:47/255.0 green:123/255.0 blue:249/255.0 alpha:1] forState:UIControlStateNormal];
        [_revokeBtn addTarget:self action:@selector(onRevokeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _revokeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _revokeBtn.backgroundColor = [UIColor clearColor];

          //清楚按钮
        _clearBtn = [[UIButton alloc] init];
        [_clearBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_clean" inTable:nil] forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor colorWithRed:47/255.0 green:123/255.0 blue:249/255.0 alpha:1] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(onClearButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _clearBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _clearBtn.backgroundColor = [UIColor clearColor];
        
        _descLbl = [[UILabel alloc] init];
        _descLbl.text = [[BaseBundle getInstance] getStringByKey:@"signature_notice_desc" inTable:nil];
        _descLbl.textAlignment = NSTextAlignmentCenter;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
        
        [_toolBarView addSubview:_descLbl];
        [_toolBarView addSubview:_revokeBtn];
        [_toolBarView addSubview:_clearBtn];
        
        //操作界面
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
//        [_contentView addSubview:self.boardImageView];
        [_contentView addSubview:self.drawBoard];

        //控制面板
        _controlView = [[UIView alloc] init];
        _controlView.backgroundColor = [UIColor whiteColor];
        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"signature_button_cancel" inTable:nil] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        [_cancelBtn addTarget:self action:@selector(onCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.tag = FMDRAW_BUTTON_CANCEL;
        _cancelBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel1;
        
        _doneBtn = [[UIButton alloc] init];
        [_doneBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"signature_button_done" inTable:nil] forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        [_doneBtn addTarget:self action:@selector(onDoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _doneBtn.tag = FMDRAW_BUTTON_DONE;
        _doneBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel1;
        
        [_controlView addSubview:_cancelBtn];
        [_controlView addSubview:_doneBtn];
        
        [self addSubview:_toolBarView];
        [self addSubview:_contentView];
        [self addSubview:_controlView];
        
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
        [self addGestureRecognizer:tapGesture];
        
        [self updateViews];
    }
}

- (void) updateViews {
    /**
     *  此处填写界面更新
     */
    
    CGFloat padding = 10;
    CGFloat buttonWidth = (_realWidth - padding*3)/2;
    
    //工具栏
    [_toolBarView setFrame:CGRectMake(0, 0, _realWidth, _toolBarHeight)];
    [_descLbl setFrame:CGRectMake(0, 5, 40, 30)];
    [_clearBtn setFrame:CGRectMake(_realWidth - 5 - 40, 5, 40, 30)];
    [_revokeBtn setFrame:CGRectMake(_realWidth - 10 -40*2, 5, 40, 30)];
    
    //内容
    [_contentView setFrame:CGRectMake(0, _toolBarHeight, _realWidth, _realHeight - _controlHeight - _toolBarHeight)];
    
    //控制面板
    [_controlView setFrame:CGRectMake(0, _realHeight - _controlHeight, _realWidth, _controlHeight)];
    [_cancelBtn setFrame:CGRectMake(padding, padding/2, buttonWidth, _buttonHeight)];
    [_doneBtn setFrame:CGRectMake(padding*2 + buttonWidth, padding/2, buttonWidth, _buttonHeight)];
    
}

#pragma mark = getter
//画板
- (HBDrawingBoard *)drawBoard {
    if (!_drawBoard) {
        _drawBoard = [[HBDrawingBoard alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight - _controlHeight - _toolBarHeight)];
        _drawBoard.lineColor = [UIColor blackColor];
        _drawBoard.lineWidth = 2.0f;
//        _drawBoard.boardBackImage = [UIImage imageNamed:@"signatureBackground.png"];
        [_drawBoard drawingStatus:^(HBDrawingStatus drawingStatus, HBDrawModel *model) {
            switch (drawingStatus) {
                case HBDrawingStatusBegin:
                    NSLog(@"开始");
                    break;
                case HBDrawingStatusMove:
                    NSLog(@"移动");
                    break;
                case HBDrawingStatusEnd:
                    NSLog(@"结束 ： %@ - %@ - %@",model.pointList,model.isEraser,model.paintColor);
                    break;
                default:
                    break;
            }
        }];
    }
    return _drawBoard;
}

//背景
- (UIImageView *)boardImageView {
    if (!_boardImageView) {
        _boardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight - _controlHeight - _toolBarHeight)];
        _boardImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_boardImageView setImage:[UIImage imageNamed:@"signatureBackground.png"]];
    }
    return _boardImageView;
}

#pragma mark Private method
//设置画板背景
- (void)setDrawBoardBackgroundImage:(UIImage *) image {
    if (!_boardImageView) {
        _boardImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _boardImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_boardImageView setImage:image];
    } else {
        [_boardImageView setImage:image];
    }
}

//设置画笔粗细颜色
- (void)setDrawLineWidth:(CGFloat) width andLineColor:(UIColor *) color {
    if (!_drawBoard) {
        _drawBoard = [[HBDrawingBoard alloc] initWithFrame:self.bounds];
        _drawBoard.lineColor = color;
        _drawBoard.lineWidth = width;
    } else {
        _drawBoard.lineColor = color;
        _drawBoard.lineWidth = width;
    }
}

- (UIImage *)getScreenshots {
    _contentView.backgroundColor = [UIColor clearColor];  //把背景设置为透明方便获取png格式的签名
    UIImage * currentImage = [_drawBoard getScreenImg];
    _contentView.backgroundColor = [UIColor whiteColor];  //获取到png的签名以后再把背景改回来
    return currentImage;
}

- (void) clearScreenShots {
    [_drawBoard clearAll];
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SendColorAndWidthNotification object:nil];
}

#pragma mark 点击事件
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _clickListener = listener;
}

- (void) onCancelButtonClick {
    NSLog(@"点击了取消按钮");
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_cancelBtn];
    }
}

- (void) onDoneButtonClick {
    NSLog(@"点击了确定按钮");
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_doneBtn];
    }
}

- (void) onRevokeButtonClick {
    [_drawBoard backToLastDraw];
}

- (void) onClearButtonClick {
    [_drawBoard clearAll];
}

@end

