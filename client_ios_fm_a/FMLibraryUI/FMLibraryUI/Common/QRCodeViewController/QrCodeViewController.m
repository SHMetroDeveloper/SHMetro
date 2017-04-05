//
//  QRCodeViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/22.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "QrCodeViewController.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "QrcodeBoxView.h"
#import "QrcodeScanLineView.h"

@interface QrCodeViewController ()

@property (readwrite, nonatomic, strong) UIView * previewView;
@property (strong, nonatomic) UILabel *noticeLbl;

@property (strong, nonatomic) QrcodeBoxView *boxView;
@property (strong, nonatomic) CALayer *scanLayer;
//@property (strong, nonatomic) QrcodeScanLineView *scanLine;


@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat boxWidth;
@property (readwrite, nonatomic, assign) CGRect previewFrame;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (readwrite, nonatomic, weak) id<OnQrCodeScanFinishedListener> listener;

@end


@implementation QrCodeViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_qrcode" inTable:nil]];
    [self setBackAble:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initViews];
    if(![self startReading]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"qrcode_notice_permission" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self stopReading];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    [self showLoadingDialog];
}

- (void) initViews {
    CGRect frame = self.view.frame;
    frame = [self getContentFrame];
    
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    CGFloat msgHeight = 60;    //给标签预留的高度
    
    if(_realWidth < _realHeight) {
        _boxWidth = (_realWidth - msgHeight) * 0.8;     //
    } else {
        _boxWidth = (_realHeight - msgHeight) * 0.8;
    }
    
    self.previewView = [[UIView alloc] initWithFrame:frame];
    
    _previewFrame = CGRectMake((_realWidth - _boxWidth)/2, (_realWidth - _boxWidth)/2, _boxWidth, _boxWidth);
    
    self.noticeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.origin.y + (_realWidth + _boxWidth)/2 + 40, frame.size.width, 40)];
    self.noticeLbl.textAlignment = NSTextAlignmentCenter;
    self.noticeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    self.noticeLbl.text = [[BaseBundle getInstance] getStringByKey:@"qrcode_notice" inTable:nil];
    
    
    
    [self.view addSubview:_previewView];
    [self.view addSubview:self.noticeLbl];
}

- (BOOL)startReading {
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    self.captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [self.captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [self.captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    //6.实例化预览图层
   self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [self.videoPreviewLayer setFrame:self.previewView.layer.bounds];
    //9.将图层添加到预览view的图层上
    [self.previewView.layer addSublayer:_videoPreviewLayer];
    //10.设置扫描范围
    
    CGFloat p1 = _realHeight/_realWidth;
    CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = _realWidth * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - _realHeight)/2;
        captureMetadataOutput.rectOfInterest = CGRectMake((_previewFrame.origin.y + fixPadding)/fixHeight,
                                            _previewFrame.origin.x/_realWidth,
                                            _previewFrame.size.height/fixHeight,
                                            _previewFrame.size.width/_realWidth);
    } else {
        CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - _realWidth)/2;
        captureMetadataOutput.rectOfInterest = CGRectMake(_previewFrame.origin.y/_realHeight,
                                            (_previewFrame.origin.x + fixPadding)/fixWidth,
                                            _previewFrame.size.height/_realHeight,
                                            _previewFrame.size.width/fixWidth);
    }
    
    [self hideLoadingDialog];
    
    //10.1.扫描框

    self.boxView = [[QrcodeBoxView alloc] initWithFrame:_previewFrame];

    [self.previewView addSubview:self.boxView];
    //10.2.扫描线
    self.scanLayer = [[CALayer alloc] init];
    self.scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 3);
    self.scanLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.boxView.layer addSublayer:self.scanLayer];

    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    return YES;
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
//            [self.noticeLbl performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            [self stopReading];
            if(self.listener) {
                [self.listener onQrCodeScanFinished:[metadataObj stringValue]];
            }
//            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(finish) withObject:nil waitUntilDone:NO];
            //扫描到结果后返回
//            [self finish];
//            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (void)finish {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 10;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
}

#pragma 扫描结果监听器
- (void) setOnQrCodeScanFinishedListener:(id<OnQrCodeScanFinishedListener>) listener {
    _listener = listener;
}


@end
