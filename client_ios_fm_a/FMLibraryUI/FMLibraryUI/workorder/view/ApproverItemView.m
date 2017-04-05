//
//  ApproverItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "ApproverItemView.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"

@interface ApproverItemView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UIButton * deleteBtn;

@property (readwrite, nonatomic, strong) NSString * name;

@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation ApproverItemView

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
        
        UIFont * nameFont = [FMFont getInstance].defaultFontLevel2;
        UIFont * btnFont = [FMFont fontWithSize:13];
        
        _nameLbl = [[UILabel alloc] init];
        _deleteBtn = [[UIButton alloc] init];
        
        _nameLbl.font = nameFont;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _deleteBtn.tag = APPROVER_ACTION_DELETE;
        _deleteBtn.titleLabel.font = btnFont;
        [_deleteBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] forState:UIControlStateNormal];
        
        [_deleteBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(onDeleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_nameLbl];
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
    [_nameLbl setFrame:CGRectMake(_padding, 0, width-_padding  - _btnWidth, height)];
    [_deleteBtn setFrame:CGRectMake(width-_btnWidth, 0, _btnWidth, height)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_nameLbl setText:_name];
}


- (void) setInfoWithName:(NSString *) name {
    _name = [name copy];
    [self updateInfo];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
}

- (void) onDeleteBtnClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_deleteBtn];
    }
}
@end
