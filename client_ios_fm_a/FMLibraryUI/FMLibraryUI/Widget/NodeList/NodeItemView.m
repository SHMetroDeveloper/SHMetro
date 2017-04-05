//
//  NodeItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "NodeItemView.h"
#import "FMUtilsPackages.h"
#import "ColorLabel.h"
#import "BaseDataEntity.h"
#import "FMTheme.h"
#import "BaseBundle.h"


@interface NodeItemView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;             //名字
@property (readwrite, nonatomic, strong) UILabel * descLbl;             //说明
@property (readwrite, nonatomic, strong) UIImageView * moreImgView;     //右侧 > 图标

@property (readwrite, nonatomic, strong) UIImageView * checkView;     //是否已选按钮
@property (readwrite, nonatomic, strong) NSNumber *isChecked;      //是否已选

@property (readwrite, nonatomic, strong) UILabel *noticeLbl;     //数量提醒
@property (readwrite, nonatomic, strong) NSNumber *materialAmount;      //物料库存数量
@property (readwrite, nonatomic, strong) NSString *noticeString;

@property (readwrite, nonatomic, assign) BOOL on;                       //是否显示右侧图标

@property (readwrite, nonatomic, assign) CGFloat imgWidth;              //右侧图标宽度

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, strong) UIFont * nameFont;
@property (readwrite, nonatomic, strong) UIFont * msgFont;
@property (readwrite, nonatomic, strong) NodeItem * node;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation NodeItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSettings];
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initSettings];
        [self initViews];
        [self updateViews];
        
    }
    return self;
}




- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}


- (void) initSettings {
    _imgWidth = [FMSize getInstance].imgWidthLevel3;  //18
    _on = NO;
    
    _paddingLeft = [FMSize getInstance].defaultPadding;
    _paddingRight = _paddingLeft;
    _paddingTop = 0;
    _paddingBottom = 0;
    _nameFont = [FMFont getInstance].font42;
    _msgFont = [FMFont getInstance].defaultFontLevel3;
}


- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = _nameFont;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        
        _descLbl = [[UILabel alloc] init];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
        _descLbl.font = _msgFont;
        
        
        _moreImgView = [[UIImageView alloc] init];
        [_moreImgView setImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        _noticeLbl = [[UILabel alloc] init];
        _noticeLbl.font = _msgFont;
        _noticeLbl.textAlignment = NSTextAlignmentRight;
        _noticeLbl.hidden = YES;
        
        _checkView = [[UIImageView alloc] init];
        [_checkView setImage:[[FMTheme getInstance] getImageByName:@"checked_off"]];
        _checkView.hidden = YES;
        
        [self addSubview:_nameLbl];
        [self addSubview:_descLbl];
        [self addSubview:_moreImgView];
        [self addSubview:_noticeLbl];
        [self addSubview:_checkView];
    }
    
}


- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    CGFloat nameHeight = 0;
    CGFloat descHeight = 0;
    CGFloat sepHeight = 0;
    CGFloat spaceHeight = 0;        //名字距离上边距
    NSString * name = [_node getVal];
    NSString * desc = [_node getDesc];
    BOOL showDesc = ![FMUtils isStringEmpty:[_node getDesc]];
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, _paddingTop, width - _paddingLeft-_paddingRight-_imgWidth, height-_paddingTop-_paddingBottom)];
    
    nameHeight = [FMUtils heightForStringWith:_nameLbl value:name andWidth:width - _paddingLeft-_paddingRight-_imgWidth];
    if(showDesc) {
        sepHeight = 4;
        [_descLbl setFrame:CGRectMake(_paddingLeft, _paddingTop, width - _paddingLeft-_paddingRight-_imgWidth, height-_paddingTop-_paddingBottom)];
        descHeight = [FMUtils heightForStringWith:_descLbl value:desc andWidth:width - _paddingLeft-_paddingRight-_imgWidth];
    } else {
        descHeight = 0;
        sepHeight = 0;
    }
    
    
    CGSize noticeSize = [FMUtils getLabelSizeBy:_noticeLbl andContent:_noticeString andMaxLabelWidth:width];
    [_noticeLbl setFrame:CGRectMake(width-_paddingRight-noticeSize.width, (height-noticeSize.height)/2, noticeSize.width, noticeSize.height)];
    
    if (_on) {
        spaceHeight = (height - _paddingTop - _paddingBottom - nameHeight - descHeight - sepHeight) / 2;
        [_nameLbl setFrame:CGRectMake(_paddingLeft, _paddingTop+spaceHeight, width - _paddingLeft-_paddingRight-_imgWidth, nameHeight)];
        [_descLbl setFrame:CGRectMake(_paddingLeft, height - _paddingBottom - spaceHeight-descHeight, width - _paddingLeft-_paddingRight-_imgWidth, descHeight)];
    } else {
        spaceHeight = (height - _paddingTop - _paddingBottom - nameHeight - descHeight - sepHeight) / 2;
        [_nameLbl setFrame:CGRectMake(_paddingLeft, _paddingTop+spaceHeight, width - _paddingLeft-_paddingRight-noticeSize.width, nameHeight)];
        [_descLbl setFrame:CGRectMake(_paddingLeft, height - _paddingBottom - spaceHeight-descHeight, width - _paddingLeft-_paddingRight-noticeSize.width, descHeight)];
    }
    
    [_moreImgView setFrame:CGRectMake(width-_paddingRight-_imgWidth, (height-_imgWidth)/2, _imgWidth, _imgWidth)];

    [_checkView setFrame:CGRectMake(width-_paddingLeft-_imgWidth, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
}

- (void) updateMoreLabel {
    if(_on) {
        [_moreImgView setHidden:NO];
    } else {
        [_moreImgView setHidden:YES];
    }
    [self updateViews];
}

- (void) updateInfo {
    _nameLbl.text = [_node getVal];
    _descLbl.text = [_node getDesc];
    
    _noticeString = @"";
    if (_materialAmount) {
        _noticeLbl.hidden = NO;
        if (_materialAmount.doubleValue <= 0) {
            _noticeString =  [[BaseBundle getInstance] getStringByKey:@"inventory_no_stock" inTable:nil];;
            [_noticeLbl setText:_noticeString];
            [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        } else {
            _noticeString =  [[BaseBundle getInstance] getStringByKey:@"inventory_in_stock" inTable:nil];;
            [_noticeLbl setText:_noticeString];
            [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
        }
    } else {
        _noticeLbl.hidden = YES;
    }
    
    if (_isChecked) {
        _checkView.hidden = NO;
        if (_isChecked.boolValue) {
            [_checkView setImage:[[FMTheme getInstance] getImageByName:@"checked_on"]];
        } else {
            [_checkView setImage:[[FMTheme getInstance] getImageByName:@"checked_off"]];
        }
    } else {
        _checkView.hidden = YES;
    }
    
    [self updateViews];
}

- (void) setInfoWith:(NodeItem *)node {
    _node = node;
    [self updateInfo];
}

- (void) setShowMore:(BOOL) show {
    _on = show;
    [self updateMoreLabel];
}

- (void) setMaterialsAmount:(NSNumber *) amount {
    _materialAmount = [amount copy];
    [self updateInfo];
}

- (void) setChecked:(NSNumber *) isChecked {
    _isChecked = [isChecked copy];
    [self updateInfo];
}

@end

