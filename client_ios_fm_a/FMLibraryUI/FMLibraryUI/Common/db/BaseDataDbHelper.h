//
//  BaseDataDbHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/2.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "DBHelper.h"
#import "DBOrg+CoreDataClass.h"
#import "DBStype+CoreDataClass.h"
#import "DBCity+CoreDataClass.h"
#import "DBSite+CoreDataClass.h"
#import "DBBuilding+CoreDataClass.h"
#import "DBFloor+CoreDataClass.h"
#import "DBRoom+CoreDataClass.h"
#import "DBPriority+CoreDataClass.h"
#import "DBFlow+CoreDataClass.h"
#import "DBDevice+CoreDataClass.h"
#import "DBDeviceType+CoreDataClass.h"
#import "BaseDataEntity.h"
#import "DBBaseDownloadRecord+CoreDataClass.h"
#import "DBGroup+CoreDataClass.h"
#import "DBRequirementType+CoreDataClass.h"
#import "DBSatisfactionType+CoreDataClass.h"
#import "DBUser+CoreDataClass.h"
#import "UserEntity.h"
#import "DBFailureReason+CoreDataClass.h"


@interface BaseDataDbHelper : DBHelper

+ (instancetype) getInstance;

//User
- (BOOL) isUserExist:(NSString*) userName;
- (BOOL) addUser:(UserInfo*) user;
- (BOOL) deleteUserById:(NSNumber*) userId;
- (BOOL) updateUserById:(NSNumber*) userId user:(UserInfo*) user;
- (BOOL) updateUserByLoginName:(NSString*) loginName user:(UserInfo*) user;
- (BOOL) clearPasswordOfUser:(NSNumber *) userId;   //清除指定用户密码

- (UserInfo*) queryUserById:(NSNumber*) userId;
- (NSMutableArray*) queryAllUser;
- (NSMutableArray*) queryUserByLoginName:(NSString*) userName;

- (BOOL) saveUserInfo:(UserInfo*) newData;
//删除当前项目下所有员工信息
- (BOOL) deleteAllUserInCurrentProject;
//删除所有员工信息
- (BOOL) deleteAllUser;

//用户组信息
//判断用户的组信息是否存在
- (BOOL) isUserGroupExist:(NSNumber *) emId group:(NSNumber *) groupId;
- (BOOL) addUserGroup:(UserGroup *) info;
- (BOOL) updateUserGroup:(UserGroup *) info;
- (BOOL) saveUserGroupInfo:(UserGroup *) info;
- (BOOL) deleteUserGroupById:(NSNumber *) recordId;
- (BOOL) deleteUserGroupByUserAndGroup:(NSNumber *) userId group:(NSNumber *) groupId;
- (BOOL) deleteAllGroupOfUser:(NSNumber *) emId;
- (NSMutableArray *) QueryAllGroupOfUser:(NSNumber *) emId;
- (BOOL) deleteAllGroupOfUser:(NSNumber *) emId;
//删除当前项目下所有组
- (BOOL) deleteAllGroupOfCurrentProject;
//删除所有工作组
- (BOOL) deleteAllGroup;


//部门
- (BOOL) isOrgExist:(NSNumber*) orgId;
- (BOOL) addOrg:(Org*) org projectId:(NSNumber *) projectId;
- (BOOL) addOrgs:(NSArray *) orgs projectId:(NSNumber *) projectId;
- (BOOL) deleteOrgById:(NSNumber*) orgId;
//依据 ID 批量删除
- (BOOL) deleteOrgByIds:(NSArray *) ids;
//删除当前项目下所有部门
- (BOOL) deleteAllOrgsOfCurrentProject;
//删除所有部门
- (BOOL) deleteAllOrgs;
- (BOOL) updateOrgById:(NSNumber*) orgId org:(Org*) org;
- (NSMutableArray*) queryAllOrgsOfCurrentProject;
- (Org*) queryOrgById:(NSNumber*) orgId;

//服务类型
- (BOOL) isServiceTypeExist:(NSNumber*) stypeId;
- (BOOL) addServiceType:(ServiceType*) stype projectId:(NSNumber *) projectId;
- (BOOL) addServiceTypes:(NSArray *) stypes projectId:(NSNumber *) projectId;
- (BOOL) deleteServiceTypeById:(NSNumber*) stypeId;
//依据 ID 批量删除
- (BOOL) deleteServiceTypeByIds:(NSArray *) ids;
//删除当前项目下所有服务类型
- (BOOL) deleteAllServiceTypeOfCurrentProject;
//删除所有服务类型
- (BOOL) deleteAllServiceType;
- (BOOL) updateServiceTypeById:(NSNumber*) stypeId serviceType:(ServiceType*) stype;
- (NSMutableArray*) queryAllServiceTypeOfCurrentProject;
- (ServiceType*) queryServiceTypeById:(NSNumber*) stypeId;

//优先级
- (BOOL) isPriorityExist:(NSNumber*) priorityId;
- (BOOL) addPriority:(Priority*) priority projectId:(NSNumber *) projectId;
- (BOOL) addPrioritys:(NSArray *) priorityArray projectId:(NSNumber *) projectId;
- (BOOL) deletePriorityById:(NSNumber*) priorityId;
//依据 ID 批量删除
- (BOOL) deletePriorityByIds:(NSArray *) ids;
//删除当前项目下所有优先级
- (BOOL) deleteAllPriorityOfCurrentProject;
//删除所有优先级
- (BOOL) deleteAllPriority;
- (BOOL) updatePriorityById:(NSNumber*) priorityId priority:(Priority*) priority;
- (NSMutableArray*) queryAllPrioritysOfCurrentProject;
- (Priority*) queryPriorityById:(NSNumber*) priorityId;
- (NSMutableArray *) queryAllPrioritiesWithServiceType:(NSNumber *) stypeId andOrg:(NSNumber *) orgId andLocation:(Position *) pos andOrderType:(NSInteger) type;
- (NSMutableArray *) queryAllPriorityByFlow:(NSMutableArray *) flowArray;


//流程
- (BOOL) isFlowExist:(NSNumber*) flowId;
- (BOOL) addFlow:(Flow*) flow;
- (BOOL) addFlows:(NSArray *) flowArray;
- (BOOL) deleteFlowById:(NSNumber*) flowId;
//依据 ID 批量删除
- (BOOL) deleteFlowByIds:(NSArray *) ids;
//删除当前项目下所有流程
- (BOOL) deleteAllFlowOfCurrentProject;
//删除所有流程
- (BOOL) deleteAllFlow;
- (BOOL) updateFlowById:(NSNumber*) flowId flow:(Flow*) flow;
- (NSMutableArray*) queryAllFlowsOfCurrentProject;
- (Flow*) queryFlowById:(NSNumber*) flowId;
- (NSMutableArray *) queryAllFlowWithServiceType:(NSNumber *) stypeId andOrg:(NSNumber *) orgId andLocation:(Position *) pos andOrderType:(NSInteger) type;

//设备
- (BOOL) isDeviceExist:(NSNumber*) deviceId;
- (BOOL) addDevice:(Device*) device;
- (BOOL) addDevices:(NSArray *) deviceArray;
- (BOOL) deleteDeviceById:(NSNumber*) deviceId;
- (BOOL) deleteDeviceByIds:(NSArray *) ids;
//删除当前项目下所有设备信息
- (BOOL) deleteAllDevicesOfCurrentProject;
//删除所有设备信息
- (BOOL) deleteAllDevices;
- (BOOL) updateDeviceById:(NSNumber*) deviceId device:(Device*) device;
- (NSMutableArray*) queryAllDevicesOfCurrentProject;
- (NSMutableArray*) queryAllDevicesByPosition:(Position *) pos;
- (Device*) queryDeviceById:(NSNumber*) deviceId;
- (Device*) queryDeviceByCode:(NSString *) code;

//设备类型
- (BOOL) isDeviceTypeExist:(NSNumber*) deviceTypeId;
- (BOOL) addDeviceType:(DeviceType*) deviceType projectId:(NSNumber *) projectId;
- (BOOL) addDeviceTypes:(NSArray *) deviceTypeArray projectId:(NSNumber *) projectId;
- (BOOL) deleteDeviceTypeById:(NSNumber*) deviceTypeId;
- (BOOL) deleteDeviceTypeByIds:(NSArray *) ids;
//删除当前项目下所有设备类型
- (BOOL) deleteAllDeviceTypeOfCurrentProject;
//删除所有设备类型
- (BOOL) deleteAllDeviceType;
- (BOOL) updateDeviceTypeById:(NSNumber*) deviceTypeId deviceType:(DeviceType*) deviceType;
- (NSMutableArray*) queryAllDeviceTypesOfCurrentProject;
- (DeviceType*) queryDeviceTypeById:(NSNumber*) deviceTypeId;

//城市---City
- (BOOL) isCityExist:(NSNumber*) cityId;
- (BOOL) addCity:(City *) city projectId:(NSNumber *) projectId ;
- (BOOL) addCities:(NSArray *) cityArray projectId:(NSNumber *) projectId;
- (BOOL) deleteCityById:(NSNumber*) cityId;
- (BOOL) deleteCityByIds:(NSArray *) ids;
- (BOOL) updateCityById:(NSNumber*) cityId city:(City*) city;
- (NSMutableArray*) queryAllCitiesOfCurrentProject;
- (City*) queryCityById:(NSNumber*) cityId;
//删除当前项目下所有城市
- (BOOL) deleteAllCitiesOfCurrentProject;
//删除所有城市
- (BOOL) deleteAllCities;

//区域---Site
- (BOOL) isSiteExist:(NSNumber*) siteId;
- (BOOL) addSite:(Site*) site projectId:(NSNumber *) projectId;
- (BOOL) addSites:(NSArray *) siteArray projectId:(NSNumber *) projectId;
- (BOOL) deleteSiteById:(NSNumber*) siteId;
- (BOOL) deleteSiteByIds:(NSArray *) ids;
- (BOOL) updateSiteById:(NSNumber*) siteId site:(Site*) site;
- (NSMutableArray*) queryAllSitesOfCurrentProject;
- (Site*) querySiteById:(NSNumber*) siteId;
//删除当前项目下所有区域信息
- (BOOL) deleteAllSitesOfCurrentProject;
//删除所有区域
- (BOOL) deleteAllSites;

//建筑---Building
- (BOOL) isBuildingExist:(NSNumber*) buildingId;
- (BOOL) addBuilding:(Building*) building projectId:(NSNumber *) projectId;
- (BOOL) addBuildings:(NSArray *) buildingArray projectId:(NSNumber *) projectId;
- (BOOL) deleteBuildingById:(NSNumber*) buildingId;
- (BOOL) deleteBuildingByIds:(NSArray *) ids;
- (BOOL) updateBuildingById:(NSNumber*) buildingId building:(Building*) building;
- (NSMutableArray*) queryAllBuildingsOfCurrentProject;
- (Building*) queryBuildingById:(NSNumber*) buildingId;
//删除当前项目下所有单元信息
- (BOOL) deleteAllBuildingsOfCurrentProject;
//删除所有单元
- (BOOL) deleteAllBuildings;


//楼层---Floor
- (BOOL) isFloorExist:(NSNumber*) floorId;
- (BOOL) addFloor:(Floor*) floor projectId:(NSNumber *) projectId;
- (BOOL) addFloors:(NSArray *) floorArray projectId:(NSNumber *) projectId;
- (BOOL) deleteFloorById:(NSNumber*) floorId;
- (BOOL) deleteFloorByIds:(NSArray *) ids;
- (BOOL) updateFloorById:(NSNumber*) floorId floor:(Floor*) floor;
- (NSMutableArray*) queryAllFloorsOfCurrentProject;
- (Floor*) queryFloorById:(NSNumber*) floorId;
//删除当前项目下所有楼层信息
- (BOOL) deleteAllFloorOfCurrentProject;
//删除所有楼层
- (BOOL) deleteAllFloor;

//房间---Room
- (BOOL) isRoomExist:(NSNumber*) roomId;
- (BOOL) addRoom:(Room*) roomId projectId:(NSNumber *) projectId;
- (BOOL) addRooms:(NSArray *) roomArray projectId:(NSNumber *) projectId;
- (BOOL) deleteRoomById:(NSNumber*) roomId;
- (BOOL) deleteRoomByIds:(NSArray *) ids;
- (BOOL) updateRoomById:(NSNumber*) roomId room:(Room*) room;
- (NSMutableArray*) queryAllRoomsOfCurrentProject;
- (Room*) queryRoomById:(NSNumber*) roomId;
//删除当前项目下的所有房间信息
- (BOOL) deleteAllRoomOfCurrentProject;
//删除所有房间信息
- (BOOL) deleteAllRoom;

//依据ID查询位置信息
- (NSString *) getLocationBy:(Position *) pos;

//获取默认的位置信息
- (Position *) getDefaultPosition;

//需求类型
- (BOOL) isRequirementTypeExist:(NSNumber*) requirementTypeId;
- (BOOL) addRequirementType:(RequirementType*) requirementType projectId:(NSNumber *) projectId;
- (BOOL) addRequirementTypes:(NSArray *) array projectId:(NSNumber *) projectId;
- (BOOL) deleteRequirementTypeById:(NSNumber*) requirementTypeId;
- (BOOL) deleteRequirementTypeByIds:(NSArray *) ids;
//删除当前项目下所有需求类型信息
- (BOOL) deleteAllRequirementTypeOfCurrentProject;
//删除所有需求类型
- (BOOL) deleteAllRequirementType;
- (BOOL) updateRequirementTypeById:(NSNumber*) requirementTypeId requirementType:(RequirementType*) requirementType;
- (NSMutableArray*) queryAllRequirementTypesOfCurrentProject;
- (RequirementType*) queryRequirementTypeById:(NSNumber*) requirementTypeId;

//满意度类型
- (BOOL) isSatisfactionTypeExist:(NSNumber*) satisfactionTypeId;
- (BOOL) addSatisfactionType:(SatisfactionType*) type projectId:(NSNumber *) projectId;
- (BOOL) addSatisfactionTypes:(NSArray *) typeArray projectId:(NSNumber *) projectId;
- (BOOL) deleteSatisfactionTypeById:(NSNumber*) typeId;
- (BOOL) deleteSatisfactionTypeByIds:(NSArray *) ids;
//删除当前项目下的所有满意度信息
- (BOOL) deleteAllSatisfactionTypeOfCurrentProject;
//删除所有满意度信息
- (BOOL) deleteAllSatisfactionType;
- (BOOL) updateSatisfactionTypeById:(NSNumber*) typeId satisfactionType:(SatisfactionType*) type;
- (NSMutableArray*) queryAllSatisfactionTypesOfCurrentProject;
- (SatisfactionType*) querySatisfactionTypeById:(NSNumber*) typeId;

#pragma mark - 故障原因
- (BOOL) isFailurereasonExist:(NSNumber*) reasonId;
- (BOOL) addFailureReason:(FailureReason*) reason;
- (BOOL) addFailureReasons:(NSArray *) array;
- (BOOL) deleteFailureReasonById:(NSNumber*) reasonId;
- (BOOL) deleteFailureReasonByIds:(NSArray *) ids;
//删除当前项目下的所有满意度信息
- (BOOL) deleteAllFailureReason;
- (BOOL) updateFailureReasonById:(NSNumber*) reasonId reason:(FailureReason*) reason;
- (NSMutableArray*) queryAllFailureReason;
- (SatisfactionType*) queryFailureReasonById:(NSNumber*) reasonId;


//数据同步记录
- (BOOL) isDownloadRecordExist:(NSInteger) recordType;
- (BOOL) addDownloadRecord:(DownloadRecord*) record projectId:(NSNumber *) projectId;
- (BOOL) addDownloadRecords:(NSArray *) recordArray projectId:(NSNumber *) projectId;
- (BOOL) deleteDownloadRecordById:(NSNumber*) recordId;
//删除当前项目下的所有下载记录
- (BOOL) deleteAllDownloadRecordOfCurrentProject;
//删除所有下载记录
- (BOOL) deleteAllDownloadRecord;
- (BOOL) updateDownloadRecordByType:(NSInteger) recordType downloadRecord:(DownloadRecord*) record;
- (NSMutableArray*) queryAllDownloadRecordOfCurrentProject;
- (DownloadRecord*) queryDownloadRecordById:(NSNumber*) recordId;
- (DownloadRecord*) queryDownloadRecordByType:(NSInteger) recordType;

//删除所有基础数据
- (void) deleteAllBaseData;
@end
