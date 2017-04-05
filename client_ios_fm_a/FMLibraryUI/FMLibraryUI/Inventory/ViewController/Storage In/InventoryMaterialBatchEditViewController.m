//
//  MaterialBatchEditViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/29.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialBatchEditViewController.h"
#import "CaptionTextField.h"
#import "BaseTimePicker.h"
#import "TaskAlertView.h"
#import "InventoryProviderSelectViewController.h"
#import "InventoryMaterialProviderEntity.h"
#import "InfoSelectViewController.h"
#import "InventoryBusiness.h"
#import "BaseBundle.h"

@interface ProviderSelectButton : UIButton
@end

@implementation ProviderSelectButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat height = CGRectGetHeight(contentRect);
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat imageWidth = 20;
    CGFloat imageHeight = 20;
    
    CGRect newRect = CGRectMake((width-imageWidth)/2, (height-imageHeight)/2, imageWidth, imageHeight);
    return newRect;
}
@end


@interface InventoryMaterialBatchEditViewController ()<OnClickListener,OnItemClickListener,OnMessageHandleListener,UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *mainContainerView;

@property (nonatomic, strong) CaptionTextField *providerField;
@property (nonatomic, strong) CaptionTextField *dueTimeField;
@property (nonatomic, strong) CaptionTextField *priceField;
@property (nonatomic, strong) CaptionTextField *amountField;

@property (nonatomic, strong) UITextField *providerTextView;
@property (nonatomic, strong) ProviderSelectButton *providerBtn;

@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, assign) CGFloat defaultItemHeight;

@property (nonatomic, strong) InventoryMaterialBatchViewModel *materialBatchModel;
@property (nonatomic, strong) NSNumber *duetime;

@property (nonatomic, strong) InventoryBusiness *business;
@property (nonatomic, strong) NetPage * page;
@property (nonatomic, strong) NSMutableArray * providerArray;
@property (nonatomic, assign) NSInteger providerIndex;

@property (nonatomic, assign) BOOL needUpdate;
@property (nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation InventoryMaterialBatchEditViewController



- (void)initNavigation {
    if (BATCH_EDIT_TYPE_MODIFY == _editType) {
        [self setTitleWith: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_title_edit" inTable:nil]];
    } else if(BATCH_EDIT_TYPE_ADD == _editType) {
        [self setTitleWith: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_title" inTable:nil]];
    }
    [self setBackAble:YES];
    [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil]]];
}


- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        _defaultItemHeight = 92;
        
        if (!_materialBatchModel) {
            _materialBatchModel = [[InventoryMaterialBatchViewModel alloc] init];
        }
        _providerIndex = -1;
        _business = [InventoryBusiness getInstance];
        _page = [[NetPage alloc] init];
        
        _mainContainerView = [[UIScrollView alloc] initWithFrame:mFrame];
        
        CGFloat originX = 0;
        CGFloat originY = 0;
        CGFloat btnWidth = 48;
        
        _providerField = [[CaptionTextField alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, _defaultItemHeight)];
        [_providerField setShowMark:YES];
        [_providerField setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_provider" inTable:nil]];
        originY += _defaultItemHeight;
        
        
        _providerTextView = [[UITextField alloc] initWithFrame:CGRectMake(0, 44, _realWidth-btnWidth, btnWidth - [FMSize getInstance].seperatorHeight)];
        _providerTextView.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _providerTextView.font = [FMFont fontWithSize:14];
        _providerTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _providerTextView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, btnWidth)];
        _providerTextView.leftView = leftView;
        _providerTextView.leftViewMode = UITextFieldViewModeAlways;
        [_providerTextView setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_provider_placehoder" inTable:nil]];
        _providerTextView.delegate = self;
        
        _providerBtn = [[ProviderSelectButton alloc] init];
        [_providerBtn setFrame:CGRectMake(_realWidth-btnWidth, 44, btnWidth, btnWidth - [FMSize getInstance].seperatorHeight)];
        [_providerBtn setImage:[[FMTheme getInstance] getImageByName:@"material_add_btn_img"] forState:UIControlStateNormal];
        [_providerBtn addTarget:self action:@selector(gotoSelectProvier) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_providerField addSubview:_providerBtn];
        [_providerField addSubview:_providerTextView];
        
        
        _dueTimeField = [[CaptionTextField alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, _defaultItemHeight)];
        [_dueTimeField setEditable:NO];
        [_dueTimeField setShowMark:NO];
        [_dueTimeField setOnClickListener:self];
        _dueTimeField.tag = 200;
        [_dueTimeField setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_duetime" inTable:nil]];
        [_dueTimeField setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_duetime_placehoder" inTable:nil]];
        [_dueTimeField setDesc:NSLocalizedString(@"", nil)];
        originY += _defaultItemHeight;
        
        
        _priceField = [[CaptionTextField alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, _defaultItemHeight)];
        [_priceField setEditable:YES];
        [_priceField setShowMark:YES];
        [_priceField setOnClickListener:self];
        _priceField.tag = 300;
        [_priceField setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_price" inTable:nil]];
        [_priceField setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_price_placehoder" inTable:nil]];
        [_priceField setDesc:NSLocalizedString(@"", nil)];
        _priceField.keyboardType = UIKeyboardTypeDecimalPad;
        originY += _defaultItemHeight;
        
        
        _amountField = [[CaptionTextField alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, _defaultItemHeight)];
        [_amountField setEditable:YES];
        [_amountField setShowMark:YES];
        [_amountField setOnClickListener:self];
        _amountField.tag = 400;
        [_amountField setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_amount" inTable:nil]];
        [_amountField setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_amount_placehoder" inTable:nil]];
        [_amountField setDesc:NSLocalizedString(@"", nil)];
        _amountField.keyboardType = UIKeyboardTypeDecimalPad;
        originY += _defaultItemHeight;
        
        
        [_mainContainerView addSubview:_providerField];
        [_mainContainerView addSubview:_dueTimeField];
        [_mainContainerView addSubview:_priceField];
        [_mainContainerView addSubview:_amountField];
        
        _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAlertView];
    [self requestProviders];
    [self updateInfo];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        [self updateInfo];
    }
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (position == 0) {
        [self tryToNotifyMessage];
    }
}

- (void)initAlertView {
    _datePicker = [[BaseTimePicker alloc] init];
    [_datePicker setOnItemClickListener:self];
    
    _datePicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_datePicker setPickerType:BASE_TIME_PICKER_DAY];
    
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_datePicker withKey:@"time" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (void)setMaterialBatchModelToModify:(InventoryMaterialBatchViewModel *) modifyMaterialBatchModel {
    _materialBatchModel = modifyMaterialBatchModel;
    _needUpdate = YES;
}

- (void)updateInfo {
    if (![FMUtils isStringEmpty:_materialBatchModel.name]) {
//        [_providerField setText:_materialBatchModel.name];
        [_providerTextView setText:_materialBatchModel.name];
    }
    InventoryMaterialProviderDetail * provider = [self getProvider];
    if(provider) {
        [_providerTextView setText:provider.name];
    }
    if (![FMUtils isNumberNullOrZero:_materialBatchModel.dueDate]) {
        _duetime = _materialBatchModel.dueDate;
        NSString *strTime = [FMUtils getDateTimeDescriptionBy:_duetime format:@"yyyy-MM-dd"];
        [_dueTimeField setText:strTime];
    }
    
    if (![FMUtils isStringEmpty:_materialBatchModel.price]) {
        [_priceField setText:[NSString stringWithFormat:@"%0.2f",_materialBatchModel.price.doubleValue]];
    }
    
    NSString *number = [NSString stringWithFormat:@"%0.2f",_materialBatchModel.number.doubleValue];
    if (![FMUtils isStringEmpty:number]) {
        [_amountField setText:number];
    }
    
    if (![FMUtils isNumberNullOrZero:_materialBatchModel.providerId]) {
//        _provider.providerId = _materialBatchModel.providerId;
    }
}

#pragma mark - 网络请求
//请求供应商列表
- (void) requestProviders {
    [self showLoadingDialog];
    InventoryMaterialProviderRequestParam *param = [[InventoryMaterialProviderRequestParam alloc] init];
    param.inventoryId = _inventoryId;
    param.page.pageSize = _page.pageSize;
    param.page.pageNumber = _page.pageNumber;
    [_business requestMaterialProvider:param success:^(NSInteger key, id object) {
        InventoryMaterialProviderResponseData *responseData = object;
        [_page setPage:responseData.page];
        if ([_page isFirstPage]) {
            _providerArray = responseData.contents;
        } else {
            [_providerArray addObjectsFromArray:responseData.contents];
        }
        if([_page haveMorePage]) {
            [_page nextPage];
            [self requestProviders];
        } else {
            [self hideLoadingDialog];
        }
        
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
    }];
}


#pragma mark - OnItemClickListener
- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    if ([view isKindOfClass:[BaseTimePicker class]]) {
        if (subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber *time;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:{
                    time = [_datePicker getSelectTime];
                    _duetime = time;
                    NSString *strTime = [FMUtils getDateTimeDescriptionBy:_duetime format:@"yyyy-MM-dd"];
                    [_dueTimeField setText:strTime];
                }
                    break;
                    
                case BASE_TIME_PICKER_ACTION_CANCEL:
                    break;
            }
            [_alertView close];
        }
    }
}

#pragma mark - OnClickListener
- (void)onClick:(UIView *)view {
    if ([view isKindOfClass:[CaptionTextField class]]) {
        switch (view.tag) {
//            case 100:{
//                [self gotoSelectProvier];
//            }
//                break;
                
            case 200:{
                [_providerTextView resignFirstResponder];
                [self showTimeSelectDialog];
            }
                break;
        }
    } else if ([view isKindOfClass:[TaskAlertView class]]) {
        [_alertView close];
    }
}

#pragma mark - Private Method
- (void)showTimeSelectDialog {
    NSDate *curDate = [NSDate date];
    NSNumber *time = nil;
    if (![FMUtils isNumberNullOrZero:_duetime]) {
        time = _duetime;
    } else {
        time = [FMUtils dateToTimeLong:curDate];
    }
    [_datePicker setCenterDate:time];
    
    [_alertView showType:@"time"];
    [_alertView show];
}

#pragma mark - OnMessageHandleListener
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    if (handler) {
        _handler = handler;
    }
}

- (InventoryMaterialProviderDetail *) getProvider {
    InventoryMaterialProviderDetail * res;
    if(_providerIndex >= 0 && _providerIndex < [_providerArray count]) {
        res = _providerArray[_providerIndex];
    }
    return res;
}

- (void)tryToNotifyMessage {
    InventoryMaterialProviderDetail * provider = [self getProvider];
    if(provider) {
        _materialBatchModel.providerId = provider.providerId;
    }
//    _materialBatchModel.name = [_providerField text];
    _materialBatchModel.name = [_providerTextView text];
    _materialBatchModel.dueDate = _duetime;
    _materialBatchModel.price = [_priceField text];
    _materialBatchModel.number = [_amountField text];
    
    if ([FMUtils isStringEmpty:_materialBatchModel.name]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_provider_placehoder" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if ([FMUtils isStringEmpty:_materialBatchModel.price]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_price_placehoder" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if (_materialBatchModel.number <= 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_material_batch_amount_placehoder" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        NSNumber * tmpNumber = [FMUtils stringToNumber:_materialBatchModel.price];
        _materialBatchModel.price = [[NSString alloc] initWithFormat:@"%.2f", tmpNumber.doubleValue];
        
        tmpNumber = [FMUtils stringToNumber:_materialBatchModel.number];
        _materialBatchModel.number = [[NSString alloc] initWithFormat:@"%.2f", tmpNumber.doubleValue];
        [self notifyEvent:_editType data:_materialBatchModel];
        [self finish];
    }
}

- (void) notifyEvent:(BatchEditType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithInteger:type] forKeyPath:@"eventType"];
        [result setValue:data forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
//        if([msgOrigin isEqualToString:@"InventoryProviderSelectViewController"]) {
//            _provider = [msg valueForKeyPath:@"result"];
////            [_providerField setText:_provider.name];
//            [_providerTextView setText:_provider.name];
//        }
        if([msgOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]) {
            InfoSelectRequestType requestType = [[msg valueForKeyPath:@"requestType"] integerValue];
            NSNumber * tmpNumber;
            NSMutableDictionary * result;
            switch (requestType) {
                
                case REQUEST_TYPE_COMMON_INFO_SELECT:
                    result = [msg valueForKeyPath:@"result"];
                    if(result) {
                        tmpNumber = [result valueForKeyPath:@"position"];
                        _providerIndex = tmpNumber.integerValue;
                        _needUpdate = YES;
                        
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _providerIndex = -1;
}

- (void)gotoSelectProvier {
//    InventoryProviderSelectViewController *providerSelectVC = [[InventoryProviderSelectViewController alloc] init];
//    providerSelectVC.inventoryId = _inventoryId;
//    [providerSelectVC setOnMessageHandleListener:self];
//    [self gotoViewController:providerSelectVC];
    
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSString * desc = [[BaseBundle getInstance] getStringByKey:@"function_inventory_select_provider" inTable:nil];
    for(InventoryMaterialProviderDetail * provider in _providerArray) {
        [data addObject:provider.name];
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}



@end
