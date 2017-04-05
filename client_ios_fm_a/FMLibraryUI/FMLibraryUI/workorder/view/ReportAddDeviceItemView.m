//
//  ReportAddDeviceItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ReportAddDeviceItemView.h"

#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "BaseLabelView.h"
#import "UIButton+Bootstrap.h"
#import "FMSize.h"
#import "FMFont.h"



@interface ReportAddDeviceItemView ()

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingRight;  //文本框到右边界的距离宽度
@property (readwrite, nonatomic, assign) CGFloat paddingTop;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;  //文本框到右边界的距离宽度

@property (readwrite, nonatomic, assign) BOOL showBounds;

@property (readwrite, nonatomic, strong) BaseLabelView * codeView;
@property (readwrite, nonatomic, strong) BaseLabelView * nameView;
@property (readwrite, nonatomic, strong) BaseLabelView * locationView;
@property (readwrite, nonatomic, strong) UIButton * deleteBtn;
@property (readwrite, nonatomic, strong) UIImageView * deleteImgView;

@property (readwrite, nonatomic, strong) NSString * code;       //编码
@property (readwrite, nonatomic, strong) NSString * name;       //名字
@property (readwrite, nonatomic, strong) NSString * location;   //位置


@property (readwrite, nonatomic, assign) CGFloat btnWidth;  //按钮宽度
@property (readwrite, nonatomic, assign) CGFloat imgWidth;  //图片宽度
@property (readwrite, nonatomic, assign) CGFloat labelWidth;  //按钮宽度

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) BOOL editable;

@property (readwrite, nonatomic, strong) id<OnClickListener> clickListener;
@property (readwrite, nonatomic, strong) id<OnListItemButtonClickListener> deleteListener;
@end

@implementation ReportAddDeviceItemView

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
        [self updateSubviews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubviews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _paddingLeft = 0;       //默认左边距为 5
        _paddingRight = 0;      //默认右边距为 5
        _paddingTop = 5;        //默认上边距
        _paddingBottom = 5;     //默认下边距
        _btnWidth = 48;
        _imgWidth = [FMSize getInstance].imgWidthLevel2;
        _labelWidth = 90;
        _editable = NO;
        
        _defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
        
        _showBounds = NO;
        
        CGRect frame = self.frame;
        CGFloat width = CGRectGetWidth(frame);
        CGFloat originY = 0;
        UIFont * mFont = [FMFont getInstance].defaultFontLevel2;
        UIColor * mColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL];
        
        _codeView = [[BaseLabelView alloc] init];
        _nameView = [[BaseLabelView alloc] init];
        _locationView = [[BaseLabelView alloc] init];
        _deleteBtn = [[UIButton alloc] init];
        
        [_codeView setLabelFont:mFont andColor:mColor];
        [_nameView setLabelFont:mFont andColor:mColor];
        [_locationView setLabelFont:mFont andColor:mColor];
        
        [_codeView setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_code" inTable:nil] andLabelWidth:_labelWidth];
        [_nameView setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_name" inTable:nil] andLabelWidth:_labelWidth];
        [_locationView setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_location" inTable:nil] andLabelWidth:_labelWidth];
        
        
        UIImage* deleteImg = [[FMTheme getInstance] getImageByName:@"icon_delete_gray"];
        _deleteImgView = [[UIImageView alloc] init];
        [_deleteImgView setImage:deleteImg];
        
//        _deleteImgView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
//        _deleteBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
        [_deleteBtn addSubview:_deleteImgView];
        [_deleteBtn addTarget:self action:@selector(onDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_codeView];
        [self addSubview:_nameView];
        [self addSubview:_locationView];
        [self addSubview:_deleteBtn];
    }
}


- (void) updateSubviews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat originY = _paddingTop;
    CGFloat itemHeight = 0;
    CGFloat btnWidth = 0;
    if(width ==0 || height == 0) {
        return;
    }
    
    itemHeight = _defaultItemHeight;
    [_codeView setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = _defaultItemHeight;
    [_nameView setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    if(_editable) {
        btnWidth = _btnWidth;
    }
    itemHeight = [BaseLabelView calculateHeightByInfo:_location font:nil desc:[[BaseBundle getInstance] getStringByKey:@"order_equipment_location" inTable:nil] labelFont:nil andLabelWidth:_labelWidth andWidth:width-_paddingLeft-_paddingRight-btnWidth];
    if(itemHeight < _defaultItemHeight) {
        itemHeight = _defaultItemHeight;
    }
    [_locationView setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight-btnWidth, itemHeight)];
    
    CGFloat imgPadding = (btnWidth - _imgWidth) / 2;
    [_deleteImgView setFrame:CGRectMake(imgPadding, imgPadding, _imgWidth, _imgWidth)];
    [_deleteBtn setFrame:CGRectMake(width-_paddingRight-btnWidth, height-_paddingBottom-btnWidth, btnWidth, btnWidth)];
    originY += itemHeight + _paddingBottom;
    
    [self updateInfo];
}

- (void) updateInfo {
    [_codeView setContent:_code];
    [_nameView setContent:_name];
    [_locationView setContent:_location];
}


- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom {
    _paddingLeft = left;
    _paddingRight = right;
    _paddingTop = top;
    _paddingBottom = bottom;
    [self updateSubviews];
}

- (void) setInfoWithDeviceCode:(NSString *) code name:(NSString *) name location:(NSString *) location {
    
    if(code) {
        _code = code;
    }
    if(name) {
        _name = name;
    }
    if(location) {
        _location = location;
    }
    [self updateSubviews];
}





- (void) setEditable:(BOOL) editable {
    _editable = editable;
    [self updateSubviews];
}

- (void) setOnClickListener:(id<OnClickListener>)listener {
    if(listener) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicked)];
        
        [self addGestureRecognizer:tapGesture];
    }
    _clickListener = listener;
}

- (void) setOnDeleteListener:(id<OnListItemButtonClickListener>) listener {
    _deleteListener = listener;
}

- (void) onDeleteButtonClicked:(UIView *) v {
    if(_editable && _deleteListener) {
        [_deleteListener onButtonClick:self view:_deleteBtn];
    }
}

- (void) onClicked {
    if(_editable && _clickListener) {
        [_clickListener onClick:self];
    }
}

+ (CGFloat) calculateHeightByInfo:(NSDictionary *) info andWidth:(CGFloat) width andEditable:(BOOL) editable{
    CGFloat height = 0;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat paddingLeft = 5;
    CGFloat paddingRight = 5;
    CGFloat paddingTop = 5;
    CGFloat paddingBottom = 5;
    CGFloat btnWidth = 48;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat labelWidth = 90;
    if(!editable) {
        btnWidth = 0;
    }
    
    NSString * location = [info valueForKeyPath:@"location"];
    CGFloat locationHeight = [BaseLabelView calculateHeightByInfo:location font:nil desc:[[BaseBundle getInstance] getStringByKey:@"order_equipment_location" inTable:nil] labelFont:nil andLabelWidth:labelWidth andWidth:width-paddingLeft-paddingRight-btnWidth];
    if(locationHeight < defaultItemHeight) {
        locationHeight = defaultItemHeight;
    }
    height = defaultItemHeight * 2 + locationHeight + sepHeight * 2 + paddingTop + paddingBottom;
    
    return height;
}

@end

