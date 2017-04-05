//
//  LaborerItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/11.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "LaborerItemView.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"

@interface LaborerItemView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UIImageView * selectImgView;
@property (readwrite, nonatomic, strong) UIButton * deleteBtn;

@property (readwrite, nonatomic, strong) NSString * name;

@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) BOOL selected;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation LaborerItemView

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
        
        _padding = 20;
        _btnWidth = 65;
        _imgWidth = [FMSize getInstance].imgWidthLevel4;
        
        UIFont * nameFont = [FMFont getInstance].defaultFontLevel2;
        UIFont * btnFont = [FMFont fontWithSize:13];
        
        _nameLbl = [[UILabel alloc] init];
        _deleteBtn = [[UIButton alloc] init];
        _selectImgView = [[UIImageView alloc] init];
        
        _nameLbl.font = nameFont;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        [_selectImgView setImage:[[FMTheme getInstance] getImageByName:@"checked"]];
        
        _deleteBtn.tag = LABORER_ACTION_DELETE;
        _deleteBtn.titleLabel.font = btnFont;
        [_deleteBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] forState:UIControlStateNormal];
        
        [_deleteBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(onDeleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_nameLbl];
        [self addSubview:_selectImgView];
        [self addSubview:_deleteBtn];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat sepWidth = 40;
    
    CGFloat nameWidth = [FMUtils widthForString:_nameLbl value:_name];
    [_nameLbl setFrame:CGRectMake(_padding, 0, nameWidth, height)];
    
    [_selectImgView setFrame:CGRectMake(_padding + nameWidth + sepWidth, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    
    [_deleteBtn setFrame:CGRectMake(width-_btnWidth, 0, _btnWidth, height)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_nameLbl setText:_name];
    if(_selected) {
        [_selectImgView setHidden:NO];
    } else {
        [_selectImgView setHidden:YES];
    }
}


- (void) setInfoWithName:(NSString *) name {
    _name = [name copy];
    [self updateViews];
}

- (void) setSelected:(BOOL)selected {
    _selected = selected;
    [self updateInfo];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:gesture];
    }
    _listener = listener;
    
}

- (void) onDeleteBtnClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_deleteBtn];
    }
}

- (void) onClicked:(UITapGestureRecognizer *) gesture {
    if(_listener) {
        [_listener onItemClick:self subView:nil];
    }
}
@end

