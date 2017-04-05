//
//  PatrolSpotQrcode.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/14.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "PatrolSpotQrcode.h"
#import "FMUtils.h"

NSString * const FM_QRCODE_PATROL_FUNCTION_SUB_SPOT = @"SPOT"; //用于点位巡视
NSString * const FM_QRCODE_PATROL_FUNCTION_SUB_BUILDING = @"BUILDING";  //用于点位巡检（扫站点二维码）

@interface PatrolSpotQrcode ()
    
@property (nonatomic, strong) NSNumber *spotId;    //点位ID
@property (nonatomic, strong) NSString *spotName;   //点位名称

@property (nonatomic, strong) NSNumber *buildingId;    //站点ID
@property (nonatomic, strong) NSString *buildingName;   //站点名称
    
@end

@implementation PatrolSpotQrcode


- (void)analysisExtendInfo {
    
    NSArray *array = [self getExtandArray];
    if([array count] >= 2) {
        
        NSString *subFunction = [self getSubFunction];
        NSString *resultId = array[0];
        NSString *resultName = array[1];
        if ([subFunction isEqualToString:FM_QRCODE_PATROL_FUNCTION_SUB_SPOT]) {
            
            _spotId = [FMUtils stringToNumber:resultId];
            _spotName = resultName;
        }
        else if ([subFunction isEqualToString:FM_QRCODE_PATROL_FUNCTION_SUB_BUILDING]) {
            
            _buildingId = [FMUtils stringToNumber:resultId];
            _buildingName = resultName;
        }
    }
}


- (BOOL)isValidQrcode {
    
    BOOL res = [super isValidQrcode];
    if(res) {
        
        NSArray *array = [self getExtandArray];
        res = [[self getSubFunction] isEqualToString:FM_QRCODE_PATROL_FUNCTION_SUB_SPOT] && [array count] >= 2;
        if (!res) {
            
            res = [[self getSubFunction] isEqualToString:FM_QRCODE_PATROL_FUNCTION_SUB_BUILDING] && [array count] >= 2;
        }
    }
    
    return res;
}


- (NSNumber *)getSpotId {
    
    return _spotId;
}


- (NSString *)getSpotName {
    
    return _spotName;
}


- (NSNumber *)getBuildingId {
    
    return _buildingId;
}


- (NSString *)getBuildingName {
    
    return _buildingName;
}

@end
