//
//  QuickReportEquipmentTabBarView.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/10.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "QuickReportEquipmentTabBarView.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"

@interface QuickReportEquipmentTabBarView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *scanBtn;
@property (nonatomic, strong) SeperatorView *seperator;
@property (nonatomic, strong) SeperatorView *seperatorBottom;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation QuickReportEquipmentTabBarView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _selectBtn = [UIButton new];
        [_selectBtn setTitle:@"选择设备" forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [FMFont getInstance].font44;
        [_selectBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_selectBtn addTarget:self action:@selector(onSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _scanBtn = [UIButton new];
        [_scanBtn setTitle:@"扫码添加" forState:UIControlStateNormal];
        _scanBtn.titleLabel.font = [FMFont getInstance].font44;
        [_scanBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        [_scanBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_scanBtn addTarget:self action:@selector(onScanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _seperator = [[SeperatorView alloc] init];
        [_seperator setShowRightBound:YES];
        
        _seperatorBottom = [[SeperatorView alloc] init];
        
        self.contentView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self.contentView addSubview:_selectBtn];
        [self.contentView addSubview:_scanBtn];
        [self.contentView addSubview:_seperator];
        [self.contentView addSubview:_seperatorBottom];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat seperatorSize = [FMSize getInstance].seperatorHeight;
    
    [_selectBtn setFrame:CGRectMake(0, 0, width/2, height)];
    
    [_scanBtn setFrame:CGRectMake(width/2, 0, width/2, height)];
    
    [_seperator setFrame:CGRectMake(width/2-seperatorSize, 0, seperatorSize, height)];
    
    [_seperatorBottom setFrame:CGRectMake(0, height-seperatorSize, width, seperatorSize)];
}

- (void)onSelectBtnClick:(UIButton *)sender {
    _actionBlock(QUICK_REPORT_EQUIPMENT_TAB_ACTION_SELECT,nil);
}

- (void)onScanBtnClick:(UIButton *)sender {
    _actionBlock(QUICK_REPORT_EQUIPMENT_TAB_ACTION_QR_SCAN,nil);
}

+ (CGFloat)getItemHeight  {
    CGFloat height = 48;
    
    return height;
}

@end
