//
//  ContractDetailTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "ContractDetailTableView.h"
#import "FMUtilsPackages.h"
#import "ContractBaseInfoTableViewCell.h"
#import "ContractRecordTableViewCell.h"
#import "MarkedListHeaderView.h"
#import "ContractEquipmentTableViewCell.h"
#import "ContractShowMoreTableViewCell.h"
#import "BaseBundle.h"

typedef NS_ENUM(NSInteger, ContractSectionType) {
    CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO,
    CONTRACT_DETTAIL_SECTION_TYPE_RECORD,
    CONTRACT_DETTAIL_SECTION_TYPE_EQUIPMENT
};

static NSString *cellBaseInfoIdentifier = @"cellBaseInfoIdentifier";
static NSString *cellRecordIdentifier = @"cellRecordIdentifier";
static NSString *cellEquipmentIdentifier = @"cellEquipmentIdentifier";
static NSString *cellShowMoreIdentifier = @"cellShowMoreIdentifier";
static NSString *cellFooterIdentifier = @"cellFooterIdentifier";

@interface ContractDetailTableView ()<UITableViewDelegate,UITableViewDataSource,OnClickListener>
@property (nonatomic, strong) ContractDetailEntity *contractDetail;
@property (nonatomic, strong) NSMutableArray *equipmentArray;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) BOOL isExpand;
@end

@implementation ContractDetailTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _headerHeight = [FMSize getInstance].listHeaderHeight;
        _footerHeight = [FMSize getInstance].listFooterHeight;
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        self.delaysContentTouches = NO;
        
        [self registerClass:[ContractBaseInfoTableViewCell class] forCellReuseIdentifier:cellBaseInfoIdentifier];
        [self registerClass:[ContractRecordTableViewCell class] forCellReuseIdentifier:cellRecordIdentifier];
        [self registerClass:[ContractEquipmentTableViewCell class] forCellReuseIdentifier:cellEquipmentIdentifier];
        [self registerClass:[ContractShowMoreTableViewCell class] forCellReuseIdentifier:cellShowMoreIdentifier];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellFooterIdentifier];
    }
    return self;
}

- (void)setContractDetail:(ContractDetailEntity *)contractDetail {
    _contractDetail = contractDetail;
    [self reloadData];
//    [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setEquipmentDataArray:(NSMutableArray *)equipmentDataArray {
    _equipmentArray = [equipmentDataArray mutableCopy];
    [self reloadData];
//    if (self.numberOfSections == 2) {
//        [self insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } else {
//        [self reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (ContractSectionType)getSectionTypeBySection:(NSInteger)section {
    ContractSectionType sectionType = CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO;
    switch (section) {
        case 0:
            sectionType = CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO;
            break;
            
        case 1:
            sectionType = CONTRACT_DETTAIL_SECTION_TYPE_RECORD;
            break;
        
        case 2:
            sectionType = CONTRACT_DETTAIL_SECTION_TYPE_EQUIPMENT;
            break;
    }
    return sectionType;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 2;
    if (_equipmentArray.count > 0) {
        count += 1;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    ContractSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO:
            count = 1 + 1; //+1 footer
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_RECORD:
            if (_contractDetail.history.count == 0) {
                count = 1; //+1 footer
            } else if (_contractDetail.history.count == 1) {
                count = 1 + 1; //+1 footer
            } else if (_contractDetail.history.count > 1) {
                count = 2 + 1; //+1 footer
            }
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_EQUIPMENT:
            if (_equipmentArray.count == 1) {
                count = 1;
            } else if (_equipmentArray.count > 1) {
                count = 2;
            }
            break;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height  = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    ContractSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO:
            if (position == 0) {
                height = [ContractBaseInfoTableViewCell calculateHeightByExpand:_isExpand andContractDetail:_contractDetail];
            } else if (position == 1) {
                height = _footerHeight;
            }
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_RECORD: {
            if (_contractDetail.history.count == 0 && position == 0) {
                height = _footerHeight;
            } else if (_contractDetail.history.count > 0 && position == 0) {
                NSInteger count = _contractDetail.history.count;
                ContractOperationRecord *record = _contractDetail.history[count-1]; //显示最后一条记录
                height = [ContractRecordTableViewCell calculateHeightByDesc:record.operation andAttachmentCount:record.attachment.count];
            } else if (_contractDetail.history.count == 1 && position == 1) {
                height = _footerHeight;
            } else if (_contractDetail.history.count > 1 && position == 1) {
                height = [ContractShowMoreTableViewCell getItemHeight];
            } else if (_contractDetail.history.count > 1 && position == 2) {
                height = _footerHeight;
            }
        }
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_EQUIPMENT:
            if (position == 0) {
                height = [ContractEquipmentTableViewCell getItemHeight];;
            } else if (position == 1) {
                height = [ContractShowMoreTableViewCell getItemHeight];
            }
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    UITableViewCell *cell = nil;
    
    ContractSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO:
            if (position == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (position == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellFooterIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            }
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_RECORD:
            if (_contractDetail.history.count == 0 && position == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellFooterIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            } else if (_contractDetail.history.count > 0 && position == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellRecordIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (_contractDetail.history.count == 1 && position == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellFooterIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            } else if (_contractDetail.history.count > 1 && position == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellShowMoreIdentifier];
            } else if (_contractDetail.history.count > 1 && position == 2) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellFooterIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            }
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_EQUIPMENT:
            if (position == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellEquipmentIdentifier];
            } else if (position == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellShowMoreIdentifier];
            }
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    ContractSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO:
            if (cell && [cell isKindOfClass:[ContractBaseInfoTableViewCell class]]) {
                ContractBaseInfoTableViewCell *custCell = (ContractBaseInfoTableViewCell *)cell;
                custCell.actionBlock = ^(ContractBaseInfoActionType type, id object){
                    if (type == CONTRACT_BASEINFO_ACTION_TYPE_ATTACHMENT) {
                        _actionBlock(CONTRACT_DETAIL_ACTION_ATTACHMENT, object);
                    } else if (type == CONTRACT_BASEINFO_ACTION_TYPE_PHONE) {
                        _actionBlock(CONTRACT_DETAIL_ACTION_PHONE, object);
                    }
                };
                [custCell setExpand:_isExpand];
                [custCell setContractDetail:_contractDetail];
            }
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_RECORD:
            if (cell && [cell isKindOfClass:[ContractRecordTableViewCell class]]) {
                ContractRecordTableViewCell *custCell = (ContractRecordTableViewCell *)cell;
                __weak typeof(self) weakSelf = self;
                custCell.actionBlock = ^(id object){
                    weakSelf.actionBlock(CONTRACT_DETAIL_ACTION_HISTORY_ATTACHMENT, object);
                };
                NSInteger count = _contractDetail.history.count;
                ContractOperationRecord *record = _contractDetail.history[count-1]; //显示最后一条记录
                if (_contractDetail.history.count > 1) {
                    [custCell setSeperatorGapped:YES];
                }
                [custCell setPortraitWithImageId:record.photoId];
                [custCell setInfoWithName:record.handler
                                     desc:record.operation
                                     time:record.time
                                   status:record.type
                               attachment:record.attachment];
            }
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_EQUIPMENT:
            if (cell && [cell isKindOfClass:[ContractEquipmentTableViewCell class]]) {
                ContractEquipment *equipment = _equipmentArray[0];
                ContractEquipmentTableViewCell *custCell = (ContractEquipmentTableViewCell *)cell;
                if (_equipmentArray.count > 0) {
                    [custCell setSeperatorGapped:YES];
                }
                [custCell setEquipmentCode:equipment.code];
                [custCell setEquipmentName:equipment.name];
                [custCell setEquipmentLocation:equipment.location];
            }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat width = CGRectGetWidth(tableView.frame);
    MarkedListHeaderView * headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    UIView *res = headerView;
    
    ContractSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO:
            headerView.tag = CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO;
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"contract_detail_header_title_profile" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            if (_isExpand) {
                [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_up"]];
            } else {
                [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_down"]];
            }
            [headerView setOnClickListener:self];
            [headerView setRightImgWidth:[FMSize getInstance].imgWidthLevel3];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_RECORD:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"contract_detail_header_title_record" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_EQUIPMENT:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"contract_detail_header_title_equipment" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
    }
    
    return res;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    ContractSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO:
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_RECORD:
            if (_contractDetail.history.count > 0 && position == 0) {
                //记录只能查看，不能点击
            } else if (_contractDetail.history.count > 1 && position == 1) {
                //展示更多
                _actionBlock(CONTRACT_DETAIL_ACTION_HISTORY_MORE, nil);
            }
            break;
            
        case CONTRACT_DETTAIL_SECTION_TYPE_EQUIPMENT:
            if (position == 0) {
                //展示指定设备
                ContractEquipment *equipment = _equipmentArray[0];
                _actionBlock(CONTRACT_DETAIL_ACTION_EQUIPMENT, equipment);
            } else if (position == 1) {
                //展示更多设备
                _actionBlock(CONTRACT_DETAIL_ACTION_EQUIPMENT_MORE, nil);
            }
            break;
    }
}

- (void)onClick:(UIView *)view {
    if ([view isKindOfClass:[MarkedListHeaderView class]]) {
        if (view.tag == CONTRACT_DETTAIL_SECTION_TYPE_BASEINFO) {
            _isExpand = !_isExpand;
            [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end


