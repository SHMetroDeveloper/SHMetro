//
//  PatrolHistoryEquipmentContentItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistoryEquipmentContentItemView.h"
#import "BaseLabelView.h"
#import "ColorLabel.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"
#import "UIButton+Bootstrap.h"
#import "PatrolServerConfig.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "PhotoItem.h"


@interface PatrolHistoryEquipmentContentItemView ()

@property (readwrite, nonatomic, strong) BaseLabelView * titleBaseLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * resultBaseLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * descBaseLbl;

@property (readwrite, nonatomic, strong) ColorLabel * ignoreLbl;
@property (readwrite, nonatomic, strong) ColorLabel * exceptionLbl;

@property (readwrite, nonatomic, strong) UIButton * imgBtn;
@property (readwrite, nonatomic, strong) UIButton * processBtn;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSString * result;
@property (readwrite, nonatomic, strong) NSString * desc;
@property (readwrite, nonatomic, strong) NSMutableArray * photoArray;

@property (readwrite, nonatomic, assign) BOOL showPhoto;
@property (readwrite, nonatomic, assign) BOOL showIgnore;
@property (readwrite, nonatomic, assign) BOOL showException;    //是否异常
@property (readwrite, nonatomic, assign) BOOL processed;        //是否已处理
@property (readwrite, nonatomic, assign) BOOL showReport;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;
@property (readwrite, nonatomic, assign) CGFloat imgHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end


@implementation PatrolHistoryEquipmentContentItemView

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
        
        _showPhoto = YES;
        _showIgnore = YES;
        _showException = YES;
        _showReport = YES;
        
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        _labelWidth = 0;
        
        _btnHeight = [FMSize getInstance].btnHeight/4*3;
        _btnWidth = [FMSize getInstance].btnWidth/4*3;
        _imgWidth = [FMSize getInstance].cameraImageWidth;
        _imgHeight = [FMSize getInstance].cameraImageHeight;
        _defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _titleBaseLbl = [[BaseLabelView alloc] init];
        [_titleBaseLbl setContentColor:contentColor];
        [_titleBaseLbl setContentFont:mFont];

        _resultBaseLbl = [[BaseLabelView alloc] init];
        [_resultBaseLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_content_result" inTable:nil] andLabelWidth:0];
        [_resultBaseLbl setLabelFont:mFont andColor:labelColor];
        [_resultBaseLbl setContentFont:mFont];
        [_resultBaseLbl setContentColor:contentColor];
        [_resultBaseLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _descBaseLbl = [[BaseLabelView alloc] init];
        [_descBaseLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_content_desc" inTable:nil] andLabelWidth:0];
        [_descBaseLbl setLabelFont:mFont andColor:labelColor];
        [_descBaseLbl setContentFont:mFont];
        [_descBaseLbl setContentColor:contentColor];
        [_descBaseLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _ignoreLbl = [[ColorLabel alloc] init];
        [_ignoreLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        [_ignoreLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
        
        _exceptionLbl = [[ColorLabel alloc] init];
        [_exceptionLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        [_exceptionLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
        
        _imgBtn = [[UIButton alloc] init];
        [_imgBtn setImage:[[FMTheme getInstance] getImageByName:@"default"] forState:UIControlStateNormal];
        [_imgBtn addTarget:self action:@selector(showPhotoOfContent) forControlEvents:UIControlEventTouchUpInside];
        _imgBtn.tag = PATROL_HISTORY_CONTENT_ITEM_EVENT_SHOW_PHOTO;
        
        _processBtn = [[UIButton alloc] init];
        [_processBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"patrol_item_operate" inTable:nil] forState:UIControlStateNormal];
        [_processBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        _processBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] CGColor];
        _processBtn.layer.borderWidth = [FMSize getInstance].btnBorderWidth;
        _processBtn.layer.cornerRadius = [FMSize getInstance].btnBorderRadius;
        [_processBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        [_processBtn addTarget:self action:@selector(onReportButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _processBtn.tag = PATROL_HISTORY_CONTENT_ITEM_EVENT_PROCESS;
        
        [self addSubview:_titleBaseLbl];
        [self addSubview:_resultBaseLbl];
        [self addSubview:_descBaseLbl];
        
        [self addSubview:_ignoreLbl];
        [self addSubview:_exceptionLbl];
        
        [self addSubview:_imgBtn];
        [self addSubview:_processBtn];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    UIFont * mFont = [FMFont getInstance].font38;
    CGSize ignoreSize = CGSizeMake(0, 0);
    CGSize exceptionSize = CGSizeMake(0, 0);
    CGFloat originX = width - _paddingRight;
    
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    
    CGFloat sepHeight = 8;
    CGFloat sepWidth = 5;
    CGFloat resultWidth = width / 2 + 40;
    CGFloat paddingTop = 13;
    
    CGFloat originY = paddingTop;
    CGFloat btnWidth = 0;
    
    
    if(_showException) {
        exceptionSize = [ColorLabel calculateSizeByInfo:[self getExceptionDescription]];
        originX -= exceptionSize.width;
        [_exceptionLbl setFrame:CGRectMake(originX, originY, exceptionSize.width, exceptionSize.height)];
        originX -= sepWidth;
        [_exceptionLbl setHidden:NO];
        [_descBaseLbl setHidden:NO];
    } else {
        [_exceptionLbl setHidden:YES];
        [_descBaseLbl setHidden:YES];
    }
    
    if(_showIgnore) {
        ignoreSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
        originX -= ignoreSize.width;
        [_ignoreLbl setFrame:CGRectMake(originX, originY, ignoreSize.width, ignoreSize.height)];
        originX -= sepWidth;
        [_ignoreLbl setHidden:NO];
    } else {
        [_ignoreLbl setHidden:YES];
    }
    
    if(_showReport) {
        btnWidth = _btnWidth;
    }
    

    itemHeight = [BaseLabelView calculateHeightByInfo:_title font:mFont desc:nil labelFont:nil andLabelWidth:0 andWidth:originX];
    if(itemHeight < _defaultItemHeight) {
        itemHeight = _defaultItemHeight;
    }
    
    [_titleBaseLbl setFrame:CGRectMake(0, originY, originX, itemHeight)];
    if(_showException) {
        [_exceptionLbl setFrame:CGRectMake(originX, originY + (itemHeight - exceptionSize.height)/2, exceptionSize.width, exceptionSize.height)];
    }
    
    if(_showIgnore) {
        [_ignoreLbl setFrame:CGRectMake(originX, originY+ (itemHeight - ignoreSize.height)/2, ignoreSize.width, ignoreSize.height)];
    }
    originY += itemHeight + sepHeight;
    
    if(_showPhoto) {
        [_imgBtn setFrame:CGRectMake(resultWidth, originY, _imgWidth, _imgHeight)];
        [_imgBtn setHidden:NO];
    } else {
        [_imgBtn setHidden:YES];
    }
    itemHeight = [BaseLabelView calculateHeightByInfo:_result font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"patrol_content_result" inTable:nil] labelFont:mFont andLabelWidth:_labelWidth andWidth:resultWidth];
    if(itemHeight < _defaultItemHeight) {
        itemHeight = _defaultItemHeight;
    }
    [_resultBaseLbl setFrame:CGRectMake(0, originY, resultWidth, itemHeight)];
    
    originY += itemHeight + sepHeight;
    
    originX = width-_paddingRight;
    if(_showReport) {
        [_processBtn setFrame:CGRectMake(width-_paddingRight-btnWidth, height-sepHeight-_btnHeight, btnWidth, _btnHeight)];
        originX -= _btnWidth;
        [_processBtn setHidden:NO];
    } else {
        [_processBtn setHidden:YES];
    }
    
    itemHeight = [BaseLabelView calculateHeightByInfo:_desc font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"patrol_content_desc" inTable:nil] labelFont:mFont andLabelWidth:_labelWidth andWidth:originX];
    if(itemHeight < _defaultItemHeight) {
        itemHeight = _defaultItemHeight;
    }
    [_descBaseLbl setFrame:CGRectMake(0, originY, originX, itemHeight)];
    if(_showReport) {
        [_processBtn setFrame:CGRectMake(width-_paddingRight-_btnWidth, originY + (itemHeight - _btnHeight)/2, _btnWidth, _btnHeight)];
    }
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (void) updateInfo {
    [_titleBaseLbl setContent:_title];
    [_resultBaseLbl setContent:_result];
    [_descBaseLbl setContent:_desc];
    [_exceptionLbl setContent:[self getExceptionDescription]];
}


- (void) setInfoWithTitle:(NSString *) title
                andResult:(NSString *) result
                     desc:(NSString *) desc
                 hasPhoto:(BOOL) hasPhoto
                hasIgnore:(BOOL) hasIgnore
             hasException:(BOOL) hasException
             hasProcessed:(BOOL) hasProcessed
               showReport:(BOOL) showReport {
    
    _showPhoto = hasPhoto;
    _showIgnore = hasIgnore;
    _showException = hasException;
    _showReport = showReport;
    _processed = hasProcessed;
    
    if(![FMUtils isStringEmpty:title]) {
        _title = [title copy];
    } else {
        _title = @"";
    }
    
    if(![FMUtils isStringEmpty:result]) {
        _result = result;
    } else {
        _result = @"";
    }
    
    if(![FMUtils isStringEmpty:desc]) {
        _desc = desc;
    } else {
        _desc = @"";
    }
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    
    [self updateViews];
}

- (NSString *) getExceptionDescription {
    NSString * res = @"";
    if(_showException) {
        if(_processed) {
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_status_exception_processed" inTable:nil];
        } else {
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil];
        }
    }
    return res;
}

- (void) setImages:(NSMutableArray *) imgArray {
    if(imgArray) {
        NSString * token = [[SystemConfig getOauthFM] getToken].mAccessToken;
        if(!_photoArray) {
            _photoArray = [[NSMutableArray alloc] init];
        } else {
            [_photoArray removeAllObjects];
        }
        for(id item in imgArray) {
            PhotoItem * photo = [[PhotoItem alloc] init];
            if([item isKindOfClass:[NSNumber class]]) { //图片id
                NSNumber * imgId = item;
                NSURL * url = [FMUtils getUrlOfImageById:imgId];
                [photo setUrl:url];
            } else if([item isKindOfClass:[NSString class]]) {//本地图片名字
                NSString * name = item;
                UIImage * img = [FMUtils getImageWithName:name];
                [photo setImage:img];
            } else if([item isKindOfClass:[UIImage class]]) {
                UIImage * img = item;
                [photo setImage:img];
            }
            [_photoArray addObject:photo];
        }
        [self updateViews];
    }
}

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}


- (void) onReportButtonClicked {
    if(_listener) {
        [_listener onItemClick:self subView:_processBtn];
    }
}


- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
}


- (void) showPhotoOfContent {
    if(_listener) {
        [_listener onItemClick:self subView:_imgBtn];
    }
}


//计算所需的高度
+ (CGFloat) calculateHeightByTitle:(NSString *) title
                         andResult:(NSString *) result
                           andDesc:(NSString *) desc
                          andWidth:(CGFloat) width
                        showIgnore:(BOOL) showIgnore
                     showException:(BOOL) showException
                  showReportButton:(BOOL) showReport {
    
    CGFloat height = 0;
    
    UIFont * mFont = [FMFont getInstance].font38;

    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat sepHeight = 8;
    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    CGFloat paddingRight = paddingLeft;
    CGFloat btnWidth = [FMSize getInstance].btnWidth/4*3;
    CGFloat descWidth = width -paddingRight;
    CGFloat titleWidth = width -paddingRight;
    CGFloat sepWidth = 5;
    CGFloat paddingTop = 13;
    CGFloat resultWidth = width / 2 + 40;
    
    UILabel * testLbl = [[UILabel alloc] init];
    testLbl.font = mFont;
    
    if(showIgnore) {
        CGSize ignoreSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
        titleWidth -= ignoreSize.width + sepWidth;
    }
    if(showException) {
        CGSize exceptionSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
        titleWidth -= exceptionSize.width + sepWidth;
    }
    if(showReport) {
        descWidth -= btnWidth;
    }
    
    CGFloat titleHeight = [BaseLabelView calculateHeightByInfo:title font:mFont desc:nil labelFont:nil andLabelWidth:0 andWidth:titleWidth];
    if(titleHeight < defaultItemHeight) {
        titleHeight = defaultItemHeight;
    }
    
    CGFloat resultHeight = [BaseLabelView calculateHeightByInfo:result font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"patrol_content_result" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:resultWidth];
    if(resultHeight < defaultItemHeight) {
        resultHeight = defaultItemHeight;
    }
    
    height += resultHeight + titleHeight + sepHeight + paddingTop * 2;
    
    CGFloat descHeight = 0;
    if(showException) {
        descHeight = [BaseLabelView calculateHeightByInfo:desc font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"patrol_content_desc" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-paddingRight-btnWidth];
        if(descHeight < defaultItemHeight) {
            descHeight = defaultItemHeight;
        }
        height += descHeight + sepHeight;
    }
    
    return height;
  
}

@end
