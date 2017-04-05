//
//  MaterialQueryFilterViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/6.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "MaterialQueryFilterViewController.h"
#import "UIButton+Bootstrap.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"
#import "FilterSelectView.h"
#import "REFrostedViewController.h"

#import "BaseBundle.h"

@interface MaterialQueryFilterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView * mainContainerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) UITextField *filiterParamTextField;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation MaterialQueryFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        frame.size.width -= 80;
        frame.size.height -= [FMSize getInstance].statusbarHeight + [FMSize getInstance].navigationbarHeight;
        CGFloat controlHeight = 60;
        CGFloat originX = 0;
        CGFloat originY = 0;
        
        _selectArray = [NSMutableArray new];
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        //tableView的初始化
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-controlHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        //按钮控制View
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-controlHeight, frame.size.width, controlHeight)];
        _controlView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        CGFloat btnHeight = [FMSize getInstance].selectListItemHeight;;
        CGFloat sepHeight = (controlHeight - btnHeight)/2;
        CGFloat btnWidth = (_controlView.frame.size.width - sepHeight*3)/2;
        originY = sepHeight;
        originX = sepHeight;
        
        //取消按钮
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, btnWidth, btnHeight)];
        [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_reset" inTable:nil] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
        _cancelBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
        [_cancelBtn grayStyle];
        _cancelBtn.layer.cornerRadius = 3;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(onResetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //确定按钮
        _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX + sepHeight + btnWidth, originY, btnWidth, btnHeight)];
        [_doneBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
        [_doneBtn setBackgroundColor:[UIColor colorWithRed:97/255.0 green:184/255.0 blue:41/255.0 alpha:1]];
        [_doneBtn successStyle];
        _doneBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
        _doneBtn.layer.cornerRadius = 3;
        _doneBtn.layer.masksToBounds = YES;
        [_doneBtn addTarget:self action:@selector(onOkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_controlView addSubview:_cancelBtn];
        [_controlView addSubview:_doneBtn];
        
        [_mainContainerView addSubview:_tableView];
        [_mainContainerView addSubview:_controlView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) onResetBtnClick {
    [_selectArray removeAllObjects];
    [_filiterParamTextField setText:nil];
    [_tableView reloadData];
}

- (void) onOkBtnClick {
    [self handleResult];
    [self.frostedViewController hideMenuViewController];
}

#pragma mark - OnMessageHandleListener
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    if (handler) {
        _handler = handler;
    }
}

- (void)handleResult {
    NSString *name = nil;
    if (![FMUtils isStringEmpty:[_filiterParamTextField text]]) {
        name = [_filiterParamTextField text];
    }
    NSNumber *type = nil;
    if (_selectArray.count > 0) {
        NSIndexPath *index = _selectArray[0];
        type = [NSNumber numberWithInteger:index.row];
    }
    
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    [eventData setValue:name forKeyPath:@"name"];
    [eventData setValue:type forKeyPath:@"type"];
    
    [msg setValue:eventData forKeyPath:@"result"];
    
    [_handler handleMessage:msg];
}





#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section == 0) {
        count = 1;
    } else if (section == 1) {
        count = 3;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 0;
    itemHeight = [FMSize getInstance].selectListItemHeight;
    return itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    CGFloat itemHeight = [FMSize getInstance].selectListItemHeight;
    CGFloat width = tableView.frame.size.width;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    UITableViewCell *cell = nil;
    SeperatorView *seperator = nil;
    FilterSelectView *selectItemView = nil;
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:{
            cellIdentifier = @"cellParam";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray *subViews = [cell.contentView subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[UITextField class]]) {
                        _filiterParamTextField = (UITextField *)view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *)view;
                    }
                }
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell.contentView addSubview:seperator];
            }
            if (cell && !_filiterParamTextField) {
                _filiterParamTextField = [[UITextField alloc] init];
                _filiterParamTextField.font = [FMFont getInstance].font42;
                [_filiterParamTextField setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"inventory_query_condition_param_placehoder" inTable:nil]];
                _filiterParamTextField.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
                [cell.contentView addSubview:_filiterParamTextField];
            }
            if (seperator) {
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
            if (_filiterParamTextField) {
                [_filiterParamTextField setFrame:CGRectMake(0, 0, width, itemHeight)];
                UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, itemHeight)];
                _filiterParamTextField.leftViewMode = UITextFieldViewModeAlways;
                _filiterParamTextField.leftView = leftview;
            }
        }
            break;
            
        case 1:{
            cellIdentifier = @"cellType";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray *subViews = [cell.contentView subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[FilterSelectView class]]) {
                        selectItemView = (FilterSelectView *)view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *)view;
                    }
                }
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell.contentView addSubview:seperator];
            }
            if (cell && !selectItemView) {
                selectItemView = [[FilterSelectView alloc] init];
                [cell.contentView addSubview:selectItemView];
            }
            if (seperator) {
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
            if (selectItemView) {
                [selectItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                [selectItemView setTitleInfoWith:@[ [[BaseBundle getInstance] getStringByKey:@"inventory_query_filter_empty" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"inventory_query_filter_enough" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"inventory_query_filter_lack" inTable:nil]][position]];
                
                BOOL isExist = NO;
                for (NSIndexPath *index in _selectArray) {
                    if ([index isEqual:indexPath]) {
                        isExist = YES;
                    }
                }
                [selectItemView setChecked:isExist];
            }
        }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01f;  //grouped类型的Tableview加上这一句 防止两个section之间的间隙
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = [FMSize getInstance].selectHeaderHeight;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 52)];
    titleView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    CGFloat padding = [FMSize getInstance].padding50;
    
    titleLbl.font = [FMFont getInstance].font42;
    titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L4];
    [titleLbl setFrame:CGRectMake(padding, [FMSize getInstance].padding70, 80, 19)];
    switch (section) {
        case 0:
            titleLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_query_filter_header_name" inTable:nil];;
            break;
        case 1:
            titleLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_query_filter_header_amount" inTable:nil];;
            break;
    }
    
    [titleView addSubview:titleLbl];
    
    return titleView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_selectArray removeAllObjects];
    [_selectArray addObject:indexPath];
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end


