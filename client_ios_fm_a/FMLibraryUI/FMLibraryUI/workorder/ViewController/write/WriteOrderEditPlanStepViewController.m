//
//  WriteOrderEditPlanStepViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WriteOrderEditPlanStepViewController.h"
#import "UIButton+Bootstrap.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "BaseTextView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "CaptionTextField.h"
#import "CaptionTextView.h"
#import "SeperatorView.h"
#import "WorkOrderBusiness.h"
#import "WorkOrderSaveEntity.h"
#import "BasePhotoView.h"
#import "CameraHelper.h"
#import "PhotoShowHelper.h"
#import "FileUploadService.h"

@interface WriteOrderEditPlanStepViewController () <OnMessageHandleListener, FileUploadListener>

@property(readwrite,nonatomic,strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) UIView * topContainerView; //是否完成
@property (readwrite, nonatomic, strong) UILabel * finishLbl;
@property (readwrite, nonatomic, strong) UISwitch * finishSwitch;
@property (readwrite, nonatomic, strong) SeperatorView * topSeperator;

@property (readwrite, nonatomic, strong) CaptionTextField * groupBaseTF;//工作组
@property (readwrite, nonatomic, strong) CaptionTextView * stepBaseTF;//步骤
@property (readwrite, nonatomic, strong) CaptionTextView * descBaseTF;  //描述
@property (readwrite, nonatomic, strong) BasePhotoView * photoView;  //图片

@property(readwrite,nonatomic,assign) CGFloat switchWidth;
@property(readwrite,nonatomic,assign) CGFloat switchHeight;

@property (readwrite, nonatomic, assign) CGFloat topHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultDescHeight;

@property(readwrite,nonatomic,assign) CGFloat realWidth;
@property(readwrite,nonatomic,assign) CGFloat realHeight;
@property(readwrite,nonatomic,assign) CGFloat paddingTop;

@property (readwrite, nonatomic, assign) BOOL finished;

@property(readwrite,nonatomic,strong) WorkOrderStep * step;

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;
@property (readwrite, nonatomic, strong) NSNumber * woId;

@property(nonatomic, strong) CameraHelper * cameraHelper;
@property(nonatomic, strong) PhotoShowHelper * photoHelper;

@property(nonatomic, strong) NSMutableArray * selectedPhotos;  //用于保存照片
@property(nonatomic, strong) NSMutableArray * photoIds;  //用于保存照片ID

@property(readwrite,nonatomic,strong) id<OnMessageHandleListener> resultHandler;

@end

@implementation WriteOrderEditPlanStepViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _business = [WorkOrderBusiness getInstance];
        
        _topHeight = 45;
        _defaultItemHeight = 92;
        _defaultDescHeight = 174;
        _switchWidth = 42;
        _switchHeight = 28;
        _paddingTop = 13;
        
        CGFloat intputHeight = 50; //输入框高度
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        
        _switchWidth = [FMSize getInstance].btnWidth;
        _switchHeight = [FMSize getInstance].btnHeight;
        
        //mainContainerView容器
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        CGFloat originY = _paddingTop;
        CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
        CGFloat itemHeight = _topHeight;
        CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
        _topContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        _topContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _finishLbl = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, 0, _realWidth-_switchWidth-paddingLeft, _topHeight)];
        _finishLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        [_finishLbl setText:[[BaseBundle getInstance] getStringByKey:@"order_step_is_finish" inTable:nil]];
        _finishLbl.font = [FMFont fontWithSize:13];
        
        _finishSwitch = [[UISwitch alloc] init];
        _finishSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _finishSwitch.onTintColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        _switchWidth = CGRectGetWidth(_finishSwitch.frame);
        _switchHeight = CGRectGetHeight(_finishSwitch.frame);
        [_finishSwitch setFrame:CGRectMake(_realWidth-_switchWidth-paddingLeft, (_topHeight-_switchHeight)/2, _switchWidth, _switchHeight)];
        _topSeperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, _topHeight-seperatorHeight, _realWidth, seperatorHeight)];
        originY += itemHeight;
        
        itemHeight = _defaultItemHeight;
        _groupBaseTF = [[CaptionTextField alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        [_groupBaseTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_step_workTeam" inTable:nil]];
        [_groupBaseTF setEditable:NO];
        originY += itemHeight;
        
        itemHeight = _defaultItemHeight;
        _stepBaseTF = [[CaptionTextView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        [_stepBaseTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_step_step" inTable:nil]];
        [_stepBaseTF setOnViewResizeListener:self];
        [_stepBaseTF setEditable:NO];
        [_stepBaseTF setMinTextHeight:intputHeight];
        originY += itemHeight;
        
        itemHeight = _defaultDescHeight;
        _descBaseTF = [[CaptionTextView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        [_descBaseTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_step_work_desc" inTable:nil]];
        [_descBaseTF setOnViewResizeListener:self];
        [_descBaseTF becomeFirstResponder];
        originY += itemHeight;
        
        CGFloat photoHeight = [BasePhotoView calculateHeightByCount:0 width:_realWidth addAble:YES showType:PHOTO_SHOW_TYPE_ALL_LINES];
        _photoView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, photoHeight)];
        [_photoView setEditable:YES];
        [_photoView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
        [_photoView setOnMessageHandleListener:self];
        originY += photoHeight;
        
        [_topContainerView addSubview:_finishLbl];
        [_topContainerView addSubview:_finishSwitch];
        [_topContainerView addSubview:_topSeperator];
        
        [_mainContainerView addSubview:_topContainerView];
        [_mainContainerView addSubview:_groupBaseTF];
        [_mainContainerView addSubview:_stepBaseTF];
        [_mainContainerView addSubview:_descBaseTF];
        [_mainContainerView addSubview:_photoView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateLayout {
    
    CGFloat originY = _paddingTop + _topHeight + _defaultItemHeight;
    CGFloat itemHeight = 0;
    
    itemHeight = CGRectGetHeight(_stepBaseTF.frame);
    if(itemHeight < _defaultItemHeight) {
        itemHeight = _defaultItemHeight;
    }
    [_stepBaseTF setFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
    originY += itemHeight;
    
    itemHeight = CGRectGetHeight(_descBaseTF.frame);
    if(itemHeight < _defaultDescHeight) {
        itemHeight = _defaultDescHeight;
    }
    [_descBaseTF setFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
    originY += itemHeight;
    
    CGFloat photoHeight = [BasePhotoView calculateHeightByCount:[_selectedPhotos count] width:_realWidth addAble:YES showType:PHOTO_SHOW_TYPE_ALL_LINES];
    [_photoView setFrame:CGRectMake(0, originY, _realWidth, photoHeight)];
    originY += photoHeight;
    
    _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self updateInfo];
    [self initData];
}

- (void) initNavigation {
    if(_step) {
        [self setTitleWith:[_step getStepIndexDesc]];
    } else {
        [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_step_edit" inTable:nil]];
    }
    NSArray * menus = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_submit" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
    
}

- (void) initData {
    _selectedPhotos = [[NSMutableArray alloc] init];
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    _cameraHelper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:YES];
    [_cameraHelper setOnMessageHandleListener:self];
}

- (void) updateTitle {
    [self initNavigation];
    [self updateNavigationBar];
}

- (void) setInfoWithStep:(WorkOrderStep *) step {
    _step = step;
    [self updateTitle];
    [self updateInfo];
}

- (void) setWorkOrderId:(NSNumber *) woId {
    _woId = [woId copy];
}

- (void) updateInfo {
    [_groupBaseTF setText:_step.workTeamName];
    [_stepBaseTF setText:_step.step];
    [_descBaseTF setText:_step.comment];
    _finishSwitch.on = _step.finished;
}

- (void) onMenuItemClicked:(NSInteger)position {
    [self showLoadingDialogwith:[[BaseBundle getInstance] getStringByKey:@"upload_uploading" inTable:nil]];
    if([_selectedPhotos count] > 0) {
        [self requestUploadImage];
    } else {
        [self requestFinishStep];
    }
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _stepBaseTF || view == _descBaseTF) {
        CGRect frame = view.frame;
        frame.size = newSize;
        view.frame = frame;
        [self updateLayout];
    }
}

- (void) onSwitchValueChanged {
    _finished = _finishSwitch.on;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _resultHandler = handler;
}

- (void) notifyStepUpdate {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WorkOrderStepUpdate" object:_step];
}

#pragma mark - 键盘显示与隐藏
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
            CGRect frame = [self getContentFrame];
            frame.size.height = _realHeight  -keyboardSize.height;
            [_mainContainerView setFrame:frame];
            [self updateLayout];
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
        CGRect frame = [self getContentFrame];
        [_mainContainerView setFrame:frame];
        [self updateLayout];
    }];
}



#pragma mark - 网络请求
- (void) requestFinishStep {
    [self showLoadingDialog];
    _step.finished = _finishSwitch.on;
    _step.comment = _descBaseTF.text;
    WorkOrderPlanMaintanceStepRequestParam * param = [self getPlanStepsInfoParam];
    if (param.finished == NO) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_confirm_finished" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    [_business saveOrderPlanSteps:param success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_operate_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self notifyStepUpdate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self finish];
        });
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_operate_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (WorkOrderPlanMaintanceStepRequestParam *) getPlanStepsInfoParam {
    WorkOrderPlanMaintanceStepRequestParam * param = [[WorkOrderPlanMaintanceStepRequestParam alloc] init];
    param.woId = [_woId copy];
    param.stepId = _step.stepId;
    param.finished = _finishSwitch.on;
    param.comment = _descBaseTF.text;
    param.photos = [_photoIds copy];
    return param;
}

- (void) requestUploadImage {
    if([_selectedPhotos count] > 0) {
        [[FileUploadService getInstance] uploadImageFiles:_selectedPhotos listener:self];
    }
}

#pragma mark - 文件上传
- (void) onUploadFileError: (NSURLResponse *) response error: (NSError *) error {
    [self hideLoadingDialog];
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"feedback_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}
- (void) onUploadFileFinished: (NSURLResponse *) response object: (id) responseObject {
    _photoIds = responseObject;
    _step.photos = [_photoIds copy];
    [self requestFinishStep];
}


#pragma mark - 消息处理
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_photoView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            PhotoActionType type = [tmpNumber integerValue];
            
            switch(type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [_photoHelper setPhotos:_selectedPhotos];
                    [_photoHelper showPhotoWithIndex:tmpNumber.integerValue];
                    break;
                case PHOTO_ACTION_DELETE:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [_selectedPhotos removeObjectAtIndex:tmpNumber.integerValue];
                    [_photoView setPhotosWithArray:_selectedPhotos];
                    [self updateLayout];
                    break;
                case PHOTO_ACTION_TAKE_PHOTO:
                    [self goToPickPhoto];
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([_cameraHelper class])]) {
            NSArray *imgPaths = [msg valueForKeyPath:@"result"];
            for (NSString *path in imgPaths) {
                UIImage * img = [FMUtils getImageWithName:path];
                [_selectedPhotos addObject:img];
            }
            [_photoView setPhotosWithArray:_selectedPhotos];
            [self updateLayout];
        }
    }
}

#pragma mark - 页面跳转
- (void) goToPickPhoto {
    [_descBaseTF resignFirstResponder];
    [_cameraHelper getPhotoWithWaterMark:nil];
}

@end
