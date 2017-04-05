//
//  ScanHeaderCollectionReusableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "ScanHeaderCollectionReusableView.h"
#import "FMUtilsPackages.h"
#import "BaseBundle.h"

@interface ScanHeaderCollectionReusableView ()

@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UIImageView *btnImageView;
@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, assign) BOOL isInited;

@end

@implementation ScanHeaderCollectionReusableView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _headerBtn = [UIButton new];
        [_headerBtn addTarget:self action:@selector(onHeaderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        _headerBtn.backgroundColor = [UIColor colorWithRed:96/255.0 green:189/255.0 blue:250/255.0 alpha:1];
        
        
        _btnImageView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"patrol_qrcode_scanner"] highlightedImage:[[FMTheme getInstance] getImageByName:@"patrol_qrcode_scanner"]];
        _btnImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        _titleLbl = [UILabel new];
        _titleLbl.font = [FMFont getInstance].font44;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"function_patrol_scanner" inTable:nil];
        
        [_headerBtn addSubview:_btnImageView];
        [_headerBtn addSubview:_titleLbl];
        
        [self addSubview:_headerBtn];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    [_headerBtn setFrame:CGRectMake(0, 0, width, height)];
    
    CGFloat imageWidth = 176.f/448.f*(height - 64);
    CGFloat iamgeHeight = 170.f/448.f*(height - 64);
    
    CGFloat paddingTop = 100.f/448.f*(height - 64) + 64;
    CGFloat sepHeight = 42.f/448.f*(height - 64);
    
    CGFloat originY = paddingTop;
    
    [_btnImageView setFrame:CGRectMake((width-imageWidth)/2, originY, imageWidth, iamgeHeight)];
    originY += iamgeHeight + sepHeight;
    
    CGSize titleSize = [FMUtils getLabelSizeBy:_titleLbl andContent:_titleLbl.text andMaxLabelWidth:width];
    [_titleLbl setFrame:CGRectMake((width - titleSize.width)/2, originY, titleSize.width, titleSize.height)];
}

- (void) onHeaderBtnClick:(id) sender {
    _actionBlock();
}

@end
