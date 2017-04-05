//
//  CameraHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/9.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "CameraHelper.h"
#import "FMUtilsPackages.h"
#import "TZImageManager.h"
#import "TZImagePickerController.h"
#import "FMTheme.h"

#import "BaseBundle.h"
#import "TaskAlertView.h"
#import "MenuAlertContentView.h"

#import "UserViewController.h"

@interface CameraHelper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate, OnClickListener, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) MenuAlertContentView * menuContentView;    //菜单界面
@property (readwrite, nonatomic, strong) TaskAlertView * alertView; //弹出框
@property (readwrite, nonatomic, assign) CGFloat alertViewHeight;   //弹出框高度

@property (readwrite, nonatomic, strong) NSString * imgPath;
@property (readwrite, nonatomic, strong) UIImage * img;
@property (readwrite, nonatomic, strong) id watermark;   //水印
@property (readwrite, nonatomic, weak) UIViewController * context;
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@property (nonatomic, assign) BOOL isSelectOriginalPhoto;  //是否允许选择原图
@property (nonatomic, assign) BOOL isMultiSelectAble;  //是否允许多选
@property (nonatomic, assign) BOOL allowCrop;  //是否允许裁剪

@property (nonatomic, assign) BOOL hideTabbar;  //是否需要隐藏tabbar

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@end


@implementation CameraHelper

- (instancetype) initWithContext:(UIViewController *) context andMultiSelectAble:(BOOL ) isMultiSelectAble {
    self = [super init];
    if(self) {
        _context = context;
        _isMultiSelectAble = isMultiSelectAble;
        _hideTabbar = NO;
        
        CGRect frame = context.view.frame;
        
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _alertViewHeight = _realHeight;
        
        [self initMenus];
        [self initAlertView];
        
    }
    return self;
}

- (void) initMenus {
    if(!_menuContentView) {
        _menuContentView = [[MenuAlertContentView alloc] init];
        [_menuContentView setOnMessageHandleListener:self];
    }
}

- (void) initAlertView {
    if(!_alertView) {
        _alertView = [[TaskAlertView alloc] init];
        [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
        [_alertView setHidden:YES];
        [_alertView setOnClickListener:self];
        [_context.view addSubview:_alertView];
        [_context.view bringSubviewToFront:_alertView];
        
        CGFloat menuHeight = 340;
        
        [_alertView setContentView:_menuContentView withKey:@"menu" andHeight:menuHeight  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    }
}

- (void) showMenus {
    
    [self tryToHideTabbar];

    NSMutableArray * textArray = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"take_camera" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"pick_from_album" inTable:nil], nil];
    BOOL showCancel = YES;
    CGFloat height = [MenuAlertContentView calculateHeightByCount:[textArray count] showCancel:YES];
    [_menuContentView setMenuWithArray:textArray];
    [_menuContentView setShowCancelMenu:showCancel];
    [_alertView setContentHeight:height withKey:@"menu"];
    [_alertView showType:@"menu"];
    [_alertView show];
}

//只有在单选模式下才能裁剪 isMultiSelectAble = No;
- (void) setAllowCrop:(BOOL)allowCrop {
    _allowCrop = allowCrop;
}

- (void) getPhotoWithWaterMark:(id) mark{
    _watermark = mark;
//    UIAlertController * alertController;
//    // 判断是否支持相机
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        UIAlertAction *actTakePhoto = [UIAlertAction actionWithTitle:[[BaseBundle getInstance] getStringByKey:@"take_camera" inTable:nil] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self tryToTakePhoto];
//        }];
//        UIAlertAction *actPickImage = [UIAlertAction actionWithTitle:[[BaseBundle getInstance] getStringByKey:@"pick_from_album" inTable:nil] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
////            [self tryToPickImage];
//            [self pushImagePickerController];
//        }];
//        UIAlertAction *actCancel = [UIAlertAction actionWithTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            [alertController dismissViewControllerAnimated:NO completion:nil];
//        }];
//        [alertController addAction:actTakePhoto];
//        [alertController addAction:actPickImage];
//        [alertController addAction:actCancel];
//        
//    } else {
//        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        UIAlertAction *actPickImage = [UIAlertAction actionWithTitle:[[BaseBundle getInstance] getStringByKey:@"pick_from_album" inTable:nil] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
////            [self tryToPickImage];
//            [self pushImagePickerController];
//        }];
//        UIAlertAction *actCancel = [UIAlertAction actionWithTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//            [alertController dismissViewControllerAnimated:NO completion:nil];
//        }];
//        [alertController addAction:actPickImage];
//        [alertController addAction:actCancel];
//    }
//    [_context presentViewController:alertController animated:YES completion:^{
//        
//    }];
    [self showMenus];
    
}

//拍照
- (void) takePhotoWithWaterMark:(id) mark{
    _watermark = mark;
    [self tryToTakePhoto];
}

//选择图片,添加水印， mark 可以为 UIImage 或者 NSString
- (void) pickImageWithWaterMark:(id) mark {
    _watermark = mark;
//    [self tryToPickImage];
    [self pushImagePickerController];
}

//如果viewcontroller 有 tabbar，则先隐藏
- (void) tryToHideTabbar {
    if (_context.tabBarController.tabBar.hidden == NO) {
        _context.tabBarController.tabBar.hidden = YES;
        _hideTabbar = YES;
    }
}

//如果之前隐藏了 tabbar，就显示出来
- (void) tryToShowTabBar {
    if(_hideTabbar) {
        if (_context.tabBarController.tabBar.hidden == YES) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.41f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _context.tabBarController.tabBar.hidden = NO;
                _hideTabbar = NO;
            });
        }
    }
}


- (void) tryToTakePhoto {
    NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = NO;
    
    imagePickerController.sourceType = sourceType;
    [_context presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void) tryToPickImage {
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = NO;
    
    imagePickerController.sourceType = sourceType;
    [_context presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void) pushImagePickerController {
    NSInteger maxPhotoCount = 0;
    NSInteger maxColumnCount = 4;
    if (_isMultiSelectAble) {
        maxPhotoCount = 9;
    } else {
        maxPhotoCount = 1;
    }
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxPhotoCount columnNumber:maxColumnCount delegate:self];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxPhotoCount columnNumber:maxColumnCount delegate:self pushPhotoPickerVc:NO];
    
    //设置记忆已选图片
//    if (maxPhotoCount > 1) {
//        //设置目前已经选中的图片数组
//        imagePickerVc.selectedAssets = _selectedAssets;
//    }
    
    imagePickerVc.allowTakePicture = NO;                  //是否在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;                 //是否可以选择视频
    imagePickerVc.allowPickingImage = YES;                //是否可以选择照片
    imagePickerVc.allowPickingOriginalPhoto = NO;        //是否可以选择原图
    _isSelectOriginalPhoto = NO;   //暂且定为始终为NO，让用户自行选择是否是原图
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;  //根据回调来显示，判断再进去选图片的时候是原图还是非原图
    imagePickerVc.sortAscendingByModificationDate = YES;  //
    if (_allowCrop) {
        imagePickerVc.allowCrop = _allowCrop;
        CGFloat width = [FMSize getInstance].screenWidth;
        CGFloat height = [FMSize getInstance].screenHeight;
        imagePickerVc.cropRect = CGRectMake((width-width/2)/2, (height - width/2)/2, width/2, width/2);
    }
    
    //外观设置
    imagePickerVc.navigationBar.barTintColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
//    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
//    imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];

    [_context presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSDate * now = [NSDate date];
    NSNumber * curTime = [FMUtils dateToTimeLong:now];
    NSString * imgPath = [[NSString alloc] initWithFormat:@"FM%lld.png", [curTime longLongValue]];//图片是以FM + 时间戳 + ".png" 格式命名
    UIImage * rImage;
    if(_watermark) {
        if([_watermark isKindOfClass:[NSString class]]) {
            rImage = [FMUtils addWaterMarkInImage:image withText:_watermark];
        } else {
            rImage = image;
        }
    } else {
        rImage = image;
    }
    [FMUtils saveImage:rImage withName:imgPath];
    
    NSMutableArray *selectedPhotoPath = [[NSMutableArray alloc] initWithObjects:imgPath, nil];
    
    [self notifyTakeAPhoto:selectedPhotoPath];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - TZImagePickerControllerDelegate

- (void) imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSMutableArray *selectedPhotoPath = [NSMutableArray new];
    
    NSDate * now = [NSDate date];
    NSNumber * curTime = [FMUtils dateToTimeLong:now];
    NSInteger index = 0;
    for (UIImage *image in photos) {
        UIImage *rImage = nil;
        NSString * imgPath = [[NSString alloc] initWithFormat:@"FM%lld.png", [curTime longLongValue] + index];//图片名
        index += 1;
        if(_watermark) {
            if([_watermark isKindOfClass:[NSString class]]) {
                rImage = [FMUtils addWaterMarkInImage:image withText:_watermark];
            } else {
                rImage = image;
            }
        } else {
            rImage = image;
        }
        [FMUtils saveImage:rImage withName:imgPath];
        
        [selectedPhotoPath addObject:imgPath];
    }
    
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    [self notifyTakeAPhoto:selectedPhotoPath];
}

//通知代理处理图片
- (void) notifyTakeAPhoto:(NSMutableArray *)photoPaths {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:photoPaths forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

- (void) setOnMessageHandleListener:(id) handler {
    _handler = handler;
}


//点击alertview
- (void) onClick:(UIView *)view {
    if([view isKindOfClass:[TaskAlertView class]]) {
        [self tryToShowTabBar];
        [_alertView close];
    }
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSNumber * tmpNumber = [msg valueForKeyPath:@"menuType"];
        MenuAlertViewType type = [tmpNumber integerValue];
        NSInteger position;
        [self tryToShowTabBar];
        switch(type) {
            case MENU_ALERT_TYPE_NORMAL:
                tmpNumber = [msg valueForKeyPath:@"result"];
                position = tmpNumber.integerValue;
                [_alertView close];
                switch(position) {
                    case 0:
                        [self tryToTakePhoto];
                        break;
                    case 1:
                        [self pushImagePickerController];
//                        [self tryToPickImage];
                        break;
                }
                break;
            case MENU_ALERT_TYPE_CANCEL:
                [_alertView close];
                break;
        }
    }
}

@end
