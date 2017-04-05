//
//  ContractCheckViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 17/1/4.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import "ContractCheckViewController.h"
#import "FMUtilsPackages.h"
#import "BaseTextView.h"
#import "BasePhotoView.h"
#import "SeperatorView.h"
#import "PhotoShowHelper.h"
#import "CameraHelper.h"
#import "ContractBusiness.h"
#import "FileUploadService.h"
#import "TaskAlertView.h"
#import "MenuAlertContentView.h"

@interface ContractCheckViewController ()<FileUploadListener,OnMessageHandleListener,OnViewResizeListener,OnClickListener,UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *mainContainerView;
@property (nonatomic, strong) BaseTextView *mContentView;

@property (nonatomic, strong) BasePhotoView *photoView;

@property (nonatomic, strong) SeperatorView *topSeperator;
@property (nonatomic, strong) SeperatorView *bottomSeperator;

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) CameraHelper * cameraHelper;
@property (nonatomic, strong) PhotoShowHelper * photoHelper;

@property (nonatomic, strong) ContractBusiness *business;  //业务处理
@property (nonatomic, strong) NSMutableArray * selectedPhotos;  //用于保存照片
@property (nonatomic, strong) NSMutableArray * photoIds;  //用于保存照片ID
@property (nonatomic, strong) NSNumber *contractId;
@property (nonatomic, assign) __block BOOL isPassed;  //通过or不通过

@property (nonatomic, strong) TaskAlertView *alertView; //弹出框
@property (nonatomic, assign) CGFloat alertViewHeight;   //弹出框高度
@property (nonatomic, strong) MenuAlertContentView *menuContentView;    //菜单界面
@property (nonatomic, strong) NSMutableArray *actionHandlerArray;   //事件处理

@property (nonatomic, assign) CGFloat minContentHeight;
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation ContractCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    _cameraHelper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:YES];
    [_cameraHelper setOnMessageHandleListener:self];
    [self initAlertView];
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_title_check" inTable:nil]];
    [self setBackAble:YES];
    
    [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_check" inTable:nil]]];
}


- (void)onMenuItemClicked:(NSInteger)position {
    [self showControlMenue];
}

- (void)initLayout {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    _paddingLeft = [FMSize getInstance].defaultPadding;
    _minContentHeight = 150;
    
    
    _business = [ContractBusiness getInstance];
    _selectedPhotos = [[NSMutableArray alloc] init];
    _photoIds = [[NSMutableArray alloc] init];
    
    _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    _mainContainerView.delaysContentTouches = NO;
    
    
    _mContentView = [[BaseTextView alloc] init];
    _mContentView.backgroundColor = [UIColor whiteColor];
    [_mContentView setTopDesc:[[BaseBundle getInstance] getStringByKey:@"order_validate_desc" inTable:nil]];
    [_mContentView becomeFirstResponder];
    [_mContentView setOnViewResizeListener:self];
    [_mContentView setMinHeight:_minContentHeight];
    
    
    _photoView = [[BasePhotoView alloc] init];
    [_photoView setEditable:YES];
    [_photoView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
    [_photoView setOnMessageHandleListener:self];
    
    
    _topSeperator = [[SeperatorView alloc] init];
    _bottomSeperator = [[SeperatorView alloc] init];
    
    
    [_mainContainerView addSubview:_mContentView];
    [_mainContainerView addSubview:_photoView];
    [_mainContainerView addSubview:_topSeperator];
    [_mainContainerView addSubview:_bottomSeperator];
    
    [self.view addSubview:_mainContainerView];
    
    [self updateLayout];
}

- (void)initAlertView {
    _alertView = [[TaskAlertView alloc] init];
    _alertViewHeight = CGRectGetHeight(self.view.frame);
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat itemHeight = 50;
    CGFloat contentHeight = itemHeight * (4 + 1);//附加一个取消按钮
    _menuContentView = [[MenuAlertContentView alloc] init];
    [_menuContentView setOnMessageHandleListener:self];
    [_alertView setContentView:_menuContentView withKey:@"menu" andHeight:contentHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (void)updateLayout {
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat originY = 8;
    CGFloat itemHeight = CGRectGetHeight(_mContentView.frame);
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    if(itemHeight <= _minContentHeight) {
        itemHeight = _minContentHeight;
    }
    [_mContentView setFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
    originY += itemHeight;
    
    [_topSeperator setFrame:CGRectMake(0, originY-seperatorHeight, _realWidth, seperatorHeight)];
    
    
    CGFloat photoHeight = [BasePhotoView calculateHeightByCount:[_selectedPhotos count] width:_realWidth addAble:YES showType:PHOTO_SHOW_TYPE_ALL_LINES];
    [_photoView setFrame:CGRectMake(0, originY, _realWidth, photoHeight)];
    originY += photoHeight;
    
    [_bottomSeperator setFrame:CGRectMake(0, originY-seperatorHeight, _realWidth, seperatorHeight)];
    originY += padding*2;
    
    _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
}

#pragma mark - Private Method
- (void)showControlMenue {
    __weak typeof(self) weakSelf = self;
    ActionHandler passHandler = ^(UIAlertAction * action) {
        weakSelf.isPassed = YES;
        [weakSelf finishEditing];
    };
    
    ActionHandler unPassHandler = ^(UIAlertAction * action) {
        weakSelf.isPassed = NO;
        [weakSelf finishEditing];
    };
    
    NSMutableArray *menus = [NSMutableArray new];
    NSMutableArray *handlers = [NSMutableArray new];
    
    [menus addObject:[[BaseBundle getInstance] getStringByKey:@"contract_operate_pass" inTable:nil]];
    [menus addObject:[[BaseBundle getInstance] getStringByKey:@"contract_operate_unpass" inTable:nil]];
    
    [handlers addObject:passHandler];
    [handlers addObject:unPassHandler];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

- (void) showControlWithMenuTexts:(NSMutableArray *) textArray handlers:(NSMutableArray *) handlers{
    _actionHandlerArray = handlers;
    BOOL showCancel = YES;
    CGFloat height = [MenuAlertContentView calculateHeightByCount:[textArray count] showCancel:showCancel];
    [_menuContentView setMenuWithArray:textArray];
    [_menuContentView setShowCancelMenu:showCancel];
    [_alertView setContentHeight:height withKey:@"menu"];
    [_alertView showType:@"menu"];
    [_alertView show];
}

- (void)setContractId:(NSNumber *)contractId {
    _contractId = contractId;
}

- (void) goToPickPhoto {
    [_cameraHelper getPhotoWithWaterMark:nil];
}

- (void)finishEditing {
    
    ContractOperateRequestParam *param = [self getOperationParam];
    if (!_isPassed && [FMUtils isStringEmpty:param.desc]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_description_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if (_photoIds.count == 0 && [_selectedPhotos count] > 0) {
        [self showLoadingDialogwith:[[BaseBundle getInstance] getStringByKey:@"upload_uploading" inTable:nil]];
        [self requestUploadImage];
    } else {
        [self showLoadingDialogwith:[[BaseBundle getInstance] getStringByKey:@"upload_uploading" inTable:nil]];
        [self requestCheckOperation];
    }
}

#pragma mark - NetWroking
- (void)requestUploadImage {
    if([_selectedPhotos count] > 0) {
        [[FileUploadService getInstance] uploadImageFiles:_selectedPhotos listener:self];
    }
}

- (void)requestCheckOperation {
    ContractOperateRequestParam * param = [self getOperationParam];
    if ([FMUtils isStringEmpty:param.desc] && param.type == 2) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_description_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        __weak typeof(self) weakSelf = self;
        [_business operateContractByParam:param Success:^(NSInteger key, id object) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_operate_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf notifyContractStatusChanged];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSInteger count = weakSelf.navigationController.viewControllers.count;
                UIViewController *targetVC = weakSelf.navigationController.viewControllers[count - 3];
                [weakSelf.navigationController popToViewController:targetVC animated:YES];
            });
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_operate_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    }
}

- (ContractOperateRequestParam *)getOperationParam {
    ContractOperateRequestParam *param = [[ContractOperateRequestParam alloc] init];
    param.contractId = _contractId;
    if (_isPassed) {
        param.type = 3;  //验收通过
    } else {
        param.type = 2;  //验收不通过
    }
    param.desc = [_mContentView getContent];
    param.photos = _photoIds;
    
    return param;
}

#pragma mark - 通知合同列表刷新
- (void) notifyContractStatusChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FMContractStatusUpdate" object:nil];
}

#pragma mark - 文件上传
- (void) onUploadFileError: (NSURLResponse *) response error: (NSError *) error {
    [self hideLoadingDialog];
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"feedback_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}
- (void) onUploadFileFinished: (NSURLResponse *) response object: (id) responseObject {
    _photoIds = responseObject;
    [self requestCheckOperation];
}

#pragma mark - OnViewResizeListener
- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _mContentView) {
        CGRect frame = view.frame;
        frame.size = newSize;
        view.frame = frame;
        [self updateLayout];
    }
}

#pragma mark - Keyboard Delegate
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
            CGRect frame = [self getContentFrame];
            frame.size.height = _realHeight  -keyboardSize.height;
            _mainContainerView.frame = frame;
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
        CGRect frame = [self getContentFrame];
        _mainContainerView.frame = frame;
    }];
}

#pragma mark - OnMessageHandleListener
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

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
        } else if ([strOrigin isEqualToString:NSStringFromClass([MenuAlertContentView class])]) {
            NSNumber *tmpNumber = [msg valueForKeyPath:@"menuType"];
            MenuAlertViewType type = [tmpNumber integerValue];
            NSInteger position;
            switch(type) {
                case MENU_ALERT_TYPE_NORMAL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    position = tmpNumber.integerValue;
                    if(position < [_actionHandlerArray count]) {
                        ActionHandler handler = _actionHandlerArray[position];
                        [_alertView close];
                        handler(nil);
                    }
                    break;
                case MENU_ALERT_TYPE_CANCEL:
                    [_alertView close];
                    break;
            }
        }
    }
}

#pragma mark -
- (void)onClick:(UIView *)view {
    if([view isKindOfClass:[TaskAlertView class]]) {
        [_alertView close];
    }
}


@end

