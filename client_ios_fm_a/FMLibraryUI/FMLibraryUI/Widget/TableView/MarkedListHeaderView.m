//
//  MarkedListHeaderView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "MarkedListHeaderView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "SeperatorView.h"
#import "BaseLabelView.h"

@interface MarkedListHeaderView ()

@property (readwrite, nonatomic, strong) SeperatorView * topSeperator;  //上分割线
@property (readwrite, nonatomic, strong) SeperatorView * bottomSeperator;//下分割线

@property (readwrite, nonatomic, strong) UILabel * markLbl; //左侧的纯色标记
@property (readwrite, nonatomic, strong) UILabel * nameLbl; //名字
@property (readwrite, nonatomic, strong) BaseLabelView * descLbl; //说明
@property (readwrite, nonatomic, strong) UIImageView * rightImgView; //右侧图标

@property (readwrite, nonatomic, strong) NSString * name;       //名字
@property (readwrite, nonatomic, strong) NSString * desc;       //说明文本
@property (readwrite, nonatomic, strong) NSString * descLabelText;       //说明标签文本

@property (readwrite, nonatomic, strong) UIFont * nameFont;     //名字字体
@property (readwrite, nonatomic, strong) UIFont * descFont;     //说明文本字体
@property (readwrite, nonatomic, strong) UIFont * descLabelFont;     //说明文本标签字体

@property (readwrite, nonatomic, strong) UIColor * markColor;   //左侧的标记的颜色
@property (readwrite, nonatomic, strong) UIColor * nameColor;   //名字的颜色
@property (readwrite, nonatomic, strong) UIColor * descColor;   //说明文本的颜色
@property (readwrite, nonatomic, strong) UIColor * descLabelColor;   //说明文本标签的颜色
@property (readwrite, nonatomic, strong) UIColor * descBorderColor; //说明文本的边框色

@property (readwrite, nonatomic, assign) BOOL showMark;     //是否显示左侧标签
@property (readwrite, nonatomic, assign) BOOL showDesc;     //是否显示说明文本
@property (readwrite, nonatomic, assign) BOOL showRightImage;     //是否显示右侧图标
@property (readwrite, nonatomic, assign) BOOL showBorder;    //是否显示边框

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat tpaddingLeft;  //上分割线的对齐参数
@property (readwrite, nonatomic, assign) CGFloat tpaddingRight;

@property (readwrite, nonatomic, assign) CGFloat bpaddingLeft;  //下分割线的对齐参数
@property (readwrite, nonatomic, assign) CGFloat bpaddingRight;

@property (readwrite, nonatomic, assign) CGFloat realWidth;     //view 的实际宽度
@property (readwrite, nonatomic, assign) CGFloat realHeight;    //view 的实际高度

@property (readwrite, nonatomic, assign) CGFloat markWidth;     //左侧标记的宽度
@property (readwrite, nonatomic, assign) CGFloat rightImgWidth;     //向右箭头的图标的宽度

@property (readwrite, nonatomic, assign) ListHeaderDescStyle descStyle;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, strong) id<OnClickListener> clickListener;
@end

@implementation MarkedListHeaderView

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
        
        _nameFont = [FMFont fontWithSize:15];
        _descFont = [FMFont getInstance].font38;
        _descLabelFont  = [FMFont getInstance].defaultFontLevel3;
        
        _markColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_LIST_HEADER_MARK];
        _nameColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _descColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_LIST_HEADER_MARK];
        _descLabelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_LIST_HEADER_MARK];
        _descBorderColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_LIST_HEADER_MARK];
        
        _showMark = YES;
        _showDesc = NO;
        _showRightImage = NO;
        _showBorder = YES;
        
        _markWidth = 5;
        _rightImgWidth = [FMSize getInstance].imgWidthLevel2;
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = [FMSize getInstance].defaultPadding;
        
        
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        
    }
}

- (void) initViews {
    _markLbl = [[UILabel alloc] init];
    _nameLbl = [[UILabel alloc] init];
    _descLbl = [[BaseLabelView alloc] init];
    _rightImgView = [[UIImageView alloc] init];
    
    _topSeperator = [[SeperatorView alloc] init];
    _bottomSeperator = [[SeperatorView alloc] init];
    
    _nameLbl.font = _nameFont;
    _nameLbl.textColor = _nameColor;
    
    
    [_descLbl setContentFont:_descFont];
    [_descLbl setContentColor:_descColor];
    
    [_descLbl setLabelFont:_descLabelFont andColor:_descLabelColor];
    [_descLbl setLabelAlignment:NSTextAlignmentRight];
    [_descLbl setContentAlignment:NSTextAlignmentRight];

    
    _markLbl.backgroundColor = _markColor;
    _rightImgView.image = [[FMTheme getInstance] getImageByName:@"slim_more"];
    
    [self addSubview:_markLbl];
    [self addSubview:_nameLbl];
    [self addSubview:_descLbl];
    [self addSubview:_rightImgView];
    
    [self addSubview:_topSeperator];
    [self addSubview:_bottomSeperator];
    
}


- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat originX = _paddingLeft;
    CGFloat nameWidth = 0;
    CGFloat nameHeight = 0;
    CGFloat descWidth = 0;
    CGFloat descHeight = 0;
    CGFloat markHeight = 0;
    CGFloat sepWidth = 14;
    CGFloat right = _paddingRight;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    [_topSeperator setFrame:CGRectMake(_tpaddingLeft, 0, _realWidth-_tpaddingLeft-_tpaddingRight, seperatorHeight)];
    [_bottomSeperator setFrame:CGRectMake(_bpaddingLeft, height - seperatorHeight, _realWidth-_bpaddingLeft-_bpaddingRight, seperatorHeight)];
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, 0, _realWidth-_paddingLeft-_paddingRight, _realHeight)];
    [_descLbl setFrame:CGRectMake(_paddingLeft, 0, _realWidth-_paddingLeft-_paddingRight, _realHeight)];
    nameHeight = [FMUtils heightForStringWith:_nameLbl value:_name andWidth:_realWidth-_paddingLeft-_paddingRight];
    
//    UILabel * tmpLbl = [[UILabel alloc] init];
//    tmpLbl.font = _descFont;
    
//    descHeight = [FMUtils heightForStringWith:tmpLbl value:_desc andWidth:_realWidth-_paddingLeft-_paddingRight] + 6;
    
    
    descWidth = [BaseLabelView calculateWidthByInfo:_desc font:_descFont desc:_descLabelText labelFont:_descLabelFont andLabelWidth:0];
    
    descHeight = [BaseLabelView calculateHeightByInfo:_desc font:_descFont desc:_descLabelText labelFont:_descLabelFont andLabelWidth:0 andWidth:descWidth];
    
    
    
    nameWidth = _realWidth-_paddingLeft-_paddingRight;
    
    markHeight = nameHeight - 4;
    if(_showMark) {
        [_markLbl setHidden:NO];
        [_markLbl setFrame:CGRectMake(originX, (_realHeight - markHeight)/2, markHeight/4, markHeight)];
        originX += _markWidth + sepWidth;
        nameWidth -= _markWidth;
    } else {
        [_markLbl setHidden:YES];
    }
    if (_showRightImage) {
        [_rightImgView setHidden:NO];
        [_rightImgView setFrame:CGRectMake(_realWidth-_paddingRight-_rightImgWidth, (_realHeight-_rightImgWidth)/2, _rightImgWidth, _rightImgWidth)];
        nameWidth -= _rightImgWidth+sepWidth/2;
        right = _paddingRight + _rightImgWidth +sepWidth/2;
    }
    
//    if (_showBorder) {
//        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
//        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
//    } else {
//        self.layer.borderColor = [[UIColor clearColor] CGColor];
//        self.layer.borderWidth = 0;
//    }
    
    if(_showDesc && ![FMUtils isStringEmpty:_desc]) {
        [_descLbl setHidden:NO];
        [_descLbl setFrame:CGRectMake(_realWidth-right-descWidth, (_realHeight-descHeight)/2, descWidth, descHeight)];
        nameWidth -= descWidth;
    } else {
        [_descLbl setHidden:YES];
    }
    
    [_nameLbl setFrame:CGRectMake(originX, (_realHeight-nameHeight)/2, nameWidth, nameHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    _nameLbl.text = _name;
    if(_showDesc) {
        switch(_descStyle) {
            case LIST_HEADER_DESC_STYLE_TEXT_LABEL:
                [_descLbl setLabelText:_descLabelText andLabelWidth:0];
                [_descLbl setContent:_desc];
                break;
            default:
                [_descLbl setContent:_desc];
                break;
        }
    }
}

- (void) updateStyle {
    switch(_descStyle) {
        case LIST_HEADER_DESC_STYLE_NONE:
            _showDesc = NO;
            break;
        case LIST_HEADER_DESC_STYLE_RED_BG:
            _showDesc = YES;
            [self redBgStyle];
            break;
        case LIST_HEADER_DESC_STYLE_BOUND_CIRCLE:
            _showDesc = YES;
            [self boundCircleStyle];
            break;
        case LIST_HEADER_DESC_STYLE_TEXT_ONLY:
            _showDesc = YES;
            [self textOnlyStyle];
            break;
        case LIST_HEADER_DESC_STYLE_TEXT_LABEL:
            _showDesc = YES;
            [self textLabelStyle];
            break;
    }
}

- (void) setInfoWithName:(NSString *) name desc:(NSString *) desc andDescStyle:(ListHeaderDescStyle) descStyle {
    _name = name;
    _desc = desc;
    _descStyle = descStyle;
    [self updateStyle];
    [self updateViews];
}

- (void) setShowMore:(BOOL)showMore {
    
    _showRightImage = showMore;
    [_rightImgView setImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
    _rightImgWidth = [FMSize getInstance].imgWidthLevel3;
    [self updateViews];
}

//设置是否显示添加图标
- (void) setShowAdd:(BOOL)showAdd {
    _showRightImage = showAdd;
    [_rightImgView setImage:[[FMTheme getInstance] getImageByName:@"add_gray"]];
    [self updateViews];
}

//设置是否显示编辑图标
- (void) setShowEdit:(BOOL)showEdit {
    _showRightImage = showEdit;
    [_rightImgView setImage:[[FMTheme getInstance] getImageByName:@"edit_full"]];
    _rightImgWidth = [FMSize getInstance].imgWidthLevel3;
    [self updateViews];
}

//设置右图标
- (void) setRightImage:(UIImage *) image {
    _showRightImage = YES;
    [_rightImgView setImage:image];
    [self updateViews];
}
//设置右图标 --- 多个
- (void) setRightImageWithArray:(NSMutableArray *) imgArray {
    
}

- (void) setRightImgWidth:(CGFloat)rightImgWidth {
    _rightImgWidth = rightImgWidth;
    [self updateViews];
}

- (void) setShowMark:(BOOL)showMark {
    _showMark = showMark;
    [self updateViews];
}

//设置上分割线
- (void) setShowTopBorder:(BOOL) show withPaddingLeft:(CGFloat) paddingLeft paddingRight:(CGFloat) paddingRight {
    _tpaddingLeft = paddingLeft;
    _tpaddingRight = paddingRight;
    [_topSeperator setHidden:!show];
    [self updateViews];
}

//设置下分割线
- (void) setShowBottomBorder:(BOOL) show withPaddingLeft:(CGFloat) paddingLeft paddingRight:(CGFloat) paddingRight {
    _bpaddingLeft = paddingLeft;
    _bpaddingRight = paddingRight;
    [_bottomSeperator setHidden:!show];
     [self updateViews];
}

//设置上分割线为虚线
- (void) setTopBorderDotted:(BOOL) show{
    [_topSeperator setDotted:show];
}

//设置下分割线为虚线
- (void) setBottomBorderDotted:(BOOL) show{
    [_bottomSeperator setDotted:show];
}

- (void) setShowBorder:(BOOL)showBorder {
    _showBorder = showBorder;
    _tpaddingLeft = _tpaddingRight = 0;
    _bpaddingLeft = _bpaddingRight = 0;
    [_topSeperator setHidden:NO];
    [_bottomSeperator setHidden:NO];
    [self updateViews];
}

//设置描述文字颜色
- (void) setDescColor:(UIColor *) color {
    _descColor = [color copy];
    [_descLbl setContentColor:_descColor];
}

- (void) setOnClickListener:(id<OnClickListener>)clickListener {
    if(!_clickListener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:tapGesture];
    }
    _clickListener = clickListener;
}


#pragma mark - LIST_HEADER_DESC_STYLE_TEXT_LABEL 样式时使用
//设置描述文字的标签和正文颜色
- (void) setDescLabelColor:(UIColor *) labelColor contentColor:(UIColor *) contentColor {
    _descLabelColor = labelColor;
    _descColor = contentColor;
    [self updateStyle];
}
- (void) setDescLabelFont:(UIFont *) labelFont contentFont:(UIFont *) contentFont {
    _descLabelFont = labelFont;
    _descFont = contentFont;
    [self updateStyle];
}
- (void) setDescLabel:(NSString *) label content:(NSString *) content {
    _descLabelText = label;
    _desc = content;
    [self updateViews];
}

#pragma mark - 样式初始化

- (void) redBgStyle {
    _descLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
    [_descLbl setContentColor:[UIColor whiteColor]];
    _descLbl.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] CGColor];
    _descLbl.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    _descLbl.layer.cornerRadius = [FMSize getInstance].colorLblBorderRadius;
    _descLbl.clipsToBounds = YES;
}

- (void) boundCircleStyle {
    _descLbl.backgroundColor = [UIColor whiteColor];
    [_descLbl setContentColor:_descColor];
    _descLbl.layer.borderColor = [_descBorderColor CGColor];
    _descLbl.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    _descLbl.layer.cornerRadius = [FMSize getInstance].colorLblBorderRadius;
}

- (void) textOnlyStyle {
    [_descLbl setContentColor:_descColor];
//    _descLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
    _descLbl.backgroundColor = [UIColor clearColor];
    _descLbl.layer.borderWidth = 0;
}

- (void) textLabelStyle {
    [_descLbl setLabelFont:_descLabelFont andColor:_descLabelColor];
    [_descLbl setContentColor:_descColor];
    [_descLbl setContentFont:_descFont];
    _descLbl.layer.borderWidth = 0;
}


#pragma mark - 点击事件
-(void)onClicked:(id)sender {
    if(_clickListener) {
        [_clickListener onClick:self];
    }
}

@end
