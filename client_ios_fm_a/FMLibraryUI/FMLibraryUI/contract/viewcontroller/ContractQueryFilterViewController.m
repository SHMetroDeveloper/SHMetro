//
//  ContractQueryFilterViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractQueryFilterViewController.h"
#import "ContractServerConfig.h"
#import "FMColor.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"

#import "ContractEntity.h"
#import "BaseDataEntity.h"
#import "FilterSelectView.h"
#import "SeperatorView.h"
#import "REFrostedViewController.h"
#import "UIButton+Bootstrap.h"

typedef NS_ENUM(NSInteger, ContractQueryFilterSectionType) {
    CONTRACT_FILTER_SECTION_UNKNOW,
    CONTRACT_FILTER_SECTION_CODE,     //合同编码
    CONTRACT_FILTER_SECTION_STATUS,   //状态
};

@interface ContractQueryFilterViewController ()
@property (nonatomic, strong) UIView * mainContainerView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * controlView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) UITextField * codeTF;


@property (nonatomic, strong) NSMutableArray *statusArray;  //一共6种状态
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation ContractQueryFilterViewController

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _statusArray = [[NSMutableArray alloc] init];
    _selectedArray = [NSMutableArray new];
    
//    //支付类型
//    [_costTypeArray addObject:[NSNumber numberWithInteger:CONTRACT_COST_TRANSFER]];
//    [_costTypeArray addObject:[NSNumber numberWithInteger:CONTRACT_COST_CASH]];
//    [_costTypeArray addObject:[NSNumber numberWithInteger:CONTRACT_COST_DRAFT]];
    
    //获取状态信息
    [_statusArray addObject:[NSNumber numberWithInteger:CONTRACT_STATUS_UNDO]];
    [_statusArray addObject:[NSNumber numberWithInteger:CONTRACT_STATUS_EXECUTING]];
    [_statusArray addObject:[NSNumber numberWithInteger:CONTRACT_STATUS_EXPIRED]];
    
    [_statusArray addObject:[NSNumber numberWithInteger:CONTRACT_STATUS_VERFIED_NO]];
    [_statusArray addObject:[NSNumber numberWithInteger:CONTRACT_STATUS_VERFIED_YES]];
    [_statusArray addObject:[NSNumber numberWithInteger:CONTRACT_STATUS_TERMINATED]];
    [_statusArray addObject:[NSNumber numberWithInteger:CONTRACT_STATUS_CLOSED]];
}

- (void) initLayout {
    CGFloat controlHeight = [FMSize getInstance].bottomControlHeight;
    controlHeight = 60;
    CGRect frame = [self getContentFrame];
    CGFloat originX = 0;
    CGFloat originY = 0;
    frame.size.width -= 80;
    frame.size.height -= [FMSize getInstance].statusbarHeight + [FMSize getInstance].navigationbarHeight;
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    
    //tableView的初始化
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-controlHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //按钮控制View
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-controlHeight, frame.size.width, controlHeight)];
    _controlView.backgroundColor = [FMColor getInstance].mainBackground;
    
    
    CGFloat btnHeight = [FMSize getInstance].selectListItemHeight;;
    CGFloat sepHeight = (controlHeight - btnHeight)/2;
    CGFloat btnWidth = (_controlView.frame.size.width - sepHeight*3)/2;
    originY = sepHeight;
    originX = sepHeight;
    
    
    //取消按钮
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, btnWidth, btnHeight)];
    [_cancelBtn addTarget:self action:@selector(onResetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_reset" inTable:nil] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[FMColor getInstance].mainWhite forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
    _cancelBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
    [_cancelBtn grayStyle];
    _cancelBtn.layer.cornerRadius = 3;
    _cancelBtn.layer.masksToBounds = YES;
    
    
    //确定按钮
    _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX + sepHeight + btnWidth, originY, btnWidth, btnHeight)];
    [_doneBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[FMColor getInstance].mainWhite forState:UIControlStateNormal];
    [_doneBtn setBackgroundColor:[UIColor colorWithRed:97/255.0 green:184/255.0 blue:41/255.0 alpha:1]];
    [_doneBtn successStyle];
    _doneBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
    _doneBtn.layer.cornerRadius = 3;
    _doneBtn.layer.masksToBounds = YES;
    [_doneBtn addTarget:self action:@selector(onOkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_controlView addSubview:_cancelBtn];
    [_controlView addSubview:_doneBtn];
    
    _mainContainerView.backgroundColor = [FMColor getInstance].mainOrange;
    
    [_mainContainerView addSubview:_tableView];
    [_mainContainerView addSubview:_controlView];
    
    [self.view addSubview:_mainContainerView];
}

- (NSInteger) getSectionCount {
    return 2;
}

- (ContractQueryFilterSectionType) getSectionTypeOfSection:(NSInteger) section {
    ContractQueryFilterSectionType sectionType = CONTRACT_FILTER_SECTION_UNKNOW;
    switch(section) {
        case 0:
            sectionType = CONTRACT_FILTER_SECTION_CODE;
            break;
        case 1:
            sectionType = CONTRACT_FILTER_SECTION_STATUS;
            break;
    }
    return sectionType;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self getSectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    ContractQueryFilterSectionType sectionType = [self getSectionTypeOfSection:section];
    switch (sectionType) {
        case CONTRACT_FILTER_SECTION_CODE:
            count = 1;
            break;
        case CONTRACT_FILTER_SECTION_STATUS:
            count = [_statusArray count] + 1;    //多了一个"不限"
            break;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    ContractQueryFilterSectionType sectionType = [self getSectionTypeOfSection:section];
    switch (sectionType) {
        case CONTRACT_FILTER_SECTION_CODE:
            itemHeight = [FMSize getInstance].selectListItemHeight;
            break;
        case CONTRACT_FILTER_SECTION_STATUS:
            //获取状态的名称
            if (position == 0) {
                itemHeight = [FMSize getInstance].selectListItemHeight;
            } else {
                itemHeight = [FMSize getInstance].selectListItemHeight;
            }
            break;
    }
    return itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    static NSString * cellIdentifier = @"Cell";
    ContractQueryFilterSectionType sectionType = [self getSectionTypeOfSection:section];
    BOOL isExist = NO;
    FilterSelectView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat padding = [FMSize getInstance].listePadding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat itemHeight = 0;
    NSString * title = nil;
    switch (sectionType) {
        case CONTRACT_FILTER_SECTION_CODE:
            cellIdentifier = @"CellCode";
            itemHeight = [FMSize getInstance].selectListItemHeight;
            break;
        case CONTRACT_FILTER_SECTION_STATUS: {
            //获取状态的名称
            if (position == 0) {
                title = [[BaseBundle getInstance] getStringByKey:@"filter_no_limits" inTable:nil];
                itemHeight = [FMSize getInstance].selectListItemHeight;
            } else {
                NSNumber *nstatus = _statusArray[position-1];
                ContractStatusType status = (ContractStatusType)nstatus.integerValue;
                title = [ContractServerConfig getStatusDesc:status];
//                if (status == CONTRACT_STATUS_VERFIED_YES) {
//                    title = NSLocalizedString(@"contract_status_verfied", nil);
//                }
                itemHeight = [FMSize getInstance].selectListItemHeight;
            }
            break;
        }
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    switch(sectionType) {
        case CONTRACT_FILTER_SECTION_CODE:
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (cell && !_codeTF) {
                _codeTF = [[UITextField alloc] initWithFrame:CGRectMake(padding, 0, width-padding, itemHeight)];
                _codeTF.font = [FMFont getInstance].font38;
                _codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
                _codeTF.textColor = [FMColor getInstance].mainText;
                _codeTF.placeholder = [[BaseBundle getInstance] getStringByKey:@"contract_filter_header_title_code_placeholder" inTable:nil];
                [cell addSubview:_codeTF];
                
                SeperatorView * seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                [cell addSubview:seperator];
            }
            break;
            
        case CONTRACT_FILTER_SECTION_STATUS:
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[FilterSelectView class]]) {
                        itemView = view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !itemView) {
                itemView = [[FilterSelectView alloc] init];
                [cell addSubview:itemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                if (position == _statusArray.count) {
                    [seperator setDotted:NO];
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                } else {
                    [seperator setDotted:YES];
                    [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
                }  //最后一条分割线设为全长
            }
            if (itemView) {
                [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                [itemView setTitleInfoWith:title];
                for (NSIndexPath * index in _selectedArray) {
                    if ([index isEqual:indexPath]) {
                        isExist = YES;
                    }
                }
                [itemView setChecked:isExist];
            }
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = [FMSize getInstance].selectHeaderHeight;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ContractQueryFilterSectionType sectionType = [self getSectionTypeOfSection:section];
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 52)];
    titleView.backgroundColor = [FMColor getInstance].mainBackground;
    
    UILabel * titleLbl = [[UILabel alloc] init];
    CGFloat padding = [FMSize getInstance].padding50;
    
    titleLbl.font = [FMFont getInstance].font42;
    titleLbl.textColor = [FMColor getInstance].grayLevel4;
    [titleLbl setFrame:CGRectMake(padding, [FMSize getInstance].padding70, 80, 19)];
    switch (sectionType) {
        case CONTRACT_FILTER_SECTION_CODE:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_filter_header_title_code" inTable:nil];
            break;
        case CONTRACT_FILTER_SECTION_STATUS:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_filter_header_title_status" inTable:nil];
            break;
        default:
            break;
    }
    
    [titleView addSubview:titleLbl];
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01f;
    return height;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    BOOL isExist = NO;
    NSIndexPath *tmpIndex;
    ContractQueryFilterSectionType sectionType = [self getSectionTypeOfSection:section];
    switch(sectionType) {
        case CONTRACT_FILTER_SECTION_CODE:
            break;
            
        case CONTRACT_FILTER_SECTION_STATUS:
            if (position == 0) {
                [_selectedArray removeAllObjects];
            } else {
                for (NSIndexPath *index in _selectedArray) {
                    if (indexPath.row == index.row) {
                        isExist = YES;
                        tmpIndex = index;
                        break;
                    }
                }
                if (isExist) {
                    [_selectedArray removeObject:tmpIndex];
                } else {
                    [_selectedArray addObject:indexPath];
                }
            }
            [_tableView reloadData];
            break;
        
        default:
            break;
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) handleResult {
    if(_handler) {
        ContractQueryCondition *filter = [[ContractQueryCondition alloc] init];
        
        NSString *tmpStr = _codeTF.text;
        if(![FMUtils isStringEmpty:tmpStr]) {
            filter.code = [tmpStr copy];
        }
        
        for (NSIndexPath *result in _selectedArray) {
            if (result) {
                switch (result.row) {
                    case 1:
                        [filter.status addObject:[NSNumber numberWithInteger:0]];  //未开始
                        break;
                    case 2:
                        [filter.status addObject:[NSNumber numberWithInteger:1]];  //执行中
                        break;
                    case 3:
                        [filter.status addObject:[NSNumber numberWithInteger:2]];  //已到期
                        break;
                        
                    case 4:
                        [filter.opStatus addObject:[NSNumber numberWithInteger:0]];  //验收不通过
                        break;
                    case 5:
                        [filter.opStatus addObject:[NSNumber numberWithInteger:1]];  //验收通过
                        break;
                    case 6:
                        [filter.opStatus addObject:[NSNumber numberWithInteger:2]];  //已终止
                        break;
                    case 7:
                        [filter.opStatus addObject:[NSNumber numberWithInteger:3]];  //已存档
                        break;
                        
                    default:
                        break;
                }
            }
        }
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:filter forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

- (void) onResetBtnClick {
    [_codeTF setText:@""];
    [_selectedArray removeAllObjects];
    [_tableView reloadData];
}

- (void) onOkBtnClick {
    [self handleResult];
    [self.frostedViewController hideMenuViewController];
}

@end
