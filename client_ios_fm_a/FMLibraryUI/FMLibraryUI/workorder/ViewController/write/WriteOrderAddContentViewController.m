//
//  WriteOrderAddContentViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WriteOrderAddContentViewController.h"
#import "OnMessageHandleListener.h"

#import "SystemConfig.h"
#import "UploadConfig.h"
#import "BaseBundle.h"
#import "FileUploadService.h"

#import "SaveWorkOrderEntity.h"
#import "WorkOrderBusiness.h"
#import "UIButton+Bootstrap.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseTextView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BasePhotoView.h"
#import "PhotoShowHelper.h"
#import "CameraHelper.h"
#import <objc/runtime.h>


@interface WriteOrderAddContentViewController () <FileUploadListener>
@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) BaseTextView * mContentView;

@property (readwrite, nonatomic, strong) UIImageView * topSeperatorView;
@property (readwrite, nonatomic, strong) UIImageView * bottomSeperatorView;

@property (readwrite, nonatomic, strong) BasePhotoView * photoView;

@property (readwrite, nonatomic, strong) CameraHelper * cameraHelper;
@property (readwrite, nonatomic, strong) PhotoShowHelper * photoHelper;
@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;  //工单业务处理
@property (readwrite, nonatomic, strong) WorkOrderDetail * orderDetail; //工单详情信息


@property (readwrite, nonatomic, assign) CGFloat minContentHeight;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) NSNumber * orderId;
@property (readwrite, nonatomic, strong) NSString * content;
@property (readwrite, nonatomic, strong) NSMutableArray * selectedPhotoArray;

@property (readwrite, nonatomic, strong) NSMutableArray * imageIds;
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation WriteOrderAddContentViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_content_edit" inTable:nil]];
    [self setBackAble:YES];
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_menu_save" inTable:nil], nil];
    [self setMenuWithArray:menus];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    _cameraHelper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:YES];
    [_cameraHelper setOnMessageHandleListener:self];
}

- (void)initLayout {
    _selectedPhotoArray = [[NSMutableArray alloc] init];
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    _business = [WorkOrderBusiness getInstance];
    
    
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    _minContentHeight = [FMSize getSizeByPixel:400];
    _paddingLeft = [FMSize getInstance].defaultPadding;
    CGFloat sepHeight = [FMSize getSizeByPixel:30];
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat originX = 0;
    CGFloat originY = sepHeight;
    
    _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    //输入框
    _mContentView = [[BaseTextView alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, _minContentHeight)];
    [_mContentView setTopDesc:[[BaseBundle getInstance] getStringByKey:@"order_work_content_placeholder" inTable:nil]];
    [_mContentView setMaxTextLength:1000];
    [_mContentView setPaddingLeft:[FMSize getInstance].padding50];
    [_mContentView setPaddingRight:[FMSize getInstance].padding50];
    [_mContentView setMinHeight:_minContentHeight];
    [_mContentView setOnViewResizeListener:self];
    
    originY += _minContentHeight;
    
    //分割线
    _topSeperatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, seperatorHeight)];
    [_topSeperatorView setImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] width:1 height:1]];
    originY += seperatorHeight;
    
    //图片展示View
    CGFloat photoHeight = [BasePhotoView calculateHeightByCount:0 width:_realWidth addAble:YES showType:PHOTO_SHOW_TYPE_ALL_LINES];
    _photoView = [[BasePhotoView alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, photoHeight)];
    [_photoView setEditable:YES];
    [_photoView setOnMessageHandleListener:self];
    originY += photoHeight;
    
    _bottomSeperatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, seperatorHeight)];
    [_bottomSeperatorView setImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] width:1 height:1]];
    
    [_mainContainerView addSubview:_mContentView];
    [_mainContainerView addSubview:_topSeperatorView];
    [_mainContainerView addSubview:_photoView];
    [_mainContainerView addSubview:_bottomSeperatorView];
    
    [self.view addSubview:_mainContainerView];
    
    
    
    
    [self updateViews];
}


- (void) updateViews {
    CGFloat sepHeight = [FMSize getSizeByPixel:30];
    CGFloat originX = 0;
    CGFloat originY = sepHeight;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat itemHeight = CGRectGetHeight(_mContentView.frame);
    [_mContentView setFrame:CGRectMake(originX, originY, _realWidth, itemHeight)];
    originY += itemHeight;
    
    [_topSeperatorView setFrame:CGRectMake(originX, originY, _realWidth, seperatorHeight)];
    originY += seperatorHeight;
    
    CGFloat photoHeight = [BasePhotoView calculateHeightByCount:[_selectedPhotoArray count] width:_realWidth addAble:YES showType:PHOTO_SHOW_TYPE_ALL_LINES];
    [_photoView setFrame:CGRectMake(originX, originY, _realWidth, photoHeight)];
    originY += photoHeight;
    
    [_bottomSeperatorView setFrame:CGRectMake(originX, originY, _realWidth, seperatorHeight)];
    originY += seperatorHeight + sepHeight;
    
    if (originY > _realHeight) {
        _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
    } else {
        _mainContainerView.contentSize = CGSizeMake(_realWidth, _realHeight);
    }
    
    [self updateInfo];
}


- (void) setContent:(NSString *) content {
    _content = content;
    [self updateInfo];
}

- (void) setWorkOrderId:(NSNumber *)woId {
    
}

- (void) setWorkOrderDetail:(WorkOrderDetail *)orderDetail andWorkOrderId:(NSNumber *)orderId {
    _orderId = orderId;
    _orderDetail = orderDetail;
}

- (void) updateInfo {
    [_mContentView setContentWith:_content];
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _mContentView) {
        CGRect frame = view.frame;
        frame.size = newSize;
        view.frame = frame;
        [self updateViews];
    }
}

- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKey:@"msgOrigin"];
        if ([strOrigin isEqualToString:NSStringFromClass([_photoView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            PhotoActionType type = [tmpNumber integerValue];
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [_photoHelper setPhotos:_selectedPhotoArray];
                    [_photoHelper showPhotoWithIndex:tmpNumber.integerValue];
                    break;
                case PHOTO_ACTION_DELETE:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [_selectedPhotoArray removeObjectAtIndex:tmpNumber.integerValue];
                    [_photoView setPhotosWithArray:_selectedPhotoArray];
                    [self updateViews];
                    break;
                case PHOTO_ACTION_TAKE_PHOTO:
                    [self goToPickPhoto];
                    break;
            }
        } else if ([strOrigin isEqualToString:NSStringFromClass([_cameraHelper class])]) {
            NSArray *imgPaths = [msg valueForKeyPath:@"result"];
            for (NSString *path in imgPaths) {
                UIImage * img = [FMUtils getImageWithName:path];
                [_selectedPhotoArray addObject:img];
            }
            [_photoView setPhotosWithArray:_selectedPhotoArray];
            [self updateViews];
        }
    }
}

- (void) goToPickPhoto {
    [_cameraHelper getPhotoWithWaterMark:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
            CGRect frame = [self getContentFrame];
            frame.size.height = _realHeight - keyboardSize.height;
            [_mainContainerView setFrame:frame];
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
        CGRect frame = [self getContentFrame];
        [_mainContainerView setFrame:frame];
    }];
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (position == 0) {
        [self onMenuSaveClicked];
    }
}

- (void) onMenuSaveClicked {
    [self showLoadingDialog];
    if(_selectedPhotoArray && [_selectedPhotoArray count] > 0) {
        [self requestUploadPhotos];
    } else {
        [self requestSaveContent];
    }
}

- (void) requestSaveContent {
    WorkOrderWorkContentSaveRequestParam * param = [self getOrderInfoSaved];
    [_business saveOrderContent:param success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_save_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self handleResult];
        [self finish];

    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_save_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (void) requestUploadPhotos {
//    NSMutableArray * imgPathArray = [_helper getPhotosNew];  //获取本地新拍的工作内容照片
    NSMutableArray * imgArray = _selectedPhotoArray;
    if([imgArray count] > 0) {
        [[FileUploadService getInstance] uploadImageFiles:imgArray listener:self];
    }
}

- (WorkOrderWorkContentSaveRequestParam *) getOrderInfoSaved {
    WorkOrderWorkContentSaveRequestParam * param = [[WorkOrderWorkContentSaveRequestParam alloc] init];
    param.woId = [_orderId copy];
    NSString * workContent = [_mContentView getContent];
    if(![FMUtils isStringEmpty:workContent]){
        param.workContent = workContent;
    } else {
        param.workContent = @"";
    }
    
    //图片ID数组
    param.pictures = _imageIds;
    return param;
}


- (void) onUploadFileError:(NSURLResponse *)response error:(NSError *)error {
    [self hideLoadingDialog];
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"image_submit_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}

- (void) onUploadFileFinished:(NSURLResponse *)response object:(id)responseObject {
    _imageIds = responseObject;
    [self requestSaveContent];
}


- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)listener {
    _handler = listener;
}

- (void) handleResult {
    if (_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:@"refresh" forKeyPath:@"eventType"];
        [msg setValue:result forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

@end

