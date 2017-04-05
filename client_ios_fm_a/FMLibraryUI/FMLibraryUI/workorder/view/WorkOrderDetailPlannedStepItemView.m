//
//  WorkOrderDetailPlannedStepItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderDetailPlannedStepItemView.h"
#import "FMColor.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "BaseLabelView.h"
#import "UIButton+Bootstrap.h"
#import "WorkOrderServerConfig.h"
#import "BaseTextView.h"
#import "FMTheme.h"
#import "BasePhotoView.h"

@interface WorkOrderDetailPlannedStepItemView () <OnMessageHandleListener>

@property (readwrite, nonatomic, strong) WorkOrderStep * step;
@property (readwrite, nonatomic, assign) BOOL editable;   //   是否能编辑

@property (readwrite, nonatomic, strong) UILabel * indexLbl;    //顺序
@property (readwrite, nonatomic, strong) UILabel * workTeamLbl; //工作组
@property (readwrite, nonatomic, strong) UILabel * finishedLbl; //是否完成
@property (readwrite, nonatomic, strong) BaseLabelView * stepLbl;     //步骤
@property (readwrite, nonatomic, strong) BaseLabelView * descLbl;     //描述
@property (readwrite, nonatomic, strong) UIImageView * editImgView;   //可编辑标签
@property (readwrite, nonatomic, strong) BasePhotoView * photoView;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;
@property (readwrite, nonatomic, assign) CGFloat imgHeight;

@property (readwrite, nonatomic, assign) CGFloat indexWidth;
@property (readwrite, nonatomic, assign) CGFloat finishWidth;

@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, strong) UIFont * msgFont;
@property (readwrite, nonatomic, strong) UIFont * statusFont;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation WorkOrderDetailPlannedStepItemView

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
    [self updateSubViews];
}

- (void) initViews {
    if(!_isInited) {
        _msgFont = [FMFont fontWithSize:13];
        _statusFont = [FMFont fontWithSize:11];
        _labelWidth = 0;
        
        _indexWidth = 100;
        _finishWidth = 60;
        _padding = 17;
        
        
        _indexLbl = [[UILabel alloc] init];
        _stepLbl = [[BaseLabelView alloc] init];
        _workTeamLbl = [[UILabel alloc] init];
        _finishedLbl = [[UILabel alloc] init];
        _descLbl = [[BaseLabelView alloc] init];
        //        _finishedImgView = [[UIImageView alloc] init];
        _editImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"edit_full"]];
        
        _indexLbl.font = _msgFont;
        _workTeamLbl.font = _msgFont;
        _finishedLbl.font = _statusFont;
        
        _finishedLbl.textAlignment = NSTextAlignmentRight;
        
        _indexLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _workTeamLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        _imgWidth = [FMSize getInstance].imgWidthLevel2;
        _imgHeight = [FMSize getInstance].imgWidthLevel2;
        
        [_stepLbl setContentFont:_msgFont];
        [_stepLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        
        [_descLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_step_work_desc" inTable:nil] andLabelWidth:_labelWidth];
        
        [_descLbl setLabelFont:_msgFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        [_descLbl setContentFont:_msgFont];
        [_descLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        
        _photoView = [[BasePhotoView alloc] init];
        [_photoView setEditable:NO];
        [_photoView setEnableAdd:NO];
        [_photoView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
        [_photoView setOnMessageHandleListener:self];
        
        
        [self addSubview:_indexLbl];
        [self addSubview:_stepLbl];
        [self addSubview:_workTeamLbl];
        [self addSubview:_descLbl];
        [self addSubview:_finishedLbl];
        [self addSubview:_photoView];
//        [self addSubview:_editImgView];
    }
}

- (void) updateSubViews {
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat originY = 0;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat itemHeight = 0;
    CGFloat sepWidth = 60;
    CGFloat paddingTop = 10;
    CGFloat paddingBottom = paddingTop;
    CGFloat finishWidth = 0;
    
    //步骤顺序
    originY = paddingTop;
    itemHeight = defaultItemHeight;
    [_indexLbl setFrame:CGRectMake(_padding, originY, _indexWidth, itemHeight)];
    
    //编辑铅笔图片
    if (_editable) {
        [_editImgView setHidden:NO];
        [_editImgView setFrame:CGRectMake(width - _padding - itemHeight, originY + (itemHeight - itemHeight/2)/2, itemHeight/2, itemHeight/2)];
    } else {
        [_editImgView setHidden:YES];
    }
    
    //工程组
    [_workTeamLbl setFrame:CGRectMake(_padding + _indexWidth + sepWidth, originY, width-_padding * 2-_indexWidth-_finishWidth-sepWidth, itemHeight)];
    
    finishWidth = [FMUtils widthForString:_finishedLbl value:[self getFinishDesc]];
    [_finishedLbl setFrame:CGRectMake(width - _padding - _finishWidth, originY, finishWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    //步骤
    itemHeight = 0;
    if(![FMUtils isStringEmpty:_step.step]) {
        itemHeight = [BaseLabelView calculateHeightByInfo:_step.step font:_msgFont desc:nil labelFont:nil andLabelWidth:0 andWidth:width];
    }
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_stepLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    //工作描述
    itemHeight = 0;
    if(![FMUtils isStringEmpty: _step.comment]) {
        itemHeight = [BaseLabelView calculateHeightByInfo:_step.comment font:_msgFont desc:[[BaseBundle getInstance] getStringByKey:@"order_step_work_desc" inTable:nil] labelFont:_msgFont andLabelWidth:_labelWidth andWidth:width];
    }
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_descLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    CGFloat photoHeight = [BasePhotoView calculateHeightByCount:[_step.photos count] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
    [_photoView setFrame:CGRectMake(0, originY, width, photoHeight)];
    originY += itemHeight + paddingBottom;
    
    [self updateInfo];
}

- (void) setEditable:(BOOL) editable {
    _editable = editable;
    [self updateSubViews];
}

- (void) setInfoWithStep:(WorkOrderStep *) step {
    _step = step;
    [self updateSubViews];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
//    _paddingLeft = paddingLeft;
//    _paddingRight = paddingRight;
    _padding = paddingLeft;
    [self updateSubViews];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (NSString *) getFinishDesc {
    NSString * desc = @"";
    if(_step.finished) {
        desc = [[BaseBundle getInstance] getStringByKey:@"order_step_finish_yes" inTable:nil];
    } else {
        desc = [[BaseBundle getInstance] getStringByKey:@"order_step_finish_no" inTable:nil];
    }
    return desc;
}

- (void) updateInfo {
    [_indexLbl setText:[_step getStepIndexDesc]];
    [_stepLbl setContent:_step.step];
    [_descLbl setContent:_step.comment];
    [_workTeamLbl setText:_step.workTeamName];
    [_finishedLbl setText:[self getFinishDesc]];
    if(_step.finished) {
        [_finishedLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
    } else {
        [_finishedLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK]];
    }
    [_photoView setPhotosWithArray:[_step getPhotoArray]];
}

#pragma mark -
- (void) handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([BasePhotoView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            PhotoActionType type = [tmpNumber integerValue];
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [self notifyShowPhoto:tmpNumber.integerValue];
                    break;
                case PHOTO_ACTION_TAKE_PHOTO:
                    NSLog(@"照片添加");
                    break;
            }
        }
    }
}

//通知显示大图
- (void) notifyShowPhoto:(NSInteger) position {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithInteger:position] forKeyPath:@"position"];
    [dict setValue:[_step getPhotoArray] forKeyPath:@"photosArray"];
    [self notifyEnvent:WO_PLANNED_STEP_EVENT_SHOW_PHOTO data:dict];
}

- (void) notifyEnvent:(WorkOrderPlannedStepEventType) type data:(id) data {
    if (_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:[NSNumber numberWithInteger:type] forKeyPath:@"msgType"];
        [msg setValue:[NSNumber numberWithInteger:self.tag] forKeyPath:@"tag"];
        [msg setValue:data forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

+ (CGFloat) calculateHeightByInfo:(WorkOrderStep *) step  andWidth:(CGFloat)width andPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight{
    CGFloat height = 0;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat labelWidth = 0;
    CGFloat stepHeight = 0;
    CGFloat contentHeight = 0;
    UIFont * font = [FMFont fontWithSize:13];
    CGFloat paddingTop = 10;
    CGFloat paddingBottom = paddingTop;
    
    if(![FMUtils isStringEmpty:step.step]) {

        stepHeight = [BaseLabelView calculateHeightByInfo:step.step font:font desc:nil labelFont:nil andLabelWidth:0 andWidth:width];
    }
    if(stepHeight < defaultItemHeight) {
        stepHeight = defaultItemHeight;
    }
    
    
    if(![FMUtils isStringEmpty:step.comment]) {
        contentHeight = [BaseLabelView calculateHeightByInfo:step.comment font:font desc:[[BaseBundle getInstance] getStringByKey:@"order_step_work_desc" inTable:nil] labelFont:font andLabelWidth:labelWidth andWidth:width];
    }
    if(contentHeight < defaultItemHeight) {
        contentHeight = defaultItemHeight;
    }
    
    CGFloat photoHeight = [BasePhotoView calculateHeightByCount:[step.photos count] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
    
    
    height = defaultItemHeight  + contentHeight + stepHeight + photoHeight + sepHeight * 3 + paddingTop + paddingBottom;
    
    return height;
}

@end




