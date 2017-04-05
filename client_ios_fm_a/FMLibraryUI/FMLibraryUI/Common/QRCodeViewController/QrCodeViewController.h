//
//  QRCodeViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/22.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@protocol OnQrCodeScanFinishedListener;


@interface QrCodeViewController :  BaseViewController <AVCaptureMetadataOutputObjectsDelegate>
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;

- (void) setOnQrCodeScanFinishedListener:(id<OnQrCodeScanFinishedListener>) listener;
@end

@protocol OnQrCodeScanFinishedListener <NSObject>

- (void) onQrCodeScanFinished: (NSString*) result;

@end