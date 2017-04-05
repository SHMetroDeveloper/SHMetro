//
//  AssetProfileView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetProfileView.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface AssetProfileView()
@property (readwrite, nonatomic, strong) UILabel * contentLbl;

@property (readwrite, nonatomic, assign) NSInteger amount;
@property (readwrite, nonatomic, assign) NSInteger category;
@property (readwrite, nonatomic, assign) NSInteger ppm;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation AssetProfileView

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
     
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.numberOfLines = 0;
        _contentLbl.font = [FMFont fontWithSize:15];
        _contentLbl.textAlignment = NSTextAlignmentLeft;
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        [self addSubview:_contentLbl];
    }
}

- (void) updateViews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat padding = [FMSize getInstance].padding50;
    
    [_contentLbl setFrame:CGRectMake(padding, 0, width-padding*2, height)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_contentLbl setText:[NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"asset_manage_profile" inTable:nil],_amount,_category,_ppm]];
}

- (void) setInfoWithAssetTotalAmount:(NSInteger) amount
                       Assetcategory:(NSInteger) category
                        PlanMaintain:(NSInteger) ppm {
    _amount = amount;
    _category = category;
    _ppm = ppm;
    
    [self updateInfo];
}


+ (CGFloat) calculateHeightByWidth:(CGFloat) width andTotalAmount:(NSInteger) amount category:(NSInteger) category planmaintain:(NSInteger) ppm {
    
    CGFloat height = 0;
    CGFloat padding = [FMSize getSizeByPixel:50];
    
    UILabel * contentLbl = [UILabel new];
    contentLbl.numberOfLines = 0;
    contentLbl.font = [FMFont fontWithSize:15];
    contentLbl.textAlignment = NSTextAlignmentLeft;
    
    CGSize contentSize = [FMUtils getLabelSizeBy:contentLbl andContent:[NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"asset_manage_profile" inTable:nil],amount,category,ppm] andMaxLabelWidth:width-padding*2];
    height = contentSize.height + padding * 2;
    
    contentLbl = nil;
    
    return height;
}

@end

