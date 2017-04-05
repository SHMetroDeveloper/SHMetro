//
//  WriteOrderAddToolViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WriteOrderAddToolViewController.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "BaseTextField.h"
#import "UIButton+Bootstrap.h"
#import "WorkOrderDetailEntity.h"
#import "FMSize.h"
#import "CaptionTextField.h"
#import "CaptionTextView.h"
#import "WorkOrderSaveEntity.h"
#import "WorkOrderBusiness.h"
#import "IQKeyboardManager.h"

@interface WriteOrderAddToolViewController () <OnViewResizeListener>

@property (readwrite, nonatomic, strong) UIScrollView * mainContainer;

//@property (readwrite, nonatomic, strong) BaseTextField * orderCodeBaseTF;
@property (readwrite, nonatomic, strong) CaptionTextField * toolNameBaseTF;
@property (readwrite, nonatomic, strong) CaptionTextField * toolBrandBaseTF;
@property (readwrite, nonatomic, strong) CaptionTextField * toolModelBaseTF;
@property (readwrite, nonatomic, strong) CaptionTextField * countBaseTF;
@property (readwrite, nonatomic, strong) CaptionTextField * unitBaseTF;
@property (readwrite, nonatomic, strong) CaptionTextField * costBaseTF;
@property (readwrite, nonatomic, strong) CaptionTextView * descBaseTF;


@property (readwrite, nonatomic, strong) WorkOrderTool * tool;

@property (readwrite, nonatomic, strong) id<OnMessageHandleListener> resultHandler;
@property (readwrite, nonatomic, assign) WriteOrderAddToolOperateType requestType;

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;
@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSNumber * toolId;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultDescHeight;


@end


@implementation WriteOrderAddToolViewController

- (instancetype) initWithOperateType:(WriteOrderAddToolOperateType) operateType{
    self = [super  init];
    if(self) {
        _requestType = operateType;
    }
    return self;
}

- (void) initLayout {
    if(!_mainContainer) {
        
        _business = [WorkOrderBusiness getInstance];
        
        //此页面不需要自动键盘遮盖处理故做移除处理。
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        if (![manager.disabledDistanceHandlingClasses containsObject:[self class]]) {
            [manager.disabledDistanceHandlingClasses addObject:[self class]];
        }

        CGRect frame = self.view.frame;
        _defaultItemHeight = 92;
        _defaultDescHeight = 174;
        CGFloat originx = 0;
        CGFloat originY = 0;
        
        CGFloat sepHeight = 0;
        
        
        frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _mainContainer = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainer.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        CGFloat itemHeight = _defaultItemHeight;
        _toolNameBaseTF = [[CaptionTextField alloc] initWithFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
        [_toolNameBaseTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_tool_name" inTable:nil]];
        [_toolNameBaseTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_tool_name_placeholder" inTable:nil]];
        [_toolNameBaseTF setShowMark:YES];
        originY += itemHeight + sepHeight;
        
        
//        _toolBrandBaseTF = [[CaptionTextField alloc] initWithFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
//        [_toolBrandBaseTF setDetegate:self];
//        [_toolBrandBaseTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_tool_brand" inTable:nil]];
//        [_toolBrandBaseTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_tool_brand_placeholder" inTable:nil]];
//        originY += itemHeight + sepHeight;
        
        _toolModelBaseTF = [[CaptionTextField alloc] initWithFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
        [_toolModelBaseTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_tool_model" inTable:nil]];
        [_toolModelBaseTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_tool_model_placeholder" inTable:nil]];
        originY += itemHeight + sepHeight;
        
        _countBaseTF = [[CaptionTextField alloc] init];
        [_countBaseTF setFrame:CGRectMake(originx, originY, (_realWidth - originx*2), itemHeight)];
        [_countBaseTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_tool_amount" inTable:nil]];
        [_countBaseTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_tool_amount_placeholder" inTable:nil]];
        [_countBaseTF setShowMark:YES];
        [_countBaseTF setKeyboardType:UIKeyboardTypeNumberPad];
        originY += itemHeight + sepHeight;
        
        _unitBaseTF = [[CaptionTextField alloc] init];
        [_unitBaseTF setFrame:CGRectMake(originx, originY, (_realWidth - originx*2), itemHeight)];
        [_unitBaseTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_tool_unit" inTable:nil]];
        [_unitBaseTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_tool_unit_placeholder" inTable:nil]];
        [_unitBaseTF setShowMark:YES];
        originY += itemHeight + sepHeight;
        
        _costBaseTF = [[CaptionTextField alloc] init];
        [_costBaseTF setFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
        [_costBaseTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_tool_cost" inTable:nil]];
        [_costBaseTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_tool_cost_placeholder" inTable:nil]];
        [_costBaseTF setShowMark:YES];
        [_costBaseTF setKeyboardType:UIKeyboardTypeDecimalPad];
        originY += itemHeight + sepHeight;
        
        
        itemHeight = _defaultDescHeight;
        _descBaseTF = [[CaptionTextView alloc] initWithFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
        [_descBaseTF setFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
        [_descBaseTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_tool_desc" inTable:nil]];
        [_descBaseTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_tool_desc_placeholder" inTable:nil]];
        [_descBaseTF setOnViewResizeListener:self];
        originY += itemHeight + sepHeight;
        
        _mainContainer.contentSize = CGSizeMake(_realWidth, originY);
        
        [_mainContainer addSubview:_toolNameBaseTF];
//        [_mainContainer addSubview:_toolBrandBaseTF];
        [_mainContainer addSubview:_toolModelBaseTF];
        [_mainContainer addSubview:_countBaseTF];
        [_mainContainer addSubview:_unitBaseTF];
        [_mainContainer addSubview:_costBaseTF];
        [_mainContainer addSubview:_descBaseTF];
        
        
        [self.view addSubview:_mainContainer];
        
        [self updateInfo];
    }
}

- (void) updateLayout {
   
    CGFloat originx = 0;
    CGFloat originY = 0;
    CGFloat sepHeight = 0;
    CGFloat itemHeight = _defaultItemHeight;
    CGFloat descHeight = 0;
    
    [_toolNameBaseTF setFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_toolModelBaseTF setFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_countBaseTF setFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_unitBaseTF setFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_costBaseTF setFrame:CGRectMake(originx, originY, _realWidth - originx*2, itemHeight)];
    originY += itemHeight + sepHeight;
    
//    NSInteger count = 5;
//    CGFloat originY = _defaultItemHeight * count;
    
//    CGFloat itemHeight = CGRectGetHeight(_descBaseTF.frame);
    descHeight = CGRectGetHeight(_descBaseTF.frame);
    [_descBaseTF setFrame:CGRectMake(0, originY, _realWidth, descHeight)];
    originY += descHeight + sepHeight;
    
    _mainContainer.contentSize = CGSizeMake(_realWidth, originY);
    
}

- (void) updateInfo {
    if(_tool) {
        [_toolNameBaseTF setText:_tool.name];
        [_toolModelBaseTF setText:_tool.model];
        [_countBaseTF setText:_tool.amount];
        [_unitBaseTF setText:_tool.unit];
        [_costBaseTF setText:[[NSString alloc] initWithFormat:@"%.2f", [_tool.cost floatValue]]];
        [_descBaseTF setText:_tool.comment];
    }
}

- (void) initNavigation {
    if(_requestType == ORDER_TOOL_OPERATE_TYPE_ADD) {
        [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_tool_add" inTable:nil]];
    } else {
        [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_tool_edit" inTable:nil]];
    }
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateLayout];
}



- (void) setInfoWith:(WorkOrderTool *) tool {
    _tool = [tool copy];
    [self updateInfo];
}

- (void) setWorkOrderId:(NSNumber *)woId {
    _woId = [woId copy];
}

- (WorkOrderTool *) getInfoInput {
    if(!_tool) {
        _tool = [[WorkOrderTool alloc] init];
    }
    _tool.toolId = _toolId;
    _tool.name = [NSString stringWithFormat:@"%@",_toolNameBaseTF.text];
    _tool.model = [NSString stringWithFormat:@"%@", _toolModelBaseTF.text];
    _tool.unit = [NSString stringWithFormat:@"%@", _unitBaseTF.text];
    _tool.amount = [[NSString alloc] initWithFormat:@"%@", _countBaseTF.text];
    _tool.cost = [NSNumber numberWithDouble:[_costBaseTF.text doubleValue]];
    _tool.comment = [[NSString alloc] initWithFormat:@"%@", _descBaseTF.text];
    
    return _tool;
}

- (void) onAddButtonClicked {
    BOOL isOK = [self checkInputOK];
    if (isOK) {
        [self gotoUploadToolsInfo];
    }
}

- (void) onMenuItemClicked:(NSInteger)position {
    BOOL isOK = [self checkInputOK];
    if (isOK) {
        [self gotoUploadToolsInfo];
    }
}

- (BOOL) checkInputOK {
    BOOL res = YES;
    NSString * tmpStr;
    NSString * notice;
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    tmpStr = [_toolNameBaseTF text];
    if(res && [FMUtils isStringEmpty:tmpStr]) {
        notice = [[BaseBundle getInstance] getStringByKey:@"order_tool_notice_name_empty" inTable:nil];
        res = NO;
    }
    
    tmpStr = [_countBaseTF text];
    if(res && [FMUtils isStringEmpty:tmpStr]) {
        notice = [[BaseBundle getInstance] getStringByKey:@"order_tool_notice_amount_empty" inTable:nil];
        res = NO;
    }
    
    tmpStr = [_unitBaseTF text];
    if(res && [FMUtils isStringEmpty:tmpStr]) {
        notice = [[BaseBundle getInstance] getStringByKey:@"order_tool_notice_unit_empty" inTable:nil];
        res = NO;
    }
    
    if (res && [formatter numberFromString:_costBaseTF.text].floatValue == 0) {
        notice = [[BaseBundle getInstance] getStringByKey:@"order_tool_notice_cost_empty" inTable:nil];
        res = NO;
    }
    
    tmpStr = [_costBaseTF text];
    if(res && [FMUtils isStringEmpty:tmpStr]) {
        notice = [[BaseBundle getInstance] getStringByKey:@"order_tool_notice_cost_empty" inTable:nil];
        res = NO;
    }
    
    
    
    if(!res) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:notice time:DIALOG_ALIVE_TIME_SHORT];
    }
    return res;
}


- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _resultHandler = handler;
}

- (void) handleResult {
    BOOL isOK = [self checkInputOK];
    if(isOK && _resultHandler) {
        WorkOrderTool * result = [self getInfoInput];
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:@"WriteOrderAddToolViewController" forKeyPath:@"msgOrigin"];
        [msg setValue:[NSNumber numberWithInteger:_requestType] forKeyPath:@"requestType"];
        [msg setValue:@"WriteOrderAddToolViewController" forKeyPath:@"resultType"];
        [msg setValue:result forKeyPath:@"result"];
        [_resultHandler handleMessage:msg];
    }
    [self finish];
}

#pragma mark - 备注内容长度变化
- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _descBaseTF) {
        CGRect frame = _descBaseTF.frame;
        frame.size = newSize;
        _descBaseTF.frame = frame;
        [self updateLayout];
    }
}

#pragma mark - 键盘展示
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
            CGRect frame = _mainContainer.frame;
            frame.size.height = _realHeight - keyboardSize.height;
            [_mainContainer setFrame:frame];
            [self updateLayout];
        }];
    }
}



- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
        CGRect frame = _mainContainer.frame;
        frame.size.height = _realHeight;
        [_mainContainer setFrame:frame];
        [self updateLayout];
    }];
}


#pragma mark - 网络上传
- (void) gotoUploadToolsInfo {
    [self showLoadingDialog];
    WorkOrderToolSaveRequestParam * param = [self getToolsInfoParam];
    [_business saveWorkOrderTools:param success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        if (_requestType == ORDER_TOOL_OPERATE_TYPE_ADD) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_tools_add_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_tools_modify_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
        _toolId = object; //获取到toolId
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self handleResult];
//            [self finish];
        });
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_tools_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}


- (WorkOrderToolSaveRequestParam *)getToolsInfoParam {
    WorkOrderToolSaveRequestParam * param = [[WorkOrderToolSaveRequestParam alloc] init];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    if (_requestType == ORDER_TOOL_OPERATE_TYPE_ADD) {
        param.operateType = WORK_ORDER_TOOL_EDIT_TYPE_ADD;
        param.woId = _woId;
        param.toolId = nil;   //在新增工具时没有此项
        param.name = [NSString stringWithFormat:@"%@",_toolNameBaseTF.text];
        param.model = [NSString stringWithFormat:@"%@", _toolModelBaseTF.text];
        param.unit = [NSString stringWithFormat:@"%@", _unitBaseTF.text];
        param.amount = [formatter numberFromString:[NSString stringWithFormat:@"%@", _countBaseTF.text]].integerValue;
        param.cost = [formatter numberFromString:[NSString stringWithFormat:@"%@", _costBaseTF.text]].doubleValue;
        param.comment = [[NSString alloc] initWithFormat:@"%@", _descBaseTF.text];
    } else if (_requestType == ORDER_TOOL_OPERATE_TYPE_EDIT) {
        param.operateType = WORK_ORDER_TOOL_EDIT_TYPE_MODIFY;
        param.woId = _woId;
        param.toolId = _tool.toolId;   //在修改工具时需要此项
        param.name = [NSString stringWithFormat:@"%@",_toolNameBaseTF.text];
        param.model = [NSString stringWithFormat:@"%@", _toolModelBaseTF.text];
        param.unit = [NSString stringWithFormat:@"%@", _unitBaseTF.text];
        param.amount = [formatter numberFromString:[NSString stringWithFormat:@"%@", _countBaseTF.text]].integerValue;
        param.cost = [formatter numberFromString:[NSString stringWithFormat:@"%@", _costBaseTF.text]].doubleValue;
        param.comment = [[NSString alloc] initWithFormat:@"%@", _descBaseTF.text];
    }
    return param;
}

@end







