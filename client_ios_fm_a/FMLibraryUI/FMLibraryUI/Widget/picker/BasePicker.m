//
//  BasePicker.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/30/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BasePicker.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "BaseBundle.h"

@interface BasePicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView * controlView;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * okBtn;

@property (nonatomic, strong) UIPickerView * picker;

@property (nonatomic, strong) UIFont *mFont;

@property (nonatomic, strong) NSMutableArray * array;

@property (nonatomic, assign) NSInteger centerIndex; //


@property (nonatomic, assign) CGFloat controlHeight;
@property (nonatomic, assign) CGFloat btnWidth;

@property (nonatomic, weak) id<OnItemClickListener> listener;
@property (nonatomic, assign) BOOL isInited;
@end

@implementation BasePicker

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
        
        _controlHeight = 40;
        _btnWidth = 70;
        _mFont = [FMFont fontWithSize:14];  //默认为14
        
        _controlView = [[UIView alloc] init];
        _cancelBtn = [[UIButton alloc] init];
        _okBtn = [[UIButton alloc] init];
        
        _picker = [[UIPickerView alloc] init];
        
        _controlView.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        _controlView.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        
        _cancelBtn.tag = BASE_PICKER_ACTION_CANCEL;
        _okBtn.tag = BASE_PICKER_ACTION_OK;
        
        [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] forState:UIControlStateNormal];
        [_okBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
        
        [_cancelBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        [_okBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        
//        [_cancelBtn.titleLabel setFont:[FMFont fontWithSize:14]];
//        [_okBtn.titleLabel setFont:[FMFont fontWithSize:14]];
        
        [_cancelBtn.titleLabel setFont:[FMFont getInstance].font44];
        [_okBtn.titleLabel setFont:[FMFont getInstance].font44];
        
        [_cancelBtn addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn addTarget:self action:@selector(onOKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator=YES;
        
        [_controlView addSubview:_cancelBtn];
        [_controlView addSubview:_okBtn];
        
        [self addSubview:_controlView];
        [self addSubview:_picker];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    [_controlView setFrame:CGRectMake(0, 0, width, _controlHeight)];
    [_cancelBtn setFrame:CGRectMake(0, 0, _btnWidth, _controlHeight)];
    [_okBtn setFrame:CGRectMake(width-_btnWidth, 0, _btnWidth, _controlHeight)];
    
    [_picker setFrame:CGRectMake(0, _controlHeight, width, height - _controlHeight)];
}

- (void) updatePicker {
    [_picker reloadAllComponents];
}

- (void) showCenterIndex {
    [_picker selectRow:_centerIndex inComponent:0 animated:NO];
}

//设置字体大小
- (void) setRowFont:(UIFont *) font {
    _mFont = font;
}

//设置数据数组, 参数是字符串数组
- (void) setDataByArray:(NSArray *) array {
    _array = [NSMutableArray arrayWithArray:array];
    [self updatePicker];
}

- (void) setCenterIndex:(NSInteger) index {
    _centerIndex = index;
    [self showCenterIndex];
}

- (void) setCenterData:(NSString *) data {
    if(data) {
        BOOL needUpdate = NO;
        NSInteger index = 0;
        for(NSString* obj in _array) {
            if([data isEqualToString:obj]) {
                _centerIndex = index;
                needUpdate = YES;
                break;
            }
            index++;
        }
        if(needUpdate) {
            [self showCenterIndex];
        }
    }
}

- (void) onCancelButtonClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_cancelBtn];
    }
}

- (void) onOKButtonClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_okBtn];
    }
}


//获取选中的时间
- (id) getSelectedData {
    NSInteger curIndex = [_picker selectedRowInComponent:0];
    id data = _array[curIndex];
    return data;
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
}

//获取选中的位置
- (NSInteger) getSelectedIndex {
    return [_picker selectedRowInComponent:0];
}

#pragma mark - datasource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = 0;
    if(component == 0 ) {
        count = [_array count];
    }
    return count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat itemWidth = 0;
    CGFloat width = CGRectGetWidth(pickerView.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    switch(component) {
        case 0:
            itemWidth = width - padding * 2;
            break;
    }
    return itemWidth;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch(component) {
        case 0:
            _centerIndex = row;
            break;
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * desc = @"";
    switch(component) {
        case 0:
            desc = _array[row];
            break;
    }
    return desc;
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * label = (UILabel *)view;
    if(!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = _mFont;  //默认为14
        label.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
    }
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

@end

