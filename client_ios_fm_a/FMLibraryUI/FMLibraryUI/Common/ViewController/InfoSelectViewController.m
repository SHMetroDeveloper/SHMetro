//
//  InfoSelectViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "InfoSelectViewController.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "BaseTextField.h"
#import "NodeItemView.h"
#import "WorkOrderNetRequest.h"
#import "WorkOrderLaborerDispachEntity.h"
#import "SystemConfig.h"
#import "BaseDataEntity.h"
#import "BaseDataNetRequest.h"
#import "SeperatorView.h"
#import "BaseDataDbHelper.h"
#import "FMSize.h"
#import "FMFont.h"
#import "ReportServerConfig.h"
#import "WorkOrderApproverEntity.h"
#import "WarehouseEntity.h"
#import "MaterialEntity.h"
#import "InventoryBusiness.h"


@interface InfoSelectViewController ()
@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, strong) UITableView * pullTableView;
@property (readwrite, nonatomic, strong) BaseTextField * searchTf;


@property (readwrite, nonatomic, strong) UILabel * noticeLbl;

@property (readwrite, nonatomic, strong) NSMutableArray* nodesArray;


@property (readwrite, nonatomic, assign) CGFloat searchHeight;
@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) NodeList * nodes;
@property (readwrite, nonatomic, assign) BOOL hintVisiable;
@property (readwrite, nonatomic, strong) NSString * defaultHintText;

@property (readwrite, nonatomic, assign) NSInteger curNodeParentId;
@property (readwrite, nonatomic, assign) NSInteger curNodeLevel;

@property (readwrite, nonatomic, strong) NSString* strTitle;
@property (readwrite, nonatomic, assign) InfoSelectRequestType requestType; //请求类型
@property (readwrite, nonatomic, strong) NSDictionary* requestParam;        //请求参数
@property (readwrite, nonatomic, assign) InfoSelectResultType resultType;   //结果类型

@property (readwrite, nonatomic, strong) Positions* positionsList;
@property (readwrite, nonatomic, strong) NSMutableArray* orgList;       //
@property (readwrite, nonatomic, strong) NSMutableArray* stypeList;     //

@property (readwrite, nonatomic, strong) NSMutableArray* flowList;      //流程列表
@property (readwrite, nonatomic, strong) NSMutableArray* priorityList;  //相关优先级列表

@property (readwrite, nonatomic, strong) NSMutableArray* deviceList;  //

@property (readwrite, nonatomic, strong) NSMutableArray* requirementTypeList;  //需求类型列表

@property (readwrite, nonatomic, strong) NSMutableArray* wareHouseList;  //仓库列表
@property (readwrite, nonatomic, strong) NSMutableArray* materialList;  //物料列表

@property (readwrite, nonatomic, strong) NSMutableArray* workgroupList;  //工作组列表

@property (readwrite, nonatomic, strong) NSMutableArray *selectDataArray;  //已选数据

@property (readwrite, nonatomic, strong) NetPage * mPage;

@property (readwrite, nonatomic, strong) InventoryBusiness * inventoryBusiness;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end


@implementation InfoSelectViewController

- (instancetype) initWithRequestType:(InfoSelectRequestType) requestType {
    self = [super init];
    if(self) {
        _requestType = requestType;
    }
    return self;
}

- (instancetype) initWithRequestType:(InfoSelectRequestType) requestType andParam:(NSDictionary *) param {
    self = [super init];
    if(self) {
        _requestType = requestType;
        _requestParam = param;
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame andRequestType:(InfoSelectRequestType) requestType {
    self = [super initWithFrame:frame];
    if(self) {
        _requestType = requestType;
    }
    return self;
}

- (void) initNavigation {
    if(!_strTitle) {
        _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select" inTable:nil];
    }
    [self setTitleWith:[[NSString alloc] initWithFormat:@"%@", _strTitle]];
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) onMenuItemClicked:(NSInteger)position {
    [self selectCurrentNode];
    [self finish];
}

- (void) initData {
    _resultType = RESULT_TYPE_CANCEL_INFO_SELECT;
    _searchHeight = 40;
    _itemHeight = 50;
    _curNodeParentId = [NodeItem getParentIdOfRoot];
    _curNodeLevel = [NodeItem getParentLevelOfRoot];
    
    _inventoryBusiness = [InventoryBusiness getInstance];
    
    _nodesArray = [[NSMutableArray alloc] init];
    
    if (!_selectDataArray) {
        _selectDataArray = [NSMutableArray new];
    }
    
    _nodes = [[NodeList alloc] init];
    _mPage = [[NetPage alloc] init];
}

- (void) initViews {
    CGFloat originX = 10;
    CGFloat searchPaddingTop = 6;
    CGFloat originY = searchPaddingTop;
    
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat noticeHeight = [FMSize getInstance].defaultNoticeHeight;
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
//    _searchTf = [[BaseTextField alloc] initWithFrame:CGRectMake(originX, originY, width - originX*2, _searchHeight)];
//    
//
//    [_searchTf setLabelWithImage:[[FMTheme getInstance] getImageByName:@"search_gray"]];
//    [_searchTf addTarget:self action:@selector(onSearchFilterChanged) forControlEvents:UIControlEventEditingChanged];
//    _searchTf.delegate = self;
    
    _searchTf = [[BaseTextField alloc] initWithFrame:CGRectMake(originX, searchPaddingTop, width-originX*2, _searchHeight)];
    _searchTf.font = [FMFont getInstance].defaultFontLevel2;
    [_searchTf setLabelWithImage:[[FMTheme getInstance] getImageByName:@"search_gray"]];
    _searchTf.borderStyle = UITextBorderStyleNone;
    _searchTf.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    _searchTf.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
    _searchTf.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    _searchTf.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_searchTf addTarget:self action:@selector(onSearchFilterChanged) forControlEvents:UIControlEventEditingChanged];

    [_searchTf setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"filter_placeholder_common" inTable:nil]];

//    [_searchTf addTarget:self action:@selector(onSearchFilterChanged) forControlEvents:UIControlEventEditingChanged];
    
    _noticeLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, (height - noticeHeight)/2, (width-originX*2), noticeHeight)];
    _noticeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
    _noticeLbl.textAlignment = NSTextAlignmentCenter;
    _noticeLbl.text = [[BaseBundle getInstance] getStringByKey:@"select_no_data" inTable:nil];
    [_noticeLbl setFont:[FMFont fontWithSize:14]];
    
    CGRect listFrame = CGRectMake(0, originY * 2  + _searchHeight, width, height - originY*2-_searchHeight);
    
    _pullTableView = [[UITableView alloc] initWithFrame:listFrame];
    
    _pullTableView.dataSource = self;
    _pullTableView.delegate = self;
    _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    
    [_mainContainerView addSubview:_searchTf];
    [_mainContainerView addSubview:_pullTableView];
    [_mainContainerView addSubview:_noticeLbl];
    
    [self.view addSubview:_mainContainerView];
}

- (void) updateNotice {
    NSInteger count = [_nodes getCount];
    if(count > 0) {
        [_noticeLbl setHidden:YES];
    } else {
        [_noticeLbl setHidden:NO];
    }
}

- (void) updateList {
    if([self isSearchAble]) {
        NSString * strFilter = _searchTf.text;
        if([FMUtils isStringEmpty:strFilter]) {
            _nodesArray = [_nodes getChildren:_curNodeParentId level:_curNodeLevel];
            [_pullTableView reloadData];
        } else {
            _nodesArray = [_nodes getChildrenByFilter:_curNodeParentId filterType:FILTER_TYPE_NAME_OR_DESC_FIRST_LETTER filter:strFilter level:_curNodeLevel];
            [_pullTableView reloadData];
        }
        
    } else {
        _nodesArray = [_nodes getChildren:_curNodeParentId level:_curNodeLevel];
        [_pullTableView reloadData];
    }
    
    //title
    NSString * strTitle = nil;
    if(_curNodeParentId == [NodeItem getParentIdOfRoot]) {
        if(![FMUtils isStringEmpty:_nodes.desc]) {
            strTitle = _nodes.desc;
        } else {
            strTitle = _strTitle;
        }
        
    } else {
        NSInteger parentLevel = [_nodes getParentLevel:_curNodeLevel];
        strTitle = [[_nodes getNodeByKey:_curNodeParentId andLevel:parentLevel] getVal];
    }
    [self updateTitle:strTitle];
    [self updateNotice];
}

- (void) updateTitle:(NSString *) title {
    [self setTitleWith:title];
    [self updateNavigationBar];
}

- (void) showRoot {
    _curNodeParentId = [NodeItem getParentIdOfRoot];
    _curNodeLevel = [_nodes getRootLevel];
    [self updateList];
}

- (void) showParent {
    if(_curNodeParentId != [NodeItem getParentIdOfRoot]) {
        _curNodeLevel = [_nodes getParentLevel:_curNodeLevel];
        NodeItem * node = [_nodes getNodeByKey:_curNodeParentId andLevel:_curNodeLevel];
        if(node) {
            _curNodeParentId = [node getParentKey];
            [self updateList];
        }
    }
}

- (void) showChildren:(NSInteger) key {
    _curNodeParentId = key;
    _curNodeLevel = [_nodes getChildrenLevel:_curNodeLevel];
    if(_curNodeLevel == LEVEL_LEAF || [[_nodes getChildren:_curNodeParentId level:_curNodeLevel] count] == 0) {
        _resultType = RESULT_TYPE_OK_INFO_SELECT;
        [self selectCurrentNode];
        [self finish];
    } else {
        [self updateList];
    }
    
}

- (void) selectCurrentNode {
    NSInteger parentLevel = [_nodes getParentLevel:_curNodeLevel];
    NodeItem * node = [_nodes getNodeByKey:_curNodeParentId andLevel:parentLevel];
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [result setValue:@"InfoSelectViewController" forKeyPath:@"msgOrigin"];
    [result setValue:[NSNumber numberWithInteger:_requestType] forKeyPath:@"requestType"];
    [result setValue:[NSNumber numberWithInteger:_resultType] forKeyPath:@"resultType"];
    [result setValue:node forKeyPath:@"result"];
    
    Position * position = nil;  //位置
    Org * org = nil;            //部门
    
    ServiceType * stype = nil;  //服务类型
    NSNumber * orderType = nil;  //工单类型
    
    Priority * priority = nil;  //优先级
    Flow * flow;
    NSString * fullName;
    
    Device * device = nil;      //设备
    
    RequirementType * requirementType = nil;  //需求类型
    
    WarehouseEntity * warehouse;    //仓库
    MaterialEntity * material;      //物料
    
    
//    NSMutableArray * infoArray = [[NSMutableArray alloc] init];
    NSMutableDictionary * tmpInfo;
    
    switch (_requestType) {
        case REQUEST_TYPE_LOCATION_INFO_SELECT:
            position = [self getPositionInfoOfNode:node];
            [data setValue:position forKeyPath:@"position"];
            [data setValue:[self getPositionStr:position] forKeyPath:@"positionName"];
            [result setValue:data forKeyPath:@"result"];
            [self handleResult:result];
            
            break;
        case REQUEST_TYPE_ORG_INFO_SELECT:
            org = [self getOrgInfoOfNode:node];
            fullName = [self getFullNameOfOrg:org.orgId];
            
            [data setValue:org forKeyPath:@"org"];
            [data setValue:fullName forKeyPath:@"fullName"];
            
            [result setValue:data forKeyPath:@"result"];
            [self handleResult:result];
            
            break;
        case REQUEST_TYPE_SERVICE_TYPE_INFO_SELECT:
            stype = [self getStypeInfoOfNode:node];
            fullName = [self getFullNameOfServiceType:stype.serviceTypeId];
            
            [data setValue:stype forKeyPath:@"serviceType"];
            [data setValue:fullName forKeyPath:@"fullName"];
            
            [result setValue:data forKeyPath:@"result"];
            [self handleResult:result];
            
            break;
        case REQUEST_TYPE_ORDER_TYPE_INFO_SELECT:
            orderType = [self getOrderTypeInfoOfNode:node];
            [result setValue:orderType forKeyPath:@"result"];
            [self handleResult:result];
            
            break;
        case REQUEST_TYPE_PRIORITY_INFO_SELECT:
            priority = [self getPriorityInfoOfNode:node];
            flow = [self getFlowByPriority:priority];
            if(flow) {
                [data setValue:priority forKeyPath:@"priority"];
                [data setValue:flow.wopId forKeyPath:@"flowId"];
                [result setValue:data forKeyPath:@"result"];
                [self handleResult:result];
            }
            break;
        case REQUEST_TYPE_DEVICE_INFO_SELECT:
            device = [self getDeviceInfoOfNode:node];
            [result setValue:device forKeyPath:@"result"];
            [self handleResult:result];
            break;
        case REQUEST_TYPE_REQUIREMENT_TYPE_INFO_SELECT:
            requirementType = [self getRequirementTypeInfoOfNode:node];
            [result setValue:requirementType forKeyPath:@"result"];
            [self handleResult:result];
            break;
        case REQUEST_TYPE_WAREHOUSE_INFO_SELECT:
            warehouse = [self getWarehouseInfoOfNode:node];
            [result setValue:warehouse forKeyPath:@"result"];
            [self handleResult:result];
            break;
        case REQUEST_TYPE_MATERIAL_INFO_SELECT:
            material = [self getMaterialInfoOfNode:node];
            [result setValue:material forKeyPath:@"result"];
            [self handleResult:result];
            break;
        case REQUEST_TYPE_COMMON_INFO_SELECT:
            tmpInfo = [self getCommonInfoOfNode:node];
//            if(tmpInfo) {
//                [infoArray addObject:tmpInfo];
//            }
            [result setValue:tmpInfo forKeyPath:@"result"];
            [self handleResult:result];
            break;
        default:
            break;
    }
}



- (void) viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
    [self work];
}

- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
}

- (void) onBackButtonPressed {
    if(_curNodeParentId == [NodeItem getParentIdOfRoot]) {
        [self finish];
    } else {
        _searchTf.text = @"";
        [self showParent];
    }
}

//是否支持快速搜索
- (BOOL) isSearchAble {
    return YES;
}


- (void) work {
    [self showLoadingDialog];
    switch(_requestType) {
        case REQUEST_TYPE_LOCATION_INFO_SELECT:
            _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select_location" inTable:nil];
            [self requestLocationInfo];
            break;
        case REQUEST_TYPE_ORG_INFO_SELECT:
            _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select_department" inTable:nil];
            [self requestOrgInfo];
            break;
        case REQUEST_TYPE_SERVICE_TYPE_INFO_SELECT:
            _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select_service_type" inTable:nil];
            [self requestServiceTypeInfo];
            break;
        case REQUEST_TYPE_ORDER_TYPE_INFO_SELECT:
            _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select_order_type" inTable:nil];
            [self requestOrderTypeInfo];
            break;
        case REQUEST_TYPE_PRIORITY_INFO_SELECT:
            _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select_priority" inTable:nil];
            [self requestPriorityInfo];
            break;
        case REQUEST_TYPE_DEVICE_INFO_SELECT:
            _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select_equipment" inTable:nil];
            [self requestDeviceInfo];
            break;
        case REQUEST_TYPE_REQUIREMENT_TYPE_INFO_SELECT:
            _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select_requirement" inTable:nil];
            [self requestRequirementTypeInfo];
            break;
        case REQUEST_TYPE_WAREHOUSE_INFO_SELECT:
            _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select_inventory" inTable:nil];
            [self requestWareHouseInfo];
            break;
        case REQUEST_TYPE_MATERIAL_INFO_SELECT:
            _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select_title_material" inTable:nil];
            [self requestMaterialInfo];
            break;
        case REQUEST_TYPE_COMMON_INFO_SELECT:
            _strTitle = [_requestParam valueForKeyPath:@"desc"];
            if([FMUtils isStringEmpty:_strTitle]) {
                _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select" inTable:nil];
            }
            [self requestCommonInfo];
            break;
        default:
            [self hideLoadingDialog];
            break;
    }
    [self updateTitle:_strTitle];
}

- (void) setSelectDataByArray:(nullable NSMutableArray *) dataArray {
    if (!_selectDataArray) {
        _selectDataArray = [NSMutableArray new];
    }
    _selectDataArray = [NSMutableArray arrayWithArray:dataArray];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) handleResult:(id) result {
    if(_handler) {
        [_handler handleMessage:result];
    }
}

- (void) requestOrgInfo {
    BaseDataDbHelper * dbHelper = [BaseDataDbHelper getInstance];
    _orgList = [dbHelper queryAllOrgsOfCurrentProject];
    if(_orgList) {
        [self getOrgList:_orgList];
        [self showRoot];
    }
    [self hideLoadingDialog];
}

- (void) getOrgList:(NSMutableArray *) orgs {
    _nodes = [[NodeList alloc] init];
    NSInteger maxLevel = 0;
    for(Org * org in orgs) {
        NSInteger level = [[org.fullName componentsSeparatedByString:@"/"] count];
        if(maxLevel < level ) {
            maxLevel = level;
        }
        NodeItem * item = [[NodeItem alloc] initWith:[org.parentOrgId integerValue] key:[org.orgId integerValue] value:org.name level:level];
        [_nodes addNode:item];
    }
    for(NSInteger i=1;i<=maxLevel;i++) {
        if(i == 1) {
            [_nodes addNodeLevel:1];
        } else {
            [_nodes addNodeLevel:i parent:i-1];
        }
        
    }
    [_nodes setDesc:[[BaseBundle getInstance] getStringByKey:@"function_info_select_department" inTable:nil]];
    
}

- (NSString *) getFullNameOfOrg:(NSNumber *) orgId {
    NSString * res;
    if(orgId) {
        for(DBOrg * org in _orgList) {
            if([org.orgId isEqualToNumber:orgId]) {
                res = org.fullName;
                break;
            }
        }
    }
    
    return res;
}


- (void) requestServiceTypeInfo {
    BaseDataDbHelper * dbHelper = [BaseDataDbHelper getInstance];
    _stypeList = [dbHelper queryAllServiceTypeOfCurrentProject];
    if(_stypeList) {
        [self getServiceTypeList:_stypeList];
        [self showRoot];
    }
    [self hideLoadingDialog];
}

- (void) getServiceTypeList:(NSMutableArray *) stypes {
    _nodes = [[NodeList alloc] init];
    NSInteger maxLevel = 0;
    for(ServiceType * stype in stypes) {
        NSInteger level = [[stype.fullName componentsSeparatedByString:@"/"] count];
        if(maxLevel < level ) {
            maxLevel = level;
        }
        NodeItem * item = [[NodeItem alloc] initWith:[stype.parentId integerValue] key:[stype.serviceTypeId integerValue] value:stype.name level:level];
        [_nodes addNode:item];
    }
    for(NSInteger i=1;i<=maxLevel;i++) {
        if(i == 1) {
            [_nodes addNodeLevel:1];
        } else {
            [_nodes addNodeLevel:i parent:i-1];
        }
        
    }
    [_nodes setDesc:[[BaseBundle getInstance] getStringByKey:@"function_info_select_service_type" inTable:nil]];
    
}

- (NSString *) getFullNameOfServiceType:(NSNumber *) stypeId{
    NSString * res;
    if(stypeId) {
        for(ServiceType * stype in _stypeList) {
            if([stype.serviceTypeId isEqualToNumber:stypeId]) {
                res = stype.fullName;
                break;
            }
        }
    }
    return res;
}

- (void) requestOrderTypeInfo {
    NSArray * typeList = [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:REPORT_ORDER_TYPE_SELF_CHECK], [NSNumber numberWithInteger:REPORT_ORDER_TYPE_MAINTENANCE], nil];
    if(typeList) {
        [self getOrderTypeList:typeList];
        [self showRoot];
    }
    [self hideLoadingDialog];
}

- (void) getOrderTypeList:(NSArray *) types {
    _nodes = [[NodeList alloc] init];
    NSInteger level = 1;
    for(NSNumber * type in types) {
        NSString * typeStr = [ReportServerConfig getReportOrderTypeString:type.integerValue];
        NodeItem * item = [[NodeItem alloc] initWith:[type integerValue] value:typeStr level:level];
        [_nodes addNode:item];
    }
    [_nodes addNodeLevel:level];
    [_nodes setDesc:[[BaseBundle getInstance] getStringByKey:@"function_info_select_order_type" inTable:nil]];
    
}

- (void) requestPriorityInfo {
    BaseDataDbHelper * dbHelper = [BaseDataDbHelper getInstance];
    NSNumber * orgId = [_requestParam valueForKeyPath:@"orgId"];
    NSNumber * stypeId = [_requestParam valueForKeyPath:@"stypeId"];
    Position * pos = [_requestParam valueForKeyPath:@"position"];
    NSNumber * orderType = [_requestParam valueForKeyPath:@"orderType"];
    _flowList = [dbHelper queryAllFlowsOfCurrentProject];
    _flowList = [dbHelper queryAllFlowWithServiceType:stypeId andOrg:orgId andLocation:pos andOrderType:orderType.integerValue];
    _priorityList = [dbHelper queryAllPriorityByFlow:_flowList];
    if(_priorityList) {
        [self getPriorityList:_priorityList];
        [self showRoot];
    }
    [self hideLoadingDialog];
}

- (void) getPriorityList:(NSMutableArray *) priorityArray {
    _nodes = [[NodeList alloc] init];
    NSInteger level = 1;
    for(Priority * priority in priorityArray) {
        NodeItem * item = [[NodeItem alloc] initWith:0 key:[priority.priorityId integerValue] value:priority.name level:level];
        [_nodes addNode:item];
    }
    [_nodes addNodeLevel:level];
    [_nodes setDesc:[[BaseBundle getInstance] getStringByKey:@"function_info_select_priority" inTable:nil]];
}

//请求仓库信息
- (void) requestWareHouseInfo {
    NSNumber * emId = [SystemConfig getEmployeeId];
    NSNumber * selectAll = [_requestParam valueForKeyPath:@"selectAll"];
    if(selectAll && selectAll.boolValue) {
        emId = nil;
    }
    InventoryGetWarehouseParam * param = [[InventoryGetWarehouseParam alloc] initWith:_mPage employeeId:emId];
    
    [_inventoryBusiness getWarehouseList:param success:^(NSInteger key, id object) {
        InventoryGetWarehouseResponseData * data = object;
        [_mPage setPage:data.page];
        if(!_wareHouseList) {
            _wareHouseList = [[NSMutableArray alloc] init];
        } else if([_mPage isFirstPage]) {
            [_wareHouseList removeAllObjects];
        }
        NSArray * array = data.contents;
        if([array count] > 0) {
            [_wareHouseList addObjectsFromArray:array];
        }
        if([_mPage haveMorePage]) {
            [_mPage nextPage];
            [self requestWareHouseInfo];
        } else {
            [self getWareHouseList:_wareHouseList];
            [self showRoot];
        }
        [self hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
    }];
}

- (void) getWareHouseList:(NSMutableArray *) houseList {
    _nodes = [[NodeList alloc] init];
    for(WarehouseEntity * house in houseList) {
        NodeItem * item = [[NodeItem alloc] initWith:0 key:house.warehouseId.integerValue value:house.name];
        [_nodes addNode:item];
    }
    [_nodes setDesc:[[BaseBundle getInstance] getStringByKey:@"function_info_select_inventory" inTable:nil]];
}

//请求物料信息
- (void) requestMaterialInfo {
    NSNumber * houseId = [_requestParam valueForKeyPath:@"warehouseId"];
    InventoryGetMaterialCondition * condition = [_requestParam valueForKeyPath:@"condition"];
    InventoryGetMaterialParam * param = [[InventoryGetMaterialParam alloc] initWith:_mPage warehouse:houseId condition:condition];
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    NSString * token = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    [netRequest request:param token:token deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber * tmpNumber;
        NSDictionary * data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
        }
        if(data) {
            NSDictionary * page = [data valueForKeyPath:@"page"];
            if([page isKindOfClass:[NSNull class]]) {
                page = nil;
            }
            [_mPage setPageWithDictionary:page];
            if(!_materialList) {
                _materialList = [[NSMutableArray alloc] init];
            } else if([_mPage isFirstPage]) {
                [_materialList removeAllObjects];
            }
            NSArray * contents = [data valueForKeyPath:@"contents"];
            if([contents isKindOfClass:[NSNull class]]) {
                contents = nil;
            }
            for(NSDictionary * content in contents) {
                MaterialEntity * material = [[MaterialEntity alloc] init];
                material.inventoryId = [content valueForKeyPath:@"inventoryId"];
                if([material.inventoryId isKindOfClass:[NSNull class]]) {
                    material.inventoryId = nil;
                    continue;
                }
                material.materialCode = [content valueForKeyPath:@"materialCode"];
                if([material.materialCode isKindOfClass:[NSNull class]]) {
                    material.materialCode = nil;
                }
                material.materialName = [content valueForKeyPath:@"materialName"];
                if([material.materialName isKindOfClass:[NSNull class]]) {
                    material.materialName = nil;
                }
                material.materialBrand = [content valueForKeyPath:@"materialBrand"];
                if([material.materialBrand isKindOfClass:[NSNull class]]) {
                    material.materialBrand = nil;
                }
                material.materialModel = [content valueForKeyPath:@"materialModel"];
                if([material.materialModel isKindOfClass:[NSNull class]]) {
                    material.materialModel = nil;
                }
                material.materialUnit = [content valueForKeyPath:@"materialUnit"];
                if([material.materialUnit isKindOfClass:[NSNull class]]) {
                    material.materialUnit = nil;
                }
                
                tmpNumber = [content valueForKeyPath:@"totalNumber"];  //库存数量
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                material.totalNumber = tmpNumber;
                
                tmpNumber = [content valueForKeyPath:@"minNumber"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                material.minNumber = tmpNumber;
                
                tmpNumber = [content valueForKeyPath:@"realNumber"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                material.realNumber = tmpNumber;
                
                material.cost = [content valueForKeyPath:@"cost"];
                if([material.cost isKindOfClass:[NSNull class]]) {
                    material.cost = nil;
                }
                
                material.pictures = [content valueForKeyPath:@"pictures"];
                if([material.pictures isKindOfClass:[NSNull class]]) {
                    material.pictures = nil;
                }
                
                [_materialList addObject:material];
            }
            if([_mPage haveMorePage]) {
                [_mPage nextPage];
                [self requestMaterialInfo];
            } else {
                [self getMaterialList:_materialList];
                [self showRoot];
                [self hideLoadingDialog];
            }
        } else {
            [self hideLoadingDialog];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingDialog];
    }];

}

- (void) getMaterialList:(NSMutableArray *) materialList {
    _nodes = [[NodeList alloc] init];
    for(MaterialEntity * material in materialList) {
        NSString * desc = @"";
        if(![FMUtils isStringEmpty:material.materialBrand]) {
            desc = material.materialBrand;
        }
        if(![FMUtils isStringEmpty:material.materialModel]) {
            desc = [[NSString alloc] initWithFormat:@"%@(%@)", desc, material.materialModel];
        }
        NodeItem * item = [[NodeItem alloc] initWith:0 key:material.inventoryId.integerValue value:material.materialName desc:desc];
        [_nodes addNode:item];
    }
    [_nodes setDesc:[[BaseBundle getInstance] getStringByKey:@"function_info_select_material" inTable:nil]];
}


- (void) requestDeviceInfo {
    Position * pos = [_requestParam valueForKeyPath:@"position"];
    BaseDataDbHelper * dbHelper = [BaseDataDbHelper getInstance];
    if(pos) {
        _deviceList = [dbHelper queryAllDevicesByPosition:pos];
    } else {
        _deviceList = [dbHelper queryAllDevicesOfCurrentProject];
    }
    if(_deviceList) {
        [self getDeviceList:_deviceList];
        [self showRoot];
    }
    [self hideLoadingDialog];
}

- (void) getDeviceList:(NSMutableArray *) deviceList {
    _nodes = [[NodeList alloc] init];
    for(Device * device in deviceList) {
        NodeItem * item = [[NodeItem alloc] initWith:0 key:[device.eqId integerValue] value:device.name desc:device.code];
        [_nodes addNode:item];
    }
//    [_nodes addNodeLevel:1];
    [_nodes setDesc:[[BaseBundle getInstance] getStringByKey:@"function_info_select_equipment" inTable:nil]];
}

- (void) requestRequirementTypeInfo {
    BaseDataDbHelper * dbHelper = [BaseDataDbHelper getInstance];
    _requirementTypeList = [dbHelper queryAllRequirementTypesOfCurrentProject];
    
    if(_requirementTypeList) {
        [self getRequirementTypeList:_requirementTypeList];
        [self showRoot];
    }
    [self hideLoadingDialog];
}


- (void) getRequirementTypeList:(NSMutableArray *) typeList {
    _nodes = [[NodeList alloc] init];
    NSInteger maxLevel = 0;
    for(RequirementType * type in typeList) {
        NSInteger level = [[type.fullName componentsSeparatedByString:@"/"] count];
        if(maxLevel < level ) {
            maxLevel = level;
        }
        NodeItem * item = [[NodeItem alloc] initWith:[type.parentTypeId integerValue] key:[type.typeId integerValue] value:type.name level:level];
        [_nodes addNode:item];
    }
    for(NSInteger i=1;i<=maxLevel;i++) {
        if(i == 1) {
            [_nodes addNodeLevel:1];
        } else {
            [_nodes addNodeLevel:i parent:i-1];
        }
        
    }
    [_nodes setDesc:[[BaseBundle getInstance] getStringByKey:@"function_info_select_requirement" inTable:nil]];
    
}


- (void) requestLocationInfo {
    BaseDataDbHelper * dbHelper = [BaseDataDbHelper getInstance];
    NSMutableArray * cityList = [dbHelper queryAllCitiesOfCurrentProject];
    NSMutableArray * siteList = [dbHelper queryAllSitesOfCurrentProject];
    NSMutableArray * buildingList = [dbHelper queryAllBuildingsOfCurrentProject];
    NSMutableArray * floorList = [dbHelper queryAllFloorsOfCurrentProject];
    NSMutableArray * roomList = [dbHelper queryAllRoomsOfCurrentProject];
    if(!_positionsList) {
        _positionsList = [[Positions alloc] init];
    }
    _positionsList.citys = cityList;
    _positionsList.sites = siteList;
    _positionsList.buildings = buildingList;
    _positionsList.floors = floorList;
    _positionsList.rooms = roomList;
    
    if(_positionsList) {
        [self getLocationList:_positionsList];
        [self showRoot];
    }
    [self hideLoadingDialog];
}

- (void) getLocationList:(Positions *) positionsList {
    NSString * desc = [[BaseBundle getInstance] getStringByKey:@"function_info_select_location" inTable:nil];
    _nodes = [self getNodesOfPositionsList:positionsList desc:desc];
}

- (NodeList *) getNodesOfPositionsList:(Positions *) positions desc:(NSString *) desc {
    NodeList * nodes = [[NodeList alloc] init];
    nodes.desc = [desc copy];
    if(positions) {
        NSInteger count = [positions.citys count];
        NSInteger i = 0;
        //add city to the list
//        count = [positions.sites count];
//        [nodes addNodeLevel:LEVEL_SITE];
//        for(i=0;i<count;i++) {
//            Site * site = positions.sites[i];
//            NodeItem * node = [[NodeItem alloc] initWith:[site.siteId integerValue] value:site.name level:LEVEL_SITE];
//            [nodes addNode:node];
//        }
        
        count = [positions.buildings count];
//        [nodes addNodeLevel:LEVEL_BUILDING parent:LEVEL_SITE];
        [nodes addNodeLevel:LEVEL_BUILDING];
        for(i=0;i<count;i++) {
            Building * building = positions.buildings[i];
            NodeItem * node = [[NodeItem alloc] initWith:[building.buildingId integerValue] value:building.name level:LEVEL_BUILDING];
            [nodes addNode:node];
        }
        
        count = [positions.floors count];
        [nodes addNodeLevel:LEVEL_FLOOR parent:LEVEL_BUILDING];
        for(i=0;i<count;i++) {
            Floor * floor = positions.floors[i];
            NodeItem * node = [[NodeItem alloc] initWith:[floor.buildingId integerValue] key:[floor.floorId integerValue] value:floor.name level:LEVEL_FLOOR];
            [nodes addNode:node];
        }
        
        count = [positions.rooms count];
        [nodes addNodeLevel:LEVEL_ROOM parent:LEVEL_FLOOR];
        for(i=0;i<count;i++) {
            Room * room = positions.rooms[i];
            NodeItem * node = [[NodeItem alloc] initWith:[room.floorId integerValue] key:[room.roomId integerValue] value:room.name level:LEVEL_ROOM];
            [nodes addNode:node];
        }
    }
    return nodes;
}

- (Position *) getPositionInfoOfNode:(NodeItem *) node {
    Position * pos = [[Position alloc] init];
    NSInteger level = [node getLevel];
    switch(level) {
        case LEVEL_CITY:
            pos.cityId = [NSNumber numberWithInteger:[node getKey]];
            break;
        case LEVEL_SITE:
            pos.siteId = [NSNumber numberWithInteger:[node getKey]];
            pos.cityId = nil;
            break;
        case LEVEL_BUILDING:
            pos.buildingId = [NSNumber numberWithInteger:[node getKey]];
            pos.siteId = [NSNumber numberWithInteger:[node getParentKey]];
            pos.cityId = nil;
            break;
        case LEVEL_FLOOR:
            pos.floorId = [NSNumber numberWithInteger:[node getKey]];
            pos.buildingId = [NSNumber numberWithInteger:[node getParentKey]];
            pos.siteId = [[_positionsList getBuilding:pos.buildingId].siteId copy];
            pos.cityId = nil;
            break;
        case LEVEL_ROOM:
            pos.roomId = [NSNumber numberWithInteger:[node getKey]];
            pos.floorId = [NSNumber numberWithInteger:[node getParentKey]];
            pos.buildingId = [[_positionsList getFloor:pos.floorId].buildingId copy];
            pos.siteId = [[_positionsList getBuilding:pos.buildingId].siteId copy];
            pos.cityId = nil;
            break;
        default:
            break;
    }
    return pos;
}

- (NSString *) getPositionStr:(Position *) pos {
    NSString * cityName = @"";
    NSString * citySep = @"";
    NSString * siteName = @"";
    NSString * siteSep = @"";
    NSString * buildingName = @"";
    NSString * buildingSep = @"";
    NSString * floorName = @"";
    NSString * floorSep = @"";
    NSString * roomName = @"";
    if(pos.cityId) {
        City * city = [_positionsList getCity:pos.cityId];
        if(city) {
            cityName = city.name;
        }
    }
    if(pos.siteId) {
        Site * site = [_positionsList getSite:pos.siteId];
        if(site) {
            siteName = site.name;
            if(![FMUtils isStringEmpty:cityName]) {
                citySep = @"/";
            }
        }
    }
    if(pos.buildingId) {
        Building * building = [_positionsList getBuilding:pos.buildingId];
        if(building) {
            buildingName = building.name;
            if(![FMUtils isStringEmpty:siteName]) {
                siteSep = @"/";
            }
        }
    }
    if(pos.floorId) {
        Floor * floor = [_positionsList getFloor:pos.floorId];
        if(floor) {
            floorName = floor.name;
            if(![FMUtils isStringEmpty:buildingName]) {
                buildingSep = @"/";
            }
        }
    }
    if(pos.roomId) {
        Room * room = [_positionsList getRoom:pos.roomId];
        if(room) {
            roomName = room.name;
            if(![FMUtils isStringEmpty:floorName]) {
                floorSep = @"/";
            }
        }
    }
    NSString * strPosition = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@", cityName, citySep, siteName, siteSep, buildingName, buildingSep, floorName, floorSep, roomName];
    return strPosition;
}

- (Org*) getOrgInfoOfNode:(NodeItem *) node {
    Org * res = nil;
    NSInteger orgId = [node getKey];
    for(Org * org in _orgList) {
        if([org.orgId isEqualToNumber:[NSNumber numberWithInteger:orgId]]) {
            res = org;
            break;
        }
    }
    return res;
    
}

- (ServiceType*) getStypeInfoOfNode:(NodeItem *) node {
    ServiceType * res = nil;
    NSInteger stypeId = [node getKey];
    for(ServiceType * stype in _stypeList) {
        if([stype.serviceTypeId isEqualToNumber:[NSNumber numberWithInteger:stypeId]]) {
            res = stype;
            break;
        }
    }
    return res;
    
}

- (NSNumber *) getOrderTypeInfoOfNode:(NodeItem *) node {
    NSNumber * res = nil;
    NSInteger type;
    if(node) {
        type = [node getKey];
    } else {
        type = REPORT_ORDER_TYPE_MAINTENANCE;
    }
    res = [NSNumber numberWithInteger:type];
    return res;
}

- (Priority*) getPriorityInfoOfNode:(NodeItem *) node {
    Priority * res = nil;
    NSInteger priorityId = [node getKey];
    for(Priority * priority in _priorityList) {
        if([priority.priorityId isEqualToNumber:[NSNumber numberWithInteger:priorityId]]) {
            res = priority;
            break;
        }
    }
    return res;
    
}

- (Flow *) getFlowByPriority:(Priority *) priority {
    Flow * res;
    if(priority) {
        for(Flow * flow in _flowList) {
            if([flow.priorityId isEqualToNumber:priority.priorityId]) {
                res = flow;
                break;
            }
        }
    }
    return res;
}

- (Device*) getDeviceInfoOfNode:(NodeItem *) node {
    Device * res = nil;
    NSInteger deviceId = [node getKey];
    for(Device * device in _deviceList) {
        if([device.eqId isEqualToNumber:[NSNumber numberWithInteger:deviceId]]) {
            res = device;
            break;
        }
    }
    return res;
    
}

- (RequirementType*) getRequirementTypeInfoOfNode:(NodeItem *) node {
    RequirementType * res = nil;
    NSInteger typeId = [node getKey];
    for(RequirementType * type in _requirementTypeList) {
        if([type.typeId isEqualToNumber:[NSNumber numberWithInteger:typeId]]) {
            res = type;
            break;
        }
    }
    return res;
    
}

- (WarehouseEntity *) getWarehouseInfoOfNode:(NodeItem *) node {
    WarehouseEntity * res = nil;
    NSInteger warehouseId = [node getKey];
    for(WarehouseEntity * warehouse in _wareHouseList) {
        if([warehouse.warehouseId isEqualToNumber:[NSNumber numberWithInteger:warehouseId]]) {
            res = warehouse;
            break;
        }
    }
    return res;
}

- (MaterialEntity *) getMaterialInfoOfNode:(NodeItem *) node {
    MaterialEntity * res = nil;
    NSInteger materialId = [node getKey];
    for(MaterialEntity * material in _materialList) {
        if([material.inventoryId isEqualToNumber:[NSNumber numberWithInteger:materialId]]) {
            res = material;
            break;
        }
    }
    return res;
}


- (void) requestCommonInfo {
    if(_requestParam) {
        NSString * title = [_requestParam valueForKeyPath:@"desc"];
        NSArray * data = [_requestParam valueForKeyPath:@"data"];
        NodeList * nodes = [[NodeList alloc] init];
        nodes.desc = [title copy];
        
        NSInteger index = 1;
        for(NSString * strItem in data) {
            NodeItem * item = [[NodeItem alloc] initWith:index value:strItem];
            [nodes addNode:item];
            index++;
        }
        _nodes = nodes;
        [self showRoot];
        [self hideLoadingDialog];
    }
}

- (NSMutableDictionary *) getCommonInfoOfNode:(NodeItem *) item {
    NSMutableDictionary * res;
    if(item) {
        NSString * value = [item getVal];
        NSInteger position = [item getKey] - 1;
        res = [[NSMutableDictionary alloc] initWithObjectsAndKeys:value, @"desc", [NSNumber numberWithInteger:position], @"position", nil];
    }
    return res;
}


#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [_nodesArray count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    ////    //解决cell重用带来的问题
    static NSString *cellIdentifier = @"Cell";
    NodeItemView * itemView = nil;
    SeperatorView * seperator;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat itemHeight = _itemHeight;
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    NSInteger count = [_nodesArray count];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subviews = [cell subviews];
        for(id view in subviews) {
            if([view isKindOfClass:[NodeItemView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                seperator = view;
            }
        }
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, itemHeight-seperatorHeight, width - padding * 2, seperatorHeight)];
        [cell addSubview:seperator];
    }
    if(seperator) {
        if(position == count - 1) {
            [seperator setDotted:NO];
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
        }else {
            [seperator setDotted:YES];
            [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width - padding * 2, seperatorHeight)];
        }
        
    }
    if(cell && !itemView) {
        itemView = [[NodeItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
        
        [cell addSubview:itemView];
    }
    if(itemView) {
        NodeItem * node = _nodesArray[position];
        NSInteger key = [node getKey];
        NSInteger level = [node getLevel];
        NSInteger childrenLevel = [_nodes getChildrenLevel:level];
        
        if (_requestType == REQUEST_TYPE_MATERIAL_INFO_SELECT) {   //物料选择特性
            MaterialEntity *entity = [self getMaterialInfoOfNode:node];
            [itemView setMaterialsAmount:entity.totalNumber];
        }
        
        if(level == LEVEL_LEAF || [[_nodes getChildren:key level:childrenLevel] count] == 0) {
            [itemView setShowMore:NO];
        } else {
            [itemView setShowMore:YES];
        }
        [itemView setInfoWith:node];
        itemView.tag = position;
        
    }
    return cell;
}

- (NSString*) tableView: (UITableView*) tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSString*) tableView: (UITableView*) tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}


#pragma mark - 点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    NodeItem * node = _nodesArray[position];
    if(node) {
        NSInteger key = [node getKey];
        _searchTf.text = @"";
        
        [self showChildren:key];
    }
}

#pragma - 文本框搜索过滤
- (void) onSearchFilterChanged {
    UITextRange * selectedRange = [_searchTf markedTextRange];
    if(selectedRange == nil || selectedRange.empty){
        [self updateList];
    }
}
@end
