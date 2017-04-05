//
//  FeedbackViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIButton+Bootstrap.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "SystemConfig.h"
#import "UserNetRequest.h"
#import "UserRequest.h"
#import "BaseTextView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseTextView.h"
#import "ResizeableView.h"
#import "BaseBundle.h"

#import "FMGridImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoShowHelper.h"
#import "CameraHelper.h"

#import "BasePhotoView.h"
#import "FileUploadService.h"
#import "FileUploadResponse.h"
#import "MenuAlertContentView.h"
#import "TaskAlertView.h"
#import "IQKeyboardManager.h"


@interface FeedbackViewController () <FMGridImageViewDelegate, OnMessageHandleListener,OnViewResizeListener, FileUploadListener>

@property(nonatomic, strong) UIScrollView * mainContainerView;
@property(nonatomic, strong) BaseTextView * mContentView;

@property(nonatomic, strong) BasePhotoView * photoView;

@property(nonatomic, strong) UIImageView * topSeperatorView;
@property(nonatomic, strong) UIImageView * bottomSeperatorView;

@property(nonatomic, strong) NSString * content;
@property(nonatomic, strong) CameraHelper * cameraHelper;
@property(nonatomic, strong) PhotoShowHelper * photoHelper;

@property(nonatomic, strong) NSMutableArray * selectedPhotos;  //用于保存照片
@property(nonatomic, strong) NSMutableArray * photoIds;  //用于保存照片ID

@property(nonatomic, assign) CGFloat minContentHeight;
@property(nonatomic, assign) CGFloat paddingLeft;

@property(nonatomic, assign) CGFloat realWidth;
@property(nonatomic, assign) CGFloat realHeight;
@property(nonatomic, assign) NSInteger minCount; //允许输入的最小字符个数

@property(nonatomic, assign) BOOL isWidthScreen;   //判断是否为宽屏

@end

@implementation FeedbackViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_setting_feedback" inTable:nil]];
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_submit" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
//        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//        if (![manager.disabledDistanceHandlingClasses containsObject:[self class]]) {
//            [manager.disabledDistanceHandlingClasses addObject:[self class]];
//        }
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _minContentHeight = 150;
        _minCount = 5;
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        
        _isWidthScreen = NO;
        if (_realWidth > 320) {
            _isWidthScreen = YES;   //判断是否为宽屏
        }
        CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
        CGFloat originY = 10;
        
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _mainContainerView.delaysContentTouches = NO;
        
        _mContentView = [[BaseTextView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _minContentHeight)];
        _mContentView.backgroundColor = [UIColor whiteColor];
        [_mContentView setTopDesc:[[BaseBundle getInstance] getStringByKey:@"feedback_placeholder" inTable:nil]];
        [_mContentView becomeFirstResponder];
        [_mContentView setOnViewResizeListener:self];
        //    [_mContentView setShowBounds:YES];
        [_mContentView setMinHeight:_minContentHeight];
        originY += _minContentHeight ;
        
        _topSeperatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, seperatorHeight)];
        [_topSeperatorView setImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] width:1 height:1]];
        originY += seperatorHeight;
        
        CGFloat photoHeight = [BasePhotoView calculateHeightByCount:0 width:_realWidth addAble:YES showType:PHOTO_SHOW_TYPE_ALL_LINES];
        _photoView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, photoHeight)];
        [_photoView setEditable:YES];
        [_photoView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
        [_photoView setOnMessageHandleListener:self];
        originY += photoHeight;
        
        _bottomSeperatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, seperatorHeight)];
        [_bottomSeperatorView setImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] width:1 height:1]];
        originY += seperatorHeight;
        
        [_mainContainerView addSubview:_mContentView];
        [_mainContainerView addSubview:_topSeperatorView];
        [_mainContainerView addSubview:_photoView];
        [_mainContainerView addSubview:_bottomSeperatorView];
        
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateLayout {
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat originY = 8;
    CGFloat itemHeight = CGRectGetHeight(_mContentView.frame);
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    if(itemHeight == 0) {
        itemHeight = _minContentHeight;
    }
    [_mContentView setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;
    
    [_topSeperatorView setFrame:CGRectMake(0, originY, _realWidth, seperatorHeight)];
    originY += seperatorHeight;
    //图片展示view
    CGFloat photoHeight = [BasePhotoView calculateHeightByCount:[_selectedPhotos count] width:width addAble:YES showType:PHOTO_SHOW_TYPE_ALL_LINES];
    [_photoView setFrame:CGRectMake(0, originY, _realWidth, photoHeight)];
    originY += photoHeight;
    
    [_bottomSeperatorView setFrame:CGRectMake(0, originY, _realWidth, seperatorHeight)];
    originY += seperatorHeight + padding * 2;
    
    
    _mainContainerView.contentSize = CGSizeMake(width, originY);
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    _selectedPhotos = [[NSMutableArray alloc] init];
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    _cameraHelper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:YES];
    [_cameraHelper setOnMessageHandleListener:self];
    [self updateLayout];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self finishEditing];
    }
}

- (void) setContent:(NSString *) content {
    _content = content;
    [self updateInfo];
}

- (void) updateInfo {
    [_mContentView setContentWith:_content];
}


- (void) finishEditing {
    _content = [_mContentView getContent];
    if(![FMUtils isStringEmpty:_content]) {
        if([_content length] >= _minCount) {
            [self work];
        } else {
            NSString * strNotice = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"feedback_notice_input_mincount" inTable:nil], _minCount];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:strNotice time:DIALOG_ALIVE_TIME_SHORT];
        }
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"feedback_notice_input" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}


- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _mContentView) {
        CGRect frame = view.frame;
        frame.size = newSize;
        view.frame = frame;
        [self updateLayout];
    }
}

//- (void)keyboardWasShown:(NSNotification*)aNotification {
//    NSDictionary *info = [aNotification userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    if(keyboardSize.height > 0) {
//        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
//            CGRect frame = [self getContentFrame];
//            frame.size.height = _realHeight  -keyboardSize.height;
//            _mainContainerView.frame = frame;
//        }];
//    }
//}
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
//        CGRect frame = [self getContentFrame];
//        _mainContainerView.frame = frame;
//    }];
//}

- (void) work {
    [self showLoadingDialogwith:[[BaseBundle getInstance] getStringByKey:@"upload_uploading" inTable:nil]];
    if([_selectedPhotos count] > 0) {
        [self requestUploadImage];
    } else {
        [self requestToFeedBack];
    }
}


- (void) requestToFeedBack {
    UserNetRequest * userNetRequest = [UserNetRequest getInstance];
    UserFeedbackRequest * param = [[UserFeedbackRequest alloc] initWithContent:_content andPictures:_photoIds];
    [userNetRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"feedback_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self finish];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"feedback_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (void) requestUploadImage {
    if([_selectedPhotos count] > 0) {
        [[FileUploadService getInstance] uploadImageFiles:_selectedPhotos listener:self];
    }
}

- (void) goToPickPhoto {
    [_mContentView resignFirstResponder];
    [_cameraHelper getPhotoWithWaterMark:nil];
}

#pragma mark - handle messge
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
                    //弹出照片选项框
                    NSLog(@"弹出照片选项框");
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

#pragma mark - 文件上传
- (void) onUploadFileError: (NSURLResponse *) response error: (NSError *) error {
    [self hideLoadingDialog];
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"feedback_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}
- (void) onUploadFileFinished: (NSURLResponse *) response object: (id) responseObject {
    _photoIds = responseObject;
    [self requestToFeedBack];
}

@end






