//
//  CheckedItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "CheckItemView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMColor.h"
#import "FMTheme.h"


@interface RightArrowButton : UIButton
@end

@implementation RightArrowButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat height = CGRectGetHeight(contentRect);
    CGFloat imgWidth = [FMSize getInstance].imgWidthLevel3;
    CGFloat paddingLeft = 20;
    CGRect newRect = CGRectMake(paddingLeft, (height - imgWidth)/2, imgWidth, imgWidth);
    return newRect;
}
@end





@interface CheckItemView ()
@property (readwrite, nonatomic, strong) UIImageView * checkBtnImgView;

@property (readwrite, nonatomic, strong) UILabel * nameLabel;
@property (readwrite, nonatomic, strong) UILabel * descLabel;

@property (readwrite, nonatomic, strong) RightArrowButton * rightBtn;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * desc;

@property (readwrite, nonatomic, strong) UIImage * rightImg;//右侧图片

@property (readwrite, nonatomic, assign) CGFloat imgWidth;//图片宽度

@property (readwrite, nonatomic, assign) BOOL showRightImage;//是否展示右侧图片
@property (readwrite, nonatomic, assign) BOOL checked;  //是否选中

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@property (readwrite, nonatomic, assign) BOOL isInited;


@end

@implementation CheckItemView

//初始化
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
        
        _imgWidth = [FMSize getInstance].imgWidthLevel3;
        _showRightImage = NO;
        
        _checkBtnImgView = [UIImageView new];
        [_checkBtnImgView setImage:[[FMTheme getInstance]  getImageByName:@"icon_unchecked"]];
        _checkBtnImgView.tag = CHECKABLE_ITEM_EVENT_TYPE_CHECK_UPDATE;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [FMFont getInstance].defaultFontLevel2;
        _nameLabel.textColor = [FMColor getInstance].mainText;
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [FMFont getInstance].defaultFontLevel3;
        _descLabel.textColor = [FMColor getInstance].grayLevel4;
        
        _rightBtn = [[RightArrowButton alloc] init];
        _rightBtn.tag = CHECKABLE_ITEM_EVENT_TYPE_RIGHT_CLICK;
        [_rightBtn setImage:_rightImg forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(onRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_checkBtnImgView];
        [self addSubview:_nameLabel];
        [self addSubview:_descLabel];
        [self addSubview:_rightBtn];
        
    }
}

- (void) updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat sepWidth = 20;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGFloat originX = padding;
    
    [_checkBtnImgView setFrame:CGRectMake(originX, (height - _imgWidth)/2, _imgWidth, _imgWidth)];
    originX += _imgWidth + sepWidth;
    
    [_rightBtn setFrame:CGRectMake(width-padding-_imgWidth-sepWidth, 0, padding+_imgWidth+sepWidth, height)];
    
    CGSize nameSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].defaultFontLevel2 andContent:_name andMaxWidth:width-padding*2-_imgWidth*2-sepWidth*2];
    CGSize descSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].defaultFontLevel3 andContent:_desc andMaxWidth:width];
    
    CGFloat nameWidth = nameSize.width;
    CGFloat descWidth = descSize.width;
    if (nameWidth+descWidth+sepWidth > (width-padding*2-_imgWidth*2-sepWidth*2)) {
        nameWidth = width-padding*2-_imgWidth*2-sepWidth*3-descWidth;
    }
    
    [_nameLabel setFrame:CGRectMake(originX, 0, nameWidth, height)];
    originX += nameWidth + sepWidth;
    
    [_descLabel setFrame:CGRectMake(originX, 0, descWidth, height)];
}

- (void) updateInfo {
    [_nameLabel setText:_name];
    [_descLabel setText:_desc];
    
    if(_showRightImage) {
        [_rightBtn setHidden:NO];
        [_rightBtn setImage:_rightImg forState:UIControlStateNormal];
    } else {
        [_rightBtn setHidden:YES];
        [_rightBtn setImage:_rightImg forState:UIControlStateNormal];
    }
    
    if(_checked) {
        [_checkBtnImgView setImage:[[FMTheme getInstance]  getImageByName:@"icon_checked"]];
    } else {
        [_checkBtnImgView setImage:[[FMTheme getInstance]  getImageByName:@"icon_unchecked"]];
    }
    
    [self updateViews];
}

#pragma mark - Setter
//设置是否显示右侧图片
- (void) setShowRightImage:(BOOL) show {
    _showRightImage = show;
}

- (void) setRightImage:(UIImage *) image {
    _rightImg = image;
}

- (void) setChecked:(BOOL) checked {
    _checked = checked;
    [self updateInfo];
}

//设置基本信息
- (void) setInfoWithName:(NSString *) name desc:(NSString *) desc {
    _name = name;
    _desc = desc;
    
    [self updateInfo];
}

- (void) setRightImgWidth:(CGFloat)imgWidth {
    _imgWidth = imgWidth;
    [self updateViews];
}

//设置事件代理
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCheckButtonClicked:)];
        [self addGestureRecognizer:gesture];
    }
    _listener = listener;
}

- (void) onCheckButtonClicked:(id) gesture {
    if(_listener) {
        [_listener onItemClick:self subView:_checkBtnImgView];
    }
}

- (void) onRightButtonClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_rightBtn];
    }
}

@end
