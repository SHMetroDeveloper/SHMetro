//
//  MessageTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/8/15.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "MessageTableView.h"
#import "FMUtilsPackages.h"
#import "NotificationEntity.h"
#import "FMTheme.h"
#import "SeperatorView.h"
#import "BaseItemView.h"
#import "NotificationServerConfig.h"
#import "BaseBundle.h"


static const NSInteger MAX_DATA_COUNT = 2;  //每项数据显示的最多的条数

typedef NS_ENUM(NSInteger, MessageTableSectionType) {
    MESSAGE_TABLE_SECTION_TYPE_UNKNOW = 0,
    MESSAGE_TABLE_SECTION_TYPE_ORDER = 1,   //工单
    MESSAGE_TABLE_SECTION_TYPE_PATROL = 2,  //巡检
    MESSAGE_TABLE_SECTION_TYPE_MAINTENANCE = 3, //计划性维护
    MESSAGE_TABLE_SECTION_TYPE_ASSET = 4,   //资产
    MESSAGE_TABLE_SECTION_TYPE_REQUIREMENT = 5,   //需求
    MESSAGE_TABLE_SECTION_TYPE_INVENTORY = 6,   //库存
    MESSAGE_TABLE_SECTION_TYPE_CONTRACT = 7,   //合同
    MESSAGE_TABLE_SECTION_TYPE_BULLETIN = 100,   //公告
};

//@interface MessageTableView()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>
@interface MessageTableView()<UITableViewDelegate,UITableViewDataSource>
@property (readwrite, nonatomic, strong) NSMutableArray * orderMsgArray;    //工单数组
@property (readwrite, nonatomic, strong) NSMutableArray * patrolMsgArray;   //巡检数组
@property (readwrite, nonatomic, strong) NSMutableArray * maintenanceMsgArray;  //ppm数组
@property (readwrite, nonatomic, strong) NSMutableArray * assetMsgArray;    //资产数组
@property (readwrite, nonatomic, strong) NSMutableArray * requirementMsgArray;    //需求数组
@property (readwrite, nonatomic, strong) NSMutableArray * inventoryMsgArray;    //库存数组
@property (readwrite, nonatomic, strong) NSMutableArray * contractMsgArray;    //合同数组
@property (readwrite, nonatomic, strong) NSMutableArray * bulletinMsgArray;    //公告数组

@property (readwrite, nonatomic, assign) CGFloat footerHeight;
@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat logoWidth;

@property (readwrite, nonatomic, assign) BOOL showHeader;
@property (readwrite, nonatomic, assign) BOOL editable;
@end

@implementation MessageTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        self.delaysContentTouches = NO;
        self.delegate = self;
        self.dataSource = self;
        
        _footerHeight = [FMSize getInstance].listFooterHeight;
        _headerHeight = [FMSize getInstance].listHeaderHeight;
        _logoWidth = [FMSize getInstance].msgPaddingLeft;
        _showHeader = YES;
        _editable = YES;
    }
    return self;
}

- (void) setOrderMsgArray:(NSMutableArray *)orderMsgArray {
    _orderMsgArray = orderMsgArray;
}

- (void) setPatrolMsgArray:(NSMutableArray *)patrolMsgArray {
    _patrolMsgArray = patrolMsgArray;
}

- (void) setMaintenanceMsgArray:(NSMutableArray *)maintenanceMsgArray {
    _maintenanceMsgArray = maintenanceMsgArray;
}
- (void) setRequirementMsgArray:(NSMutableArray *) msgArray {
    _requirementMsgArray = msgArray;
}
- (void) setInventoryMsgArray:(NSMutableArray *) msgArray {
    _inventoryMsgArray = msgArray;
}

- (void) setAssetMsgArray:(NSMutableArray *) assetMsgArray {
    _assetMsgArray = assetMsgArray;
}

- (void) setContractMsgArray:(NSMutableArray *) msgArray {
    _contractMsgArray = msgArray;
}

- (void) setBulletinMsgArray:(NSMutableArray *) msgArray {
    _bulletinMsgArray = msgArray;
}

- (void) setShowHeader:(BOOL) show {
    _showHeader = show;
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
}

- (NSInteger) getSectionCount {
    NSInteger count = 0;
    if([_orderMsgArray count] > 0) {
        count += 1;
    }
    if([_patrolMsgArray count] > 0) {
        count += 1;
    }
    if([_maintenanceMsgArray count] > 0) {
        count += 1;
    }
    if([_assetMsgArray count] > 0) {
        count += 1;
    }
    if([_requirementMsgArray count] > 0) {
        count += 1;
    }
    if([_inventoryMsgArray count] > 0) {
        count += 1;
    }
    if([_contractMsgArray count] > 0) {
        count += 1;
    }
    if ([_bulletinMsgArray count] > 0) {
        count += 1;
    }
    return count;
}

- (MessageTableSectionType) getSectionTypeBySection:(NSInteger) section {
    MessageTableSectionType type = MESSAGE_TABLE_SECTION_TYPE_UNKNOW;
    if([_orderMsgArray count] == 0){
        section += 1;
    }
    if([_patrolMsgArray count] == 0 && section >= 1) {
        section += 1;
    }
    if([_maintenanceMsgArray count] == 0 && section >= 2) {
        section += 1;
    }
    if([_assetMsgArray count] == 0 && section >= 3) {
        section += 1;
    }
    if([_requirementMsgArray count] == 0 && section >= 4) {
        section += 1;
    }
    if([_inventoryMsgArray count] == 0 && section >= 5) {
        section += 1;
    }
    if([_contractMsgArray count] == 0 && section >= 6) {
        section += 1;
    }
    if ([_bulletinMsgArray count] == 0 && section >= 7) {
        section += 1;
    }
    switch (section) {
        case 0:
            type = MESSAGE_TABLE_SECTION_TYPE_ORDER;
            break;
        case 1:
            type = MESSAGE_TABLE_SECTION_TYPE_PATROL;
            break;
        case 2:
            type = MESSAGE_TABLE_SECTION_TYPE_MAINTENANCE;
            break;
        case 3:
            type = MESSAGE_TABLE_SECTION_TYPE_ASSET;
            break;
        case 4:
            type = MESSAGE_TABLE_SECTION_TYPE_REQUIREMENT;
            break;
        case 5:
            type = MESSAGE_TABLE_SECTION_TYPE_INVENTORY;
            break;
        case 6:
            type = MESSAGE_TABLE_SECTION_TYPE_CONTRACT;
            break;
        case 7:
            type = MESSAGE_TABLE_SECTION_TYPE_BULLETIN;
            break;
        default:
            break;
    }
    return type;
}

- (NotificationEntity *) getDataBySection:(NSInteger) section position:(NSInteger) position {
    NotificationEntity * data = nil;
    MessageTableSectionType type = [self getSectionTypeBySection:section];
    switch (type) {
        case MESSAGE_TABLE_SECTION_TYPE_ORDER:
            if(position >= 0 && position < [_orderMsgArray count]) {
                data = _orderMsgArray[position];
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_PATROL:
            if(position >= 0 && position < [_patrolMsgArray count]) {
                data = _patrolMsgArray[position];
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_MAINTENANCE:
            if(position >= 0 && position < [_maintenanceMsgArray count]) {
                data = _maintenanceMsgArray[position];
            }
            break;
            
        case MESSAGE_TABLE_SECTION_TYPE_ASSET:
            if(position >= 0 && position < [_assetMsgArray count]) {
                data = _assetMsgArray[position];
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_REQUIREMENT:
            if(position >= 0 && position < [_requirementMsgArray count]) {
                data = _requirementMsgArray[position];
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_INVENTORY:
            if(position >= 0 && position < [_inventoryMsgArray count]) {
                data = _inventoryMsgArray[position];
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_CONTRACT:
            if(position >= 0 && position < [_contractMsgArray count]) {
                data = _contractMsgArray[position];
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_BULLETIN:
            if(position >= 0 && position < [_bulletinMsgArray count]) {
                data = _bulletinMsgArray[position];
            }
            break;
        default:
            break;
    }
    if(_showHeader && MAX_DATA_COUNT > 0 && position >= MAX_DATA_COUNT) {
        data = nil;
    }
    return data;
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [self getSectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    MessageTableSectionType type = [self getSectionTypeBySection:section];
    switch (type) {
        case MESSAGE_TABLE_SECTION_TYPE_ORDER:
            count = [_orderMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_PATROL:
            count = [_patrolMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_MAINTENANCE:
            count = [_maintenanceMsgArray count];
            break;
            
        case MESSAGE_TABLE_SECTION_TYPE_ASSET:
            count = [_assetMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_REQUIREMENT:
            count = [_requirementMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_INVENTORY:
            count = [_inventoryMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_CONTRACT:
            count = [_contractMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_BULLETIN:
            count = [_bulletinMsgArray count];
            break;
        default:
            break;
    }
    if(_showHeader) {
        if(count > MAX_DATA_COUNT) {
            count = MAX_DATA_COUNT;
        }
        if(count > 0) {
            count += 1;  //留给FooterSeperator
        }
    }

    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    NotificationEntity *entity = [self getDataBySection:section position:position];

    MessageTableSectionType type = [self getSectionTypeBySection:section];
    BOOL isFooter = YES;
    switch (type) {
        case MESSAGE_TABLE_SECTION_TYPE_ORDER:
            if(position >= 0 && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT)) && position < [_orderMsgArray count]) {
                isFooter = NO;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_PATROL:
            if(position >= 0 && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT)) && position < [_patrolMsgArray count]) {
                isFooter = NO;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_MAINTENANCE:
            if(position >= 0 && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT)) && position < [_maintenanceMsgArray count]) {
                isFooter = NO;
            }
            break;
            
        case MESSAGE_TABLE_SECTION_TYPE_ASSET:
            if(position >= 0 && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT)) && position < [_assetMsgArray count]) {
                isFooter = NO;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_REQUIREMENT:
            if(position >= 0 && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT)) && position < [_requirementMsgArray count]) {
                isFooter = NO;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_INVENTORY:
            if(position >= 0 && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT)) && position < [_inventoryMsgArray count]) {
                isFooter = NO;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_CONTRACT:
            if(position >= 0 && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT)) && position < [_contractMsgArray count]) {
                isFooter = NO;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_BULLETIN:
            if(position >= 0 && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT)) && position < [_bulletinMsgArray count]) {
                isFooter = NO;
            }
            break;
        default:
            break;
    }
    if(isFooter) {
        itemHeight = _footerHeight;
    } else {
        if(entity) {
            itemHeight = entity.itemHeight;
        }
    }
    return itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    BOOL isFooter = YES;
    NSInteger count = 0;
    NotificationEntity *entity = [self getDataBySection:section position:position];
    MessageTableSectionType type = [self getSectionTypeBySection:section];
    
    static NSString *cellIdentifier = @"Cell";
    FMMessageTableViewCell *cell = nil;
    switch (type) {
        case MESSAGE_TABLE_SECTION_TYPE_ORDER:
            if(position >= 0 && position < [_orderMsgArray count] && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT))) {
                isFooter = NO;
            }
            count = [_orderMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_PATROL:
            if(position >= 0 && position < [_patrolMsgArray count] && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT))) {
                isFooter = NO;
            }
            count = [_patrolMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_MAINTENANCE:
            if(position >= 0 && position < [_maintenanceMsgArray count] && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT))) {
                isFooter = NO;
            }
            count = [_maintenanceMsgArray count];
            break;
            
        case MESSAGE_TABLE_SECTION_TYPE_ASSET:
            if(position >= 0 && position < [_assetMsgArray count] && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT))) {
                isFooter = NO;
            }
            count = [_assetMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_REQUIREMENT:
            if(position >= 0 && position < [_requirementMsgArray count] && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT))) {
                isFooter = NO;
            }
            count = [_requirementMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_INVENTORY:
            if(position >= 0 && position < [_inventoryMsgArray count] && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT))) {
                isFooter = NO;
            }
            count = [_inventoryMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_CONTRACT:
            if(position >= 0 && position < [_contractMsgArray count] && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT))) {
                isFooter = NO;
            }
            count = [_contractMsgArray count];
            break;
        case MESSAGE_TABLE_SECTION_TYPE_BULLETIN:
            if(position >= 0 && position < [_bulletinMsgArray count] && (!_showHeader || (MAX_DATA_COUNT <= 0 || position < MAX_DATA_COUNT))) {
                isFooter = NO;
            }
            count = [_bulletinMsgArray count];
            break;
        default:
            break;
    }
    if(_showHeader && MAX_DATA_COUNT > 0 && count > MAX_DATA_COUNT) {
        count = MAX_DATA_COUNT;
    }
    if(isFooter) {
        cellIdentifier = @"CellFooter";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell) {
            cell = [[FMMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:cellIdentifier];
            
        }
        cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    } else {
        cellIdentifier = @"CellMessage";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[FMMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuse:cellIdentifier];
        }
        if (cell) {
            if(_showHeader) {
                [cell setShowType:NO paddingLeft:_logoWidth];
            } else {
                [cell setShowType:NO paddingLeft:[FMSize getInstance].defaultPadding];
            }
            if(position == count - 1) {
                [cell setSeperatorBroad:YES];
            } else {
                [cell setSeperatorBroad:NO];
            }
            [cell setInfoWithTitle:entity.title
                           content:entity.content
                              time:entity.time
                              type:entity.type
                            status:entity.woStatus
                              read:entity.read];
        }
    }
    return cell;
}

#pragma mark - TableView HeaderView
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if(_showHeader) {
        MessageTableSectionType type = [self getSectionTypeBySection:section];
        switch (type) {
            case MESSAGE_TABLE_SECTION_TYPE_ORDER:
                if([_orderMsgArray count] > 0) {
                    height = _headerHeight;
                }
                break;
            case MESSAGE_TABLE_SECTION_TYPE_PATROL:
                if([_patrolMsgArray count] > 0) {
                    height = _headerHeight;
                }
                break;
            case MESSAGE_TABLE_SECTION_TYPE_MAINTENANCE:
                if([_maintenanceMsgArray count] > 0) {
                    height = _headerHeight;
                }
                break;
            case MESSAGE_TABLE_SECTION_TYPE_ASSET:
                if([_assetMsgArray count] > 0) {
                    height = _headerHeight;
                }
                break;
            case MESSAGE_TABLE_SECTION_TYPE_REQUIREMENT:
                if([_requirementMsgArray count] > 0) {
                    height = _headerHeight;
                }
                break;
            case MESSAGE_TABLE_SECTION_TYPE_INVENTORY:
                if([_inventoryMsgArray count] > 0) {
                    height = _headerHeight;
                }
                break;
            case MESSAGE_TABLE_SECTION_TYPE_CONTRACT:
                if([_contractMsgArray count] > 0) {
                    height = _headerHeight;
                }
            case MESSAGE_TABLE_SECTION_TYPE_BULLETIN:
                if([_bulletinMsgArray count] > 0) {
                    height = _headerHeight;
                }
                break;
            default:
                break;
        }
    }
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view;
    BaseItemView * headerView;
    CGFloat paddingLeft = 12;
    CGFloat paddingRight = 13;
    CGFloat width = CGRectGetWidth(tableView.frame);
    headerView = [[BaseItemView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [headerView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L1]];
    [headerView setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L4]];
    [headerView setShowMore:YES];
    [headerView setPaddingLeft:paddingLeft];
    [headerView setPaddingRight:paddingRight];
    [headerView setLogoImageWidth:17];
    [headerView setLeftWidth:[FMSize getInstance].msgPaddingLeft];
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    SeperatorView * seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(_logoWidth, _headerHeight-seperatorHeight, width-_logoWidth, seperatorHeight)];
    [headerView addSubview:seperator];
    [headerView addTarget:self action:@selector(onHeaderViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    MessageTableSectionType type = [self getSectionTypeBySection:section];
    switch (type) {
        case MESSAGE_TABLE_SECTION_TYPE_ORDER:
            if([_orderMsgArray count] > 0) {
                [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_order" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"msg_order"] andDesc:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_more" inTable:nil]];
                view = headerView;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_PATROL:
            if([_patrolMsgArray count] > 0) {
                [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_patrol" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"msg_patrol"] andDesc:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_more" inTable:nil]];
                [headerView setShowMore:YES];
                view = headerView;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_MAINTENANCE:
            if([_maintenanceMsgArray count] > 0) {
                [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"maintenance_message_title" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"msg_maintenance"] andDesc:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_more" inTable:nil]];
                [headerView setShowMore:YES];
                view = headerView;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_ASSET:
            if([_assetMsgArray count] > 0) {
                [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_asset" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"msg_asset"] andDesc:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_more" inTable:nil]];
                [headerView setShowMore:YES];
                view = headerView;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_REQUIREMENT:
            if([_requirementMsgArray count] > 0) {
                [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_requirement" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"msg_requirement"] andDesc:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_more" inTable:nil]];
                [headerView setShowMore:YES];
                view = headerView;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_INVENTORY:
            if([_inventoryMsgArray count] > 0) {
                [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_inventory" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"msg_inventory"] andDesc:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_more" inTable:nil]];
                [headerView setShowMore:YES];
                view = headerView;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_CONTRACT:
            if([_contractMsgArray count] > 0) {
                [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_contract" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"msg_contract"] andDesc:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_more" inTable:nil]];
                [headerView setShowMore:YES];
                view = headerView;
            }
            break;
        case MESSAGE_TABLE_SECTION_TYPE_BULLETIN:
            if([_bulletinMsgArray count] > 0) {
                [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_notice" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"msg_bulletin"] andDesc:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_more" inTable:nil]];
                [headerView setShowMore:YES];
                view = headerView;
            }
            break;
            
        default:
            break;
    }
    view.tag = type;
    return view;
}

#pragma mark - TableView EditConfiguration
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    NotificationEntity *entity = [self getDataBySection:section position:position];
    NSMutableArray *rowAction = [NSMutableArray new];
    
    //标记已读未读
    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_readed" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        _editBlock(NOTIFICATION_EDIT_TYPE_READ, indexPath, entity);
    }];
    readAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
    
    //显示更多
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_more" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        _editBlock(NOTIFICATION_EDIT_TYPE_MORE, indexPath, entity);
    }];
    moreAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
    
    //删除此条
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_delete" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        _editBlock(NOTIFICATION_EDIT_TYPE_DELETE, indexPath, entity);
    }];
    deleteAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
    
    if (!_showHeader) {
        [rowAction addObject:moreAction];
    }
    [rowAction addObject:deleteAction];
    if (!entity.read) {
        [rowAction addObject:readAction];
    }
    
    return rowAction;
}

#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    NotificationEntity *entity = [self getDataBySection:section position:position];
    if(entity) {
        NotificationItemType type = entity.type;
        _actionBlock(entity,type);  //Action回调
    }

}

- (void) onHeaderViewClicked:(id) sender {
    UIButton *headerView = sender;
    NotificationItemType type = headerView.tag;
    _moreBlock(type);
}

@end
