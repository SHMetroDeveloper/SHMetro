//
//  MaterialBatchPickerView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/15.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "MaterialBatchPickerView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

@interface MaterialBatchPickerView ()

@property (readwrite, nonatomic, strong) UIView * headerView;
@property (readwrite, nonatomic, strong) SeperatorView * headerSeperatorView;

@property (readwrite, nonatomic, strong) UILabel * duedateLbl;      //过期时间
@property (readwrite, nonatomic, strong) UILabel * amountLbl;       //批次数量
@property (readwrite, nonatomic, strong) UIPickerView * pickerView; //型号


@property (readwrite, nonatomic, assign) CGFloat headerHeight;            //子项的高度


@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation MaterialBatchPickerView

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
    if(!_isInited) {
        _isInited = YES;
        
        _headerHeight = [FMSize getInstance].listHeaderHeight;
        
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
       
        _headerView = [[UIView alloc] init];
        _headerSeperatorView = [[SeperatorView alloc] init];
        
        _duedateLbl = [[UILabel alloc] init];
        _amountLbl = [[UILabel alloc] init];
       
        _pickerView = [[UIPickerView alloc] init];
        
        [_duedateLbl setText:[[BaseBundle getInstance] getStringByKey:@"order_material_over_due" inTable:nil]];
        [_amountLbl setText:[[BaseBundle getInstance] getStringByKey:@"order_material_amount" inTable:nil]];
        
        [_duedateLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]];
        [_amountLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]];
        
        [_duedateLbl setFont:[FMFont getInstance].defaultFontLevel2];
        [_amountLbl setFont:[FMFont getInstance].defaultFontLevel2];
        
        [_amountLbl setTextAlignment:NSTextAlignmentCenter];
        [_duedateLbl setTextAlignment:NSTextAlignmentCenter];
        
    
        
        [_headerView addSubview:_duedateLbl];
        [_headerView addSubview:_amountLbl];
        
        [self addSubview:_headerView];
        [self addSubview:_headerSeperatorView];
        [self addSubview:_pickerView];
    }
}


- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height =CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat originY = 0;
    CGFloat originX = padding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    [_headerView setFrame:CGRectMake(0, originY, width, _headerHeight)];
    [_headerSeperatorView setFrame:CGRectMake(padding, originY + (_headerHeight - seperatorHeight), width - padding * 2, seperatorHeight)];
    
    [_duedateLbl setFrame:CGRectMake(originX, 0, (width-padding*2)*2/3, _headerHeight)];
    originX += (width-padding*2)*2/3;
    [_amountLbl setFrame:CGRectMake(originX, 0, (width-padding*2)/3, _headerHeight)];
    originY += _headerHeight;
    
    [_pickerView setFrame:CGRectMake(0, originY, width, height-_headerHeight)];
    
}


- (void) setPickerDelegate:(id<UIPickerViewDelegate>) delegate {
    _pickerView.delegate = delegate;
}
- (void) setPickerDataSource:(id<UIPickerViewDataSource>) dataSource {
    _pickerView.dataSource = dataSource;
}

- (void) update {
    [_pickerView reloadAllComponents];
}

- (NSInteger) getSelectedRowIndex {
    NSInteger index = [_pickerView selectedRowInComponent:0];
    return index;
}

//设置选中第几行
- (void) setSelectRow:(NSInteger) row {
    [_pickerView selectRow:row inComponent:0 animated:YES];
}
@end

