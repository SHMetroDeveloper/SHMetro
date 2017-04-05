//
//  BasePhotoCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BasePhotoCell.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "PhotoItemView.h"

@interface BasePhotoCell ()

@property (readwrite, nonatomic, strong) PhotoItemView * imgView;

@property (readwrite, nonatomic, strong) UIButton * imgBtn;

//用于分割
@property (readwrite, nonatomic, strong) UIImageView * topLine;
@property (readwrite, nonatomic, strong) UIImageView * leftLine;
@property (readwrite, nonatomic, strong) UIImageView * bottomLine;
@property (readwrite, nonatomic, strong) UIImageView * rightLine;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL editable;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, assign) BasePhotoCellType celltype;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end

@implementation BasePhotoCell

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
        
        _celltype = BASE_PHOTO_CELL_TYPE_IMAGE;
        
        _imgView = [[PhotoItemView alloc] init];
        _imgBtn = [[UIButton alloc] init];

        _topLine = [[UIImageView alloc] init];
        _leftLine = [[UIImageView alloc] init];
        _bottomLine = [[UIImageView alloc] init];
        _rightLine = [[UIImageView alloc] init];
        
        _paddingLeft = 0;
        _paddingRight = 0;
        
        UIImage * img = [FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] width:1 height:1];
        
        [_topLine setImage:img];
        [_leftLine setImage:img];
        [_bottomLine setImage:img];
        [_rightLine setImage:img];
        
        
        [_topLine setHidden:YES];
        [_leftLine setHidden:YES];
        [_bottomLine setHidden:YES];
        [_rightLine setHidden:YES];
        
        
        [_imgBtn addTarget:self action:@selector(onImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:_imgView];
        [self addSubview:_imgBtn];
        
        [self addSubview:_topLine];
        [self addSubview:_leftLine];
        [self addSubview:_bottomLine];
        [self addSubview:_rightLine];
    }
}

- (void) updateType {
    switch(_celltype) {
        case BASE_PHOTO_CELL_TYPE_IMAGE:
            [_imgView setHidden:NO];
            [_imgBtn setHidden:YES];
            break;
        case BASE_PHOTO_CELL_TYPE_BUTTON:
            [_imgView setHidden:YES];
            [_imgBtn setHidden:NO];
            break;
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat paddingTop = 0;
    CGFloat paddingBottom = 15;
    CGFloat paddingLeft = _paddingLeft;
    CGFloat paddingRight = _paddingRight;
    
    if(_celltype == BASE_PHOTO_CELL_TYPE_BUTTON) {
        paddingTop = 15;
        paddingRight = 15;
    }
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    [_imgView setFrame:CGRectMake(paddingLeft, paddingTop, width-paddingLeft -paddingRight, height-paddingTop - paddingBottom)];
    
    [_imgBtn setFrame:CGRectMake(paddingLeft, paddingTop, width-paddingLeft -paddingRight, height-paddingTop - paddingBottom)];
    
    //分割线
    [_topLine setFrame:CGRectMake(0, 0, width, seperatorHeight)];
    [_leftLine setFrame:CGRectMake(0, 0, seperatorHeight, height)];
    [_bottomLine setFrame:CGRectMake(0, (height-1), width, seperatorHeight)];
    [_rightLine setFrame:CGRectMake(width-seperatorHeight, 0, seperatorHeight, height)];
    
    [self updateType];
}

//设置是否显示上分割线
- (void) setShowTopLine:(BOOL) show {
    [_topLine setHidden:!show];
}

//设置是否显示下分割线
- (void) setShowBottomLine:(BOOL) show {
    [_bottomLine setHidden:!show];
}

//设置是否显示左分割线
- (void) setShowLeftLine:(BOOL) show {
    [_leftLine setHidden:!show];
}

//设置是否显示右分割线
- (void) setShowRightLine:(BOOL) show {
    [_rightLine setHidden:!show];
}


- (void) setPhoto:(UIImage *) photo {
    [_imgView setInfoWithImage:photo];
    [_imgBtn setImage:photo forState:UIControlStateNormal];
//    [_imgBtn setImage:photo forState:UIControlStateNormal];
}

//设置高亮状态的图片
- (void) setPhotoHighlight:(UIImage *) photo {
    if(photo) {
        [_imgBtn setImage:photo forState:UIControlStateHighlighted];
    }
}

- (void) setText:(NSString *) text {
    [_imgView setInfoWithText:text];
    
}

- (void) setPhotoUrl:(NSURL *) url {
    [_imgView setInfoWithUrl:url];
}

- (void) setPhotoItem:(PhotoItem *) item {
    [_imgView setInfoWithPhotoItem:item];
}

//设置是否可编辑
- (void) setEditable:(BOOL)editable {
    _editable = editable;
    [_imgView setEditable:_editable];
}

//设置类型
- (void) setCelltype:(BasePhotoCellType)celltype {
    _celltype = celltype;
    [self updateType];
}

//设置左右边距
- (void) setPaddingLeft:(CGFloat) paddingLeft paddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}

- (void) onImageButtonClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:_imgBtn subView:nil];
    }
}

//设置点击事件监听
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
    [_imgView setOnItemClickListener:_listener];
}

- (void) setTag:(NSInteger)tag {
    _imgView.tag = tag;
    _imgBtn.tag = tag;
}



@end
