//
//  WorkContentHeaderView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/16.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkContentHeaderView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"

@interface WorkContentHeaderView ()

@property (readwrite, nonatomic, strong) UILabel * markLbl; //左侧的纯色标记
@property (readwrite, nonatomic, strong) UILabel * nameLbl; //名字
@property (readwrite, nonatomic, strong) UIImageView * editImgView; //右侧图标
@property (readwrite, nonatomic, strong) UIImageView * cameraImgView; //拍照
@property (readwrite, nonatomic, strong) UIButton * cameraBtn;  //拍照按钮

@property (readwrite, nonatomic, strong) NSString * name;       //名字

@property (readwrite, nonatomic, strong) UIFont * nameFont;     //名字字体

@property (readwrite, nonatomic, strong) UIColor * markColor;   //左侧的标记的颜色
@property (readwrite, nonatomic, strong) UIColor * nameColor;   //名字的颜色

@property (readwrite, nonatomic, assign) BOOL showMark;     //是否显示左侧标签
@property (readwrite, nonatomic, assign) BOOL showRightImage;     //是否显示右侧图标
@property (readwrite, nonatomic, assign) BOOL showBorder;    //是否显示边框

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat realWidth;     //view 的实际宽度
@property (readwrite, nonatomic, assign) CGFloat realHeight;    //view 的实际高度

@property (readwrite, nonatomic, assign) CGFloat markWidth;     //左侧标记的宽度
@property (readwrite, nonatomic, assign) CGFloat rightImgWidth;     //向右箭头的图标的宽度

@property (readwrite, nonatomic, assign) CGFloat cameraWidth;
@property (readwrite, nonatomic, assign) CGFloat cameraHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, strong) id<OnItemClickListener> listener;
@end

@implementation WorkContentHeaderView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSettings];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initSettings];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    [self updateViews];
}

- (void) initSettings {
    if(!_isInited) {
        _isInited = YES;
        
        _nameFont = [UIFont fontWithName:@"Helvetica" size:15];
        
        _markColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_LIST_HEADER_MARK];
        _nameColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        _cameraWidth = [FMSize getInstance].cameraImageWidth;
        _cameraHeight = [FMSize getInstance].cameraImageHeight;
        
        _showMark = YES;
        _showRightImage = NO;
        _showBorder = YES;
        
        _markWidth = 5;
        _rightImgWidth = [FMSize getInstance].imgWidthLevel3;
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = [FMSize getInstance].defaultPadding;
        
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        
        
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        
        
    }
}

- (void) initViews {
    _markLbl = [[UILabel alloc] init];
    _nameLbl = [[UILabel alloc] init];
    _editImgView = [[UIImageView alloc] init];
    _cameraImgView = [[UIImageView alloc] init];
    
    _cameraBtn = [[UIButton alloc] init];
    
    _nameLbl.font = _nameFont;
    _nameLbl.textColor = _nameColor;
    
    
    _markLbl.backgroundColor = _markColor;
    
    [_cameraBtn addTarget:self action:@selector(onCameraClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_editImgView setImage:[[FMTheme getInstance] getImageByName:@"edit_full"]];
    [_cameraImgView setImage:[[FMTheme getInstance] getImageByName:@"photo"]];
    
    [_cameraBtn addSubview:_cameraImgView];
    
    [self addSubview:_markLbl];
    [self addSubview:_nameLbl];
    [self addSubview:_editImgView];
    [self addSubview:_cameraBtn];
    
}


- (void) updateViews {
    CGFloat originX = _paddingLeft;
    CGFloat nameWidth = 0;
    CGFloat nameHeight = 0;
    CGFloat markHeight = 0;
    CGFloat sepWidth = 10;
    CGFloat right = _paddingRight;
    [_nameLbl setFrame:CGRectMake(_paddingLeft, 0, _realWidth-_paddingLeft-_paddingRight, _realHeight)];
    nameHeight = [FMUtils heightForStringWith:_nameLbl value:_name andWidth:_realWidth-_paddingLeft-_paddingRight];
    
    nameWidth = _realWidth-_paddingLeft-_paddingRight;
    
    markHeight = nameHeight + 3 * 2;
    if(_showMark) {
        [_markLbl setHidden:NO];
        [_markLbl setFrame:CGRectMake(originX, (_realHeight - markHeight)/2, _markWidth, markHeight)];
        originX += _markWidth + sepWidth;
        nameWidth -= _markWidth;
    } else {
        [_markLbl setHidden:YES];
    }
    if (_showRightImage) {
        [_editImgView setHidden:NO];
        [_cameraImgView setHidden:NO];
        [_cameraBtn setFrame:CGRectMake(_realWidth-_paddingRight-_cameraWidth-sepWidth, 0, _cameraWidth+_cameraWidth+sepWidth, _realHeight)];
        [_cameraImgView setFrame:CGRectMake(sepWidth, (_realHeight-_cameraHeight)/2, _cameraWidth, _cameraHeight)];
        
        [_editImgView setFrame:CGRectMake(_realWidth-_paddingRight-_rightImgWidth - _cameraWidth-sepWidth, (_realHeight-_rightImgWidth)/2, _rightImgWidth, _rightImgWidth)];
        
        nameWidth -= _rightImgWidth + _cameraWidth + sepWidth*2;
        right = _paddingRight + _rightImgWidth + _cameraWidth +sepWidth*2;
    } else {
        [_editImgView setHidden:YES];
        [_cameraImgView setHidden:YES];
    }
    
    if (_showBorder) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    } else {
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        self.layer.borderWidth = 0;
    }
    
    
    [_nameLbl setFrame:CGRectMake(originX, (_realHeight-nameHeight)/2, nameWidth, nameHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    _nameLbl.text = _name;
}

- (void) setInfoWithName:(NSString *) name {
    _name = name;
    
    [self updateViews];
}

- (void) setShowRightImage:(BOOL)showRightImage {
    _showRightImage = showRightImage;
    [self updateViews];
}

- (void) setRightImgWidth:(CGFloat)rightImgWidth {
    _rightImgWidth = rightImgWidth;
    [self updateViews];
}


- (void) setShowBorder:(BOOL)showBorder {
    _showBorder = showBorder;
    [self updateViews];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:tapGesture];
    }
    _listener = listener;
}

#pragma mark - 点击事件
-(void)onClicked:(id)sender {
    if(_listener) {
        [_listener onItemClick:self subView:nil];
    }
}

- (void) onCameraClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_cameraImgView];
    }
}

@end

