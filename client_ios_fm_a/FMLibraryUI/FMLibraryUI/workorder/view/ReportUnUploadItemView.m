//
//  ReportUnUploadItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ReportUnUploadItemView.h"

#import "FMUtils.h"
#import "FMTheme.h"
#import "MarkEditView.h"
#import "UIButton+Bootstrap.h"
#import "BaseLabelView.h"
#import "BaseDataDownloader.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseBundle.h"


@interface ReportUnUploadItemView ()

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingRight;  //文本框到右边界的距离宽度
@property (readwrite, nonatomic, assign) CGFloat paddingTop;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;  //文本框到右边界的距离宽度


@property (readwrite, nonatomic, strong) BaseLabelView * stypeLbl;            //服务类型
@property (readwrite, nonatomic, strong) BaseLabelView * locationLbl;        //位置
@property (readwrite, nonatomic, strong) BaseLabelView * workContentLbl;     //工作内容
@property (readwrite, nonatomic, strong) BaseLabelView * statusLbl;           //上传状态

@property (readwrite, nonatomic, strong) NSString * stype;  //
@property (readwrite, nonatomic, strong) NSString * location;  //
@property (readwrite, nonatomic, strong) NSString * workContent;  //

@property (readwrite, nonatomic, assign) NSInteger status;

@property (readwrite, nonatomic, strong) UIButton * uploadBtn;

@property (readwrite, nonatomic, assign) CGFloat btnWidth;  //按钮宽度
@property (readwrite, nonatomic, assign) CGFloat btnHeight;  //按钮高度

@property (readwrite, nonatomic, assign) CGFloat labelWidth;  //状态标签宽度
@property (readwrite, nonatomic, assign) CGFloat statusWidth;  //上传状态宽度


@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, strong) id<OnListItemButtonClickListener> btnListener;
@end

@implementation ReportUnUploadItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initSubViews];
        [self updateSubviews];
    }
    return self;
}


- (void) initSubViews {
    if(!_isInited) {
        _isInited = YES;
        
        _paddingLeft = [FMSize getInstance].defaultPadding;;       //默认左边距为 5
        _paddingRight = _paddingLeft;      //默认右边距为
        _paddingTop = _paddingLeft;        //默认上边距
        _paddingBottom = _paddingLeft;     //默认下边距
        _btnWidth = [FMSize getInstance].btnWidth;
        _btnHeight = [FMSize getInstance].btnHeight;
        _labelWidth = 70;
        _statusWidth = 80;
        
        _stypeLbl = [[BaseLabelView alloc] init];
        _workContentLbl = [[BaseLabelView alloc] init];
        _locationLbl = [[BaseLabelView alloc] init];
        
        _statusLbl = [[BaseLabelView alloc] init];
        _uploadBtn = [[UIButton alloc] init];
        
        [_stypeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"report_service_type" inTable:nil] andLabelWidth:_labelWidth];
        [_workContentLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"report_content" inTable:nil] andLabelWidth:_labelWidth];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"report_location" inTable:nil] andLabelWidth:_labelWidth];
        
        [_uploadBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_upload" inTable:nil] forState:UIControlStateNormal];
        [_uploadBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        
        
        [_uploadBtn addTarget:self action:@selector(onUploadButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _uploadBtn.tag = TAG_BUTTON_TYPE_UPLOAD_REPORT;
        [_statusLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        
        [self addSubview:_stypeLbl];
        [self addSubview:_workContentLbl];
        [self addSubview:_locationLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_uploadBtn];
    }
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubviews];
}

- (void) updateStatus {
    switch(_status) {
        case BASE_TASK_STATUS_INIT:
            [_statusLbl setContent:[[BaseBundle getInstance] getStringByKey:@"upload_waitting" inTable:nil]];
            [_statusLbl setHidden:NO];
            [_uploadBtn setHidden:YES];
            break;
        case BASE_TASK_STATUS_HANDLING:
            [_statusLbl setContent:[[BaseBundle getInstance] getStringByKey:@"upload_uploading" inTable:nil]];
            [_statusLbl setHidden:NO];
            [_uploadBtn setHidden:YES];
            break;
        case BASE_TASK_STATUS_FINISH_SUCCESS:
            [_statusLbl setContent:[[BaseBundle getInstance] getStringByKey:@"upload_success" inTable:nil]];
            [_statusLbl setHidden:NO];
            [_uploadBtn setHidden:YES];
            break;
        case BASE_TASK_STATUS_FINISH_FAIL:
            [_statusLbl setContent:[[BaseBundle getInstance] getStringByKey:@"upload_fail" inTable:nil]];
            [_statusLbl setHidden:NO];
            [_uploadBtn setHidden:YES];
            break;
        default:
            [_statusLbl setHidden:YES];
            [_uploadBtn setHidden:NO];
            break;
    }
}

- (void) updateSubviews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat originY = _paddingTop;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    
    CGFloat itemHeight = 0;
    
    originY = sepHeight;
    
    itemHeight = defaultItemHeight;
    [_stypeLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = [BaseLabelView calculateHeightByInfo:_workContent font:nil desc:[[BaseBundle getInstance] getStringByKey:@"report_content" inTable:nil] labelFont:nil andLabelWidth:_labelWidth andWidth:width-_paddingLeft-_paddingRight];
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_workContentLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft- _paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = [BaseLabelView calculateHeightByInfo:_location font:nil desc:[[BaseBundle getInstance] getStringByKey:@"report_location" inTable:nil] labelFont:nil andLabelWidth:_labelWidth andWidth:width-_paddingLeft-_paddingRight-_btnWidth];
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_locationLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft- _paddingRight-_btnWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    
    [_uploadBtn setFrame:CGRectMake(width - _paddingRight - _btnWidth, originY-sepHeight-_btnHeight, _btnWidth, _btnHeight)];
    [_statusLbl setFrame:CGRectMake(width - _paddingRight - _statusWidth, sepHeight, _statusWidth, _btnHeight)];
    
    [_uploadBtn defaultStyle];
    _uploadBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] CGColor];
    [_uploadBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
    
    [self updateStatus];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_stypeLbl setContent:_stype];
    [_workContentLbl setContent:_workContent];
    [_locationLbl setContent:_location];
}


- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom {
    _paddingLeft = left;
    _paddingRight = right;
    _paddingTop = top;
    _paddingBottom = bottom;
    [self updateSubviews];
}


- (void) setInfoWithServiceType:(NSString *)stype andContent:(NSString *) workContent andLocation:(NSString *) location andStatus:(NSInteger)status {
    _status = status;
    _stype = stype;
    _workContent = workContent;
    _location = location;
    _status = status;
    [self updateSubviews];
}


- (void) onUploadButtonClicked {
    if(_btnListener) {
        [_btnListener onButtonClick:self view:_uploadBtn];
    }
}
- (void) onDeleteButtonClicked {
    if(_btnListener) {
    }
}



- (CGFloat) getCurrentHeight {
    CGFloat inputHeight = 0;
    
    inputHeight += _paddingTop + _paddingBottom;
    return inputHeight;
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if([view isKindOfClass:[ResizeableView class]]) {
        CGRect frame = view.frame;
        if(frame.size.width != newSize.width || frame.size.height != newSize.height) {
            CGFloat height = self.frame.size.height - frame.size.height + newSize.height;
            CGFloat width = self.frame.size.width;
            frame.size = newSize;
            view.frame = frame;
            
            [self updateSubviews];
            //
            if(self.resizeListener) {
                [self.resizeListener onViewSizeChanged:self newSize:CGSizeMake(width, height)];
            }
        }
        
    }
}

- (void) setOnListItemButtonClickListener:(id<OnListItemButtonClickListener>)listener {
    _btnListener = listener;
}

+ (CGFloat) calculateHeightByContent:(NSString *) workContent andLocation:(NSString *) location withWidth:(CGFloat) width{
    CGFloat height = 0;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat labelWidth = 70;
    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    CGFloat paddingRight = paddingLeft;
    CGFloat btnWidth = [FMSize getInstance].btnWidth;
    
    
    CGFloat contentHeight = [BaseLabelView calculateHeightByInfo:workContent font:nil desc:[[BaseBundle getInstance] getStringByKey:@"report_content" inTable:nil] labelFont:nil andLabelWidth:labelWidth andWidth:width-paddingLeft-paddingRight];
    if(contentHeight < defaultItemHeight) {
        contentHeight = defaultItemHeight;
    }
    CGFloat locationHeight = [BaseLabelView calculateHeightByInfo:location font:nil desc:[[BaseBundle getInstance] getStringByKey:@"report_location" inTable:nil] labelFont:nil andLabelWidth:labelWidth andWidth:width-paddingLeft-paddingRight-btnWidth];
    if(locationHeight < defaultItemHeight) {
        locationHeight = defaultItemHeight;
    }
    height = defaultItemHeight + locationHeight + contentHeight + sepHeight * 4;
    return height;
}

@end


