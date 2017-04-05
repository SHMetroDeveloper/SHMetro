//
//  BaseDataEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/2.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseDataEntity.h"
#import "FMUtils.h"
#import "SystemConfig.h"
#import "BaseDataServerConfig.h"
#import "PowerManager.h"
#import "WorkOrderFunctionPermission.h"
#import "RequirementFunctionPermission.h"
#import "MJExtension.h"
#import "BaseDataDbHelper.h"



NSInteger const REQUEST_TYPE_DEVICE_PAGE = 100;
NSInteger const REQUEST_TYPE_DEVICE_PAGE_POSITION = 101;
NSInteger const REQUEST_TYPE_DEVICE_TYPE_PAGE = 200;

NSInteger const REQUEST_TYPE_PRIORITY_PAGE = 100;
NSInteger const REQUEST_TYPE_PRIORITY_PAGE_CON = 101;

NSInteger const REQUEST_TYPE_FLOW_PAGE = 100;
NSInteger const REQUEST_TYPE_FLOW_PAGE_CON = 101;

static NSNumber* const DEFAULT_CITY_ID = nil;

//部门
@implementation Org
@end

//服务类型
@implementation ServiceType
@end

//城市
@implementation City
@end

//区域
@implementation Site
@end

//单元
@implementation Building
@end

//楼层
@implementation Floor
@end

//房间
@implementation Room
@end

//具体位置
@implementation Position

- (BOOL) isNull {
    BOOL res = YES;
    if(![self isSiteNull] || ![self isBuildingNull] || ![self isFloorNull] || ![self isRoomNull]) {
        res = NO;
    }
    return res;
}
- (BOOL) isCityNull {
    BOOL res = YES;
    if(![FMUtils isObjectNull:_cityId] && ![_cityId isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = NO;
    }
    return res;
}
- (BOOL) isSiteNull {
    BOOL res = YES;
    if(![FMUtils isObjectNull:_siteId] && ![_siteId isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = NO;
    }
    return res;
}
- (BOOL) isBuildingNull {
    BOOL res = YES;
    if(![FMUtils isObjectNull:_buildingId] && ![_buildingId isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = NO;
    }
    return res;
}
- (BOOL) isFloorNull {
    BOOL res = YES;
    if(![FMUtils isObjectNull:_floorId] && ![_floorId isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = NO;
    }
    return res;
}
- (BOOL) isRoomNull {
    BOOL res = YES;
    if(![FMUtils isObjectNull:_roomId] && ![_roomId isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = NO;
    }
    return res;
}

- (NSString *) getPositionStr {
    NSString * res = @"";
    return res;
}

- (instancetype) copy {
    Position * pos = [[Position alloc] init];
    pos.cityId = [_cityId copy];
    pos.siteId = [_siteId copy];
    pos.buildingId = [_buildingId copy];
    pos.floorId = [_floorId copy];
    pos.roomId = [_roomId copy];
    return pos;
}

- (BOOL) isEqual:(id) obj {
    BOOL res = NO;
    if([obj isKindOfClass:[Position class]]) {
        Position * pos = (Position *) obj;
        if(pos) {
            if( (_cityId == pos.cityId || (_cityId && pos.cityId && [_cityId isEqualToNumber:pos.cityId])) &&
               (_siteId == pos.siteId || (_siteId && pos.siteId && [_siteId isEqualToNumber:pos.siteId])) &&
               (_buildingId == pos.buildingId || (_buildingId && pos.buildingId && [_buildingId isEqualToNumber:pos.buildingId])) &&
               (_floorId == pos.floorId || (_floorId && pos.floorId && [_floorId isEqualToNumber:pos.floorId])) &&
               (_roomId == pos.roomId || (_roomId && pos.roomId && [_roomId isEqualToNumber:pos.roomId]))) {
                res = YES;
            }
        }
    }
    return res;
}

//判断位置是否属于指定站点
- (BOOL) isBelongTo:(Position *) pos {
    BOOL res = NO;
    if(pos && pos.buildingId) {
        NSInteger level = [Positions getPositionLevel:self];
        NSNumber *floorId;
        NSNumber *buildingId;
        Building * building;
        switch(level) {
            case LEVEL_ROOM:
                floorId = _floorId;
                buildingId = [[BaseDataDbHelper getInstance] queryFloorById:floorId].buildingId;
                break;
            case LEVEL_FLOOR:
                buildingId = _buildingId;
                break;
            case LEVEL_BUILDING:
                buildingId = _buildingId;
                break;
        }
        if(buildingId) {
            building = [[BaseDataDbHelper getInstance] queryBuildingById:buildingId];
            if(building.type == METRO_BUILDING_TYPE_STATION) {//站点
                if([building.buildingId isEqualToNumber:pos.buildingId]) {
                    res = YES;
                }
            } else {//区间
                if([building.relatedBuildingId isEqualToNumber:pos.buildingId]) {
                    res = YES;
                }
            }
        }
    }
    return res;
}
@end


@implementation Positions

- (instancetype) init {
    self = [super init];
    if(self) {
        _citys = [[NSMutableArray alloc] init];
        _sites = [[NSMutableArray alloc] init];
        _buildings = [[NSMutableArray alloc] init];
        _floors = [[NSMutableArray alloc] init];
        _rooms = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void) clear {
    if(_citys) {
        [_citys removeAllObjects];
    }
    if(_sites) {
        [_sites removeAllObjects];
    }
    if(_buildings) {
        [_buildings removeAllObjects];
    }
    if(_floors) {
        [_floors removeAllObjects];
    }
    if(_rooms) {
        [_rooms removeAllObjects];
    }
}
- (City*) getCity:(NSNumber *) cityId {
    City* res = nil;
    for(City* city in self.citys) {
        if([city.cityId isEqualToNumber:cityId]) {
            res = city;
            break;
        }
    }
    return res;
}
- (Site*) getSite:(NSNumber *) siteId {
    Site* res = nil;
    for(Site* site in _sites) {
        if([site.siteId isEqualToNumber:siteId]) {
            res = site;
            break;
        }
    }
    return res;
}
- (Building*) getBuilding:(NSNumber *) buildingId {
    Building* res = nil;
    for(Building* building in _buildings) {
        if([building.buildingId isEqualToNumber:buildingId]) {
            res = building;
            break;
        }
    }
    return res;
}
- (Floor*) getFloor:(NSNumber *) floorId {
    Floor* res = nil;
    for(Floor* floor in _floors) {
        if([floor.floorId isEqualToNumber:floorId]) {
            res = floor;
            break;
        }
    }
    return res;
}
- (Room*) getRoom:(NSNumber *) roomId {
    Room* res = nil;
    for(Room* room in _rooms) {
        if([room.roomId isEqualToNumber:roomId]) {
            res = room;
            break;
        }
    }
    return res;
}
- (NSString*) getPositionString:(Position*) pos {
    NSString* res = @"";
    NSInteger level = [Positions getPositionLevel:pos];
    
    NSString* strRoom = @"";
    NSString* strSepRoom = @"";
    NSString* strFloor = @"";
    NSString* strSepFloor = @"";
    NSString* strBuilding = @"";
    NSString* strSepBuilding = @"";
    NSString* strSite = @"";
    
    switch (level) {
        case LEVEL_ROOM:
            strRoom = [self getRoom:pos.roomId].name;
        case LEVEL_FLOOR:
            if(![FMUtils isStringEmpty:strRoom]) {
                strSepRoom = @"/";
            }
            strFloor = [self getFloor:pos.floorId].name;
        case LEVEL_BUILDING:
            if(![FMUtils isStringEmpty:strFloor]) {
                strSepFloor = @"/";
            }
            strBuilding = [self getBuilding:pos.buildingId].name;
        case LEVEL_SITE:
            if(![FMUtils isStringEmpty:strBuilding]) {
                strSepBuilding = @"/";
            }
            strSite = [self getSite:pos.siteId].name;
            break;
            
        default:
            
            break;
    }
    res = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@", strSite, strSepBuilding, strBuilding, strSepFloor, strFloor, strSepRoom, strRoom];
    return res;
}

+ (NSInteger) getPositionLevel:(Position*) pos {
    NSInteger level = LEVEL_CITY;
    if(pos) {
        if(![pos isRoomNull]) {
            level = LEVEL_ROOM;
        } else if(![pos isFloorNull]) {
            level = LEVEL_FLOOR;
        } else if(![pos isBuildingNull]) {
            level = LEVEL_BUILDING;
        } else if(![pos isSiteNull]) {
            level = LEVEL_SITE;
        }
    }
    return level;
}

@end


//设备
@implementation Device

- (instancetype) init {
    self = [super init];
    if(self) {
        _position = [[Position alloc] init];
    }
    return self;
}

- (DeviceType*) getDeviceType {
    DeviceType * devType = [[DeviceType alloc] init];
    devType.equSysName = @"";
    return devType;
}
- (BOOL) isEqual:(id)object {
    BOOL res = NO;
    if([object isKindOfClass:[Device class]]) {
        Device * dev = (Device *) object;
        if([_eqId isEqualToNumber:dev.eqId] &&
           [_code isEqualToString:dev.code] &&
           [_name isEqualToString:dev.name] &&
           [_qrcode isEqualToString:dev.qrcode] &&
           [_sysType isEqualToString:dev.sysType] &&
           [_equSystem isEqualToNumber:dev.equSystem] &&
           [_position isEqual:dev.position]) {
            res = YES;
        }
    }
    return res;
}

@end

//设备类型
@implementation DeviceType

@end

//优先级
@implementation Priority
@end

//流程
@implementation Flow
- (instancetype) init {
    self = [super init];
    if(self) {
        self.position = [[Position alloc] init];
    }
    return self;
}

@end

@implementation RequirementType
@end

@implementation SatisfactionType
@end

@implementation FailureReason
@end

@implementation DownloadRecord
- (instancetype) initWithDataType:(NSInteger) dataType andPreRequestDate:(NSNumber *) preRequestDate {
    self = [super init];
    if(self) {
        _dataType = dataType;
        _preRequestDate = [preRequestDate copy];
    }
    return self;
}
@end

@implementation UpdateRecord
- (BOOL) isNewData {
    BOOL res = NO;
    if([SystemConfig needShowOrder]) {
        res = res || _priorityTypeNew || _workFlowNew || _locationNew || _serviceTypeNew || _departmentNew || _failureReasonNew;
    }
    if([SystemConfig needShowRequirement]) {
//        res = res || _requirementTypeNew || _satisfactionDegreeNew;
        res = res || _requirementTypeNew;   //删除满意度信息
    }
    if([SystemConfig needShowAsset]) {
        res = res || _deviceNew || _deviceTypeNew;
    }
    return res;
}
- (instancetype) copy {
    UpdateRecord * res = [[UpdateRecord alloc] init];
    res.newestDate = [_newestDate copy];
    res.priorityTypeNew = _priorityTypeNew;
    res.workFlowNew = _workFlowNew;
    res.deviceNew = _deviceNew;
    res.deviceTypeNew = _deviceTypeNew;
    res.locationNew = _locationNew;
    res.serviceTypeNew = _serviceTypeNew;
    res.departmentNew = _departmentNew;
    res.requirementTypeNew = _requirementTypeNew;
//    res.satisfactionDegreeNew = _satisfactionDegreeNew;
    return res;
}
@end

@implementation UndoTaskEntity
@end

@implementation UndoTaskResponse
@end


@implementation MaterialBatchEntity
- (NSString *) getDateStr {
    NSString * res;
    if(_date && ![_date isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        NSDate * date = [FMUtils timeLongToDate:_date];
        res = [FMUtils getDayStr:date];
    }
    return res;
    
}
@end


@implementation BaseDataGetMaterialAmountResponse
@end


@implementation WorkOrderMaterial
- (instancetype) copy {
    WorkOrderMaterial * material = [[WorkOrderMaterial alloc] init];
    if(material) {
        material.woMaterialId = [_woMaterialId copy];
        material.warehouseId = [_warehouseId copy];
        material.warehouseName = [_warehouseName copy];
        material.inventoryId = [_inventoryId copy];
        material.materialName = [_materialName copy];
        material.materialBrand = [_materialBrand copy];
        material.materialModel = [_materialModel copy];
        material.materialUnit = [_materialUnit copy];
        material.amount = _amount;
        material.dueDate = [_dueDate copy];
    }
    return material;
}
@end

@implementation BaseDataGetWorkOrderMaterialResponseData

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"WorkOrderMaterial"
             };
}

@end

@implementation BaseDataGetWorkOrderMaterialResponse
@end

@implementation ReserveMaterialEntity
@end

@implementation UpdateMaterialEntity
@end

@implementation MaterialAmountEntity
-(instancetype) init {
    self = [super init];
    if(self) {
        _batchDatas = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation TodayCountEntity
@end

@implementation WorkOrderCurrentlyEntity
@end

@implementation WorkOrderItemTodayEntity
@end

@implementation EmergencyOrderEntity
@end

@implementation NoticeEntity
@end

@implementation HomeChartEntity
- (instancetype) init {
    self = [super init];
    if(self) {
        _countOfToday = [[NSMutableArray alloc] init];
        _workOrderCurrently = [[NSMutableArray alloc] init];
        _workOrderToday = [[NSMutableArray alloc] init];
        _emergency = [[NSMutableArray alloc] init];
        _notice = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void) clear {
    if(_countOfToday) {
        [_countOfToday removeAllObjects];
    }
    if(_workOrderCurrently) {
        [_workOrderCurrently removeAllObjects];
    }
    if(_workOrderToday) {
        [_workOrderToday removeAllObjects];
    }
    if(_emergency) {
        [_emergency removeAllObjects];
    }
    if(_notice) {
        [_notice removeAllObjects];
    }
}
@end

//
@implementation BaseDataGetOrgListRequestParam

- (instancetype) initWith:(NSNumber *) preRequestDate {
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_ORG_LIST_URL];
    return res;
}

@end


//获取服务类型列表请求
@implementation BaseDataGetServiceTypeListRequestParam
- (instancetype) initWith:(NSNumber *) preRequestDate {
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_SERVICE_TYPE_LIST_URL];
    return res;
}
@end

//获取位置列表请求
@implementation BaseDataGetPositionListRequestParam
- (instancetype) initWith:(NSNumber *) preRequestDate {
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_POSITION_LIST_URL];
    return res;
}
@end

@implementation BaseDataGetBuildingListRequestParam
- (instancetype) initWith:(NSNumber *) preRequestDate {
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_BUILDING_LIST_URL];
    return res;
}
@end

@implementation BaseDataGetBuildingListRequestResponse
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"Building"
             };
}
@end


//获取楼层列表请求
@implementation BaseDataGetFloorListRequestParam
- (instancetype) initWith:(NSNumber *) preRequestDate andPage:(NetPageParam *) page{
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
        if(!_page) {
            _page = [[NetPageParam alloc] init];
        }
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_FLOOR_LIST_URL];
    return res;
}
@end

//获取房间列表请求
@implementation BaseDataGetRoomListRequestParam
- (instancetype) initWith:(NSNumber *) preRequestDate andPage:(NetPageParam *) page{
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
        if(!_page) {
            _page = [[NetPageParam alloc] init];
        }
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_ROOM_LIST_URL];
    return res;
}
@end




@implementation BaseDataGetDeviceListRequestParam

- (instancetype) initWith:(NSNumber *) preRequestDate page:(NetPageParam*) page{
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
        if(!_page) {
            _page = [[NetPageParam alloc] init];
        }
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_DEVICE_LIST_URL];
    return res;
}
@end

@implementation BaseDataGetDeviceListRequestResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"Device"
             };
}
@end

@implementation BaseDataGetDeviceListRequestResponse
@end


@implementation BaseDataGetDeviceTypeRequestParam

- (instancetype) initWith:(NSNumber *) preRequestDate page:(NetPageParam*) page{
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
        if(!_page) {
            _page = [[NetPageParam alloc] init];
        }
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_DEVICE_TYPE_URL];
    return res;
}
@end




@implementation BaseDataGetPriorityListRequestParam
- (instancetype) initWith:(NSNumber *) preRequestDate {
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_PRIORITY_LIST_URL];
    return res;
}
@end



@implementation BaseDataGetFlowListRequestParam
- (instancetype) initWith:(NSNumber *) preRequestDate
                     page:(NetPageParam*) page {
    self = [super init];
    if(self) {
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
        _preRequestDate = [preRequestDate copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_FLOW_LIST_URL];
    return res;
}
@end

@implementation BaseDataGetFlowListRequestResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"Flow"
             };
}
@end

@implementation BaseDataGetFlowListRequestResponse
@end


@implementation BaseDataGetRequirementTypeListRequestParam
- (instancetype) initWith:(NSNumber *) preRequestDate {
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_REQUIREMENT_TYPE_LIST_URL];
    return res;
}
@end

@implementation BaseDataGetSatisfactionListRequestParam
- (instancetype) initWith:(NSNumber *) preRequestDate {
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_SATISFACTION_LIST_URL];
    return res;
}
@end

@implementation BaseDataGetFailureReasonRequestParam
- (instancetype) initWith:(NSNumber *) preRequestDate {
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
        _page = [[NetPageParam alloc] init];
    }
    return self;
}
- (void) setPage:(NetPage *) page {
    if(!_page) {
        _page = [[NetPageParam alloc] init];
    }
    _page.pageNumber = [page.pageNumber copy];
    _page.pageSize = [page.pageSize copy];
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_FAILURE_REASON_LIST_URL];
    return res;
}
@end

@implementation BaseDataGetFailureReasonResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"FailureReason"
             };
}
@end

@implementation BaseDataGetFailureReasonResponse
@end

@implementation BaseDataGetUpdateRecordRequestParam

- (instancetype) initWith:(NSNumber *) preRequestDate {
    self = [super init];
    if(self) {
        _preRequestDate = [preRequestDate copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_UPDATE_RECORD_URL];
    return res;
}
@end

@implementation BaseDataGetUpdateRecordResponse
@end

@implementation BaseDataGetUndoTaskCountParam

- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_UNDO_TASK_COUNT];
    return res;
}

@end



@implementation BaseDataGetWorkOrderMaterialParam
- (instancetype) initWithOrderId:(NSNumber *) woId page:(NetPageParam *) page {
    self = [super init];
    if(self) {
        _woId = [woId copy];
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_WORK_ORDER_MATERIAL_URL];
    return res;
}
@end


@implementation BaseDataReserveMaterialParam
- (instancetype) init {
    self = [super init];
    if(self) {
        _inventories = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_RESERVE_MATERIAL_URL];
    return res;
}
@end

//@implementation BaseDataUpdateMaterialParam
//- (instancetype) init {
//    self = [super init];
//    if(self) {
//        _woMaterials = [[NSMutableArray alloc] init];
//    }
//    return self;
//}
//- (NSString*) getUrl {
//    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_UPDATE_MATERIAL_URL];
//    return res;
//}
//@end


@implementation BaseDataGetMaterialAmountParam

- (instancetype) initWithInventoryId:(NSNumber *) inventoryId {
    self = [super init];
    if(self) {
        _inventoryId = inventoryId;
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_MATERIAL_AMOUNT_URL];
    return res;
}

@end

@implementation BaseDataGetMaterialAmountListParam

- (instancetype) initWithArray:(NSMutableArray *) inventoryIdArray {
    self = [super init];
    if(self) {
        _inventoryIds = [inventoryIdArray copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_MATERIAL_AMOUNT_LIST_URL];
    return res;
}

@end


@implementation BaseDataGetChartDataParam

- (instancetype) init {
    self = [super init];
    return self;
}

- (NSString *) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_CHART_DATA_URL];
    return res;
}

@end

