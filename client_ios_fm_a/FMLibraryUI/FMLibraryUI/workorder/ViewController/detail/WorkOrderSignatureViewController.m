//
//  WorkOrderSignatureViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/8.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderSignatureViewController.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "FileUploadService.h"
#import "HBDrawingBoard.h"
#import "HBDrawCommon.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "UIImageView+AFNetworking.h"
#import "WorkOrderSignEntity.h"
#import "WorkOrderBusiness.h"
#import "DSAlertDisplayer.h"

@interface WorkOrderSignatureViewController ()<FileUploadListener>

@property (readwrite, nonatomic, strong) UIView * navigationView;
@property (readwrite, nonatomic, strong) UIButton * backBtn;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) UIButton * confirmBtn;

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) HBDrawingBoard *drawBoard;
@property (readwrite, nonatomic, strong) UIButton * revokeBtn;   //撤销按钮
@property (readwrite, nonatomic, strong) UIButton * clearBtn;    //清除按钮

@property (readwrite, nonatomic, strong) UIImageView * signImgView;  //在不可编辑的是状态下用于显示签字图片

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) UIImage * customerSignImg;    //用于上传的客户签字img
@property (readwrite, nonatomic, strong) UIImage * supervisorSignImg;  //用于上传的主管签字img
@property (readwrite, nonatomic, strong) UIImage * signImage;        //用于展示的签字照片
@property (readwrite, nonatomic, strong) NSURL * signImageUrl;       //用于展示的签字照片的path
@property (readwrite, nonatomic, strong) NSString * imgPath;         //向外部viewController发送出去的imgPath
@property (readwrite, nonatomic, strong) NSNumber * orderId;         //工单ID


@property (readwrite, nonatomic, assign) BOOL editable;          //用于判断是否可编辑
@property (readwrite, nonatomic, strong) NSNumber * boolValue;   //用于判断是否可编辑

@property (readwrite, nonatomic, assign) WorkOrderSignatureType signType;
@property (readwrite, nonatomic, strong) NSNumber* signImgId;

@property (readwrite, nonatomic, strong) id<OnMessageHandleListener> handler;

@end

@implementation WorkOrderSignatureViewController

- (instancetype) initWithSignType:(WorkOrderSignatureType)type andOrderId:(NSNumber *)orderId {
    self = [super init];
    if(self) {
        _signType = type;
        _orderId = orderId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
    [self updateLayout];
}


- (void)initLayout {
    CGRect frame = self.view.frame;
    _realHeight = CGRectGetWidth(frame);   //因为是横屏 所以此处height和width需要对调
    _realWidth = CGRectGetHeight(frame);
    _editable = YES;
    
    
    CGFloat navigationHeight = [FMSize getInstance].navigationbarHeight;
    CGFloat padding = [FMSize getSizeByPixel:40];
    CGFloat btnWidth = [FMSize getSizeByPixel:140];
    
    /*
     * 导航栏容器
     */
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, navigationHeight)];
    _navigationView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    
    //返回按钮
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, (navigationHeight - 24)/2, 24, 24)];
    [_backBtn setImage:[[FMTheme getInstance] getImageByName:@"pre_arrow_white_slim"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    //主题名字
    CGFloat titleWidth = 180;
    _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake((_realWidth-titleWidth)/2, 7, titleWidth, 31)];
    if(_signType == WO_SIGNATURE_TYPE_CUSTOMER) {
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"order_sign_customer" inTable:nil];
    } else {
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"order_sign_supervisor" inTable:nil];
    }
    
    _titleLbl.font = [FMFont getInstance].defaultFontLevel1;
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    
    //保存按钮
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-[FMSize getSizeByPixel:50]-40, 7, 40, 31)];
    [_confirmBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(onConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5] forState:UIControlStateHighlighted];
    _confirmBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
    
    [_navigationView addSubview:_backBtn];
    [_navigationView addSubview:_titleLbl];
    [_navigationView addSubview:_confirmBtn];
    
    
    /*
     * 主视图容器
     */
    _mainContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + navigationHeight, _realWidth, _realHeight-navigationHeight)];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    
    /*
     * 用于展示签字的页面
     */
    _signImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight-navigationHeight)];
    [_signImgView setHidden:YES];
    _signImgView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    //清除按钮
    _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-[FMSize getSizeByPixel:50]-btnWidth, _mainContainerView.frame.size.height - [FMSize getSizeByPixel:65]-btnWidth, btnWidth, btnWidth)];
    [_clearBtn setImage:[[FMTheme getInstance] getImageByName:@"clear_normal"] forState:UIControlStateNormal];
    [_clearBtn setImage:[[FMTheme getInstance] getImageByName:@"clear_highlighted"] forState:UIControlStateHighlighted];
    [_clearBtn addTarget:self action:@selector(onClearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _clearBtn.layer.cornerRadius = btnWidth/2;
    _clearBtn.layer.borderWidth = 0.8f;
    _clearBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] CGColor];
    
    //撤销按钮
    _revokeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-[FMSize getSizeByPixel:50]-btnWidth, _mainContainerView.frame.size.height-[FMSize getSizeByPixel:65]*2-btnWidth*2, btnWidth, btnWidth)];
    [_revokeBtn setImage:[[FMTheme getInstance] getImageByName:@"revoke_normal"] forState:UIControlStateNormal];
    [_revokeBtn setImage:[[FMTheme getInstance] getImageByName:@"revoke_higglighted"] forState:UIControlStateHighlighted];
    [_revokeBtn addTarget:self action:@selector(onRevokeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _revokeBtn.layer.cornerRadius = btnWidth/2;
    _revokeBtn.layer.borderWidth = 0.8f;
    _revokeBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] CGColor];
    

    [_mainContainerView addSubview:self.drawBoard];
    [_mainContainerView addSubview:_revokeBtn];
    [_mainContainerView addSubview:_clearBtn];
    
    [_mainContainerView addSubview:_signImgView];
    
    [self.view addSubview:_navigationView];
    [self.view addSubview:_mainContainerView];
    
}

- (void) updateLayout {
    if (_boolValue.integerValue == 1) {
        _editable = NO;
    }
    if(_editable) {
        [_signImgView setHidden:YES];
        [_drawBoard setHidden:NO];
        [_confirmBtn setHidden:NO];
    } else {
        [_signImgView setHidden:NO];
        [_drawBoard setHidden:YES];
        [_confirmBtn setHidden:YES];
        if(_signImage) {
            [_signImgView setImage:_signImage];
        } else {
            [_signImgView setImageWithURL:_signImageUrl];
        }
    }
}

//设置是否可编辑
- (void) setEditable:(BOOL) editable {
    if (!editable) {
        _boolValue = [NSNumber numberWithInteger:1];
    }
}

//设置签字图片
- (void) setInfoWithImage:(UIImage *) img {
    _signImage = img;
}

//设置签字图片
- (void) setInfoWithUrl:(NSURL *) url {
    _signImageUrl = url;
}

#pragma mark - Private Method
- (UIImage *) getScreenshots {
    _mainContainerView.backgroundColor = [UIColor clearColor];
    UIImage * currentImage = [_drawBoard getScreenImg];
    _mainContainerView.backgroundColor = [UIColor whiteColor];
    
    return currentImage;
}

//清除屏幕
- (void) clearScreenShots {
    [_drawBoard clearAll];
}

//撤销上一笔
- (void) onRevokeButtonClick {
    [_drawBoard backToLastDraw];
}

//清除屏幕
- (void) onClearButtonClick {
    [_drawBoard clearAll];
}

- (void) goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onConfirmClick {
    [self showLoadingDialog];
    
    switch (_signType) {
        case WO_SIGNATURE_TYPE_CUSTOMER:
            _customerSignImg = [_drawBoard getScreenImg];
            [self requestUploadSignImageCustomer];
            break;
        case WO_SIGNATURE_TYPE_SUPERVISOR:
            _supervisorSignImg = [_drawBoard getScreenImg];
            [self requestUploadSignImageSupervisor];
            break;
    }
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SendColorAndWidthNotification object:nil];
}

#pragma mark - getter
- (HBDrawingBoard *)drawBoard {
    if (!_drawBoard) {
        _drawBoard = [[HBDrawingBoard alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _mainContainerView.frame.size.height)];
        _drawBoard.lineColor = [UIColor blackColor];
        _drawBoard.lineWidth = 2.0f;
//        _drawBoard.boardBackImage = [UIImage imageNamed:@"signatureBackground.png"];
        [_drawBoard drawingStatus:^(HBDrawingStatus drawingStatus, HBDrawModel *model) {
            switch (drawingStatus) {
                case HBDrawingStatusBegin:
                    NSLog(@"开始");
                    break;
                case HBDrawingStatusMove:
                    NSLog(@"移动");
                    break;
                case HBDrawingStatusEnd:
                    NSLog(@"结束 ： %@ - %@ - %@",model.pointList,model.isEraser,model.paintColor);
                    break;
                default:
                    break;
            }
        }];
    }
    return _drawBoard;
}

#pragma mark - 签字图片上传
//上传客户签字
- (void) requestUploadSignImageCustomer {
    if(_customerSignImg) {
        NSMutableArray * imgArray = [[NSMutableArray alloc] init];
        [imgArray addObject:_customerSignImg];
        [[FileUploadService getInstance] uploadImageFiles:imgArray listener:self];
    }
}

//上传主管签字
- (void) requestUploadSignImageSupervisor {
    if(_supervisorSignImg) {
        NSMutableArray * imgArray = [[NSMutableArray alloc] init];
        [imgArray addObject:_supervisorSignImg];
        [[FileUploadService getInstance] uploadImageFiles:imgArray listener:self];
    }
}

- (void) requestSign {
    SignatureType type = WORK_ORDER_SIGNATURE_SUPERVISOR;
    if(_signType == WO_SIGNATURE_TYPE_CUSTOMER) {
        type = WORK_ORDER_SIGNATURE_CUSTOMER;
    }
    WorkOrderSignRequestParam * param = [[WorkOrderSignRequestParam alloc] initWithWoId:_orderId signType:type imgId:_signImgId time:[FMUtils getTimeLongNow]];
    [[WorkOrderBusiness getInstance] signOrder:param success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        [self handleResult];
        [DSAlertDisplayer displayAlertWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] message:[[BaseBundle getInstance] getStringByKey:@"order_save_success" inTable:nil] alertActions:@[] presentingViewController:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [DSAlertDisplayer displayAlertWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] message:[[BaseBundle getInstance] getStringByKey:@"order_save_fail" inTable:nil] alertActions:@[] presentingViewController:nil];
    }];
}

#pragma mark - 强制横屏
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

#pragma mark - handleMessage Delegate
- (void) handleResult {
    if (_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        [msg setValue:_signImgId forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

#pragma mark - FileUpload代理
- (void) onUploadFileError: (NSURLResponse *) response error: (NSError *) error {
    [self hideLoadingDialog];
    _signImgId = nil;
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"image_submit_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}

- (void) onUploadFileFinished: (NSURLResponse *) response object: (id) responseObject {
    NSMutableArray * fileIds = responseObject;
    if(fileIds && [fileIds count] > 0) {
        _signImgId = fileIds[0];
    }
    
    
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self requestSign];
}


@end




