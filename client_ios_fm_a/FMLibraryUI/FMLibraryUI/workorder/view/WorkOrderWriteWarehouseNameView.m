//
//  WorkOrderWriteWarehouseNameView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/12.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderWriteWarehouseNameView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMFont.h"

@interface WorkOrderWriteWarehouseNameView ()

@property (nonatomic, strong) UILabel * desclbl;
@property (nonatomic, strong) UILabel * namelbl;
@property (nonatomic, strong) UIImageView * refreshImgView;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) CGFloat labelWidth;
@property (nonatomic, assign) CGFloat imgWidth;
@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, assign) BOOL isInited;
@property (nonatomic, assign) BOOL editable;

@property (nonatomic, weak) id<OnClickListener> listener;

@end

@implementation WorkOrderWriteWarehouseNameView

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
        _editable = YES;
        
        UIFont * font = [FMFont getInstance].defaultFontLevel2;
        
        _padding = [FMSize getInstance].defaultPadding;
        _imgWidth = [FMSize getInstance].imgWidthLevel2;
        _labelWidth = 80;
        
        _desclbl = [[UILabel alloc] init];
        _namelbl = [[UILabel alloc] init];
        _refreshImgView = [[UIImageView alloc] init];
        
        _desclbl.textAlignment = NSTextAlignmentLeft;
        _namelbl.textAlignment = NSTextAlignmentCenter;
        
        [_desclbl setText:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name" inTable:nil]];
        [_refreshImgView setImage:[[FMTheme getInstance] getImageByName:@"switch_store"]];
        
        [_desclbl setFont:font];
        [_namelbl setFont:font];
        
        
        [self addSubview:_desclbl];
        [self addSubview:_namelbl];
        [self addSubview:_refreshImgView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat sepWidth = _padding;
    CGFloat originX =  sepWidth;
    [_desclbl setFrame:CGRectMake(originX, 0, _labelWidth, height)];
    originX += _labelWidth + sepWidth;
    
    [_namelbl setFrame:CGRectMake(originX, 0, (width-originX*2), height)];
    
    [_refreshImgView setFrame:CGRectMake(width-_padding-_imgWidth, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    
    
    [self updateInfo];
    
}

- (void) updateInfo {
    if(_name) {
        [_namelbl setText:_name];
    }
    if(_editable) {
        [_refreshImgView setHidden:NO];
    } else {
        [_refreshImgView setHidden:YES];
    }
}

- (void) setInfoWith:(NSString *) name {
    _name = [name copy];
    [self updateViews];
}

- (void) setShowBound:(BOOL)show {
    if(show) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    } else {
        self.layer.borderWidth = 0;
    }
}

- (void) setEditable:(BOOL) editable {
    _editable = editable;
    [self updateInfo];
}


- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:tapGesturRecognizer];
    }
    _listener = listener;
}

- (void) onClicked:(id) sender {
    if(_listener && _editable) {
        [_listener onClick:self];
    }
}

@end
