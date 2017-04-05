//
//  PatrolQrcode.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/14.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "PatrolBuildingQrcode.h"
#import "FMUtils.h"

NSString * const FM_QRCODE_FUNCTION_PATROL_SUB_BUILDING = @"BUILDING";

@interface PatrolBuildingQrcode ()
    
@property (readwrite, nonatomic, strong) NSNumber * buildingId;    //站点ID
@property (readwrite, nonatomic, strong) NSString * fullName;   //名称
    
@end

@implementation PatrolBuildingQrcode
    
- (void) analysisExtendInfo {
    NSArray * array = [self getExtandArray];
    if([array count] >= 2) {
        NSString * tmp = array[0];
        _buildingId = [FMUtils stringToNumber:tmp];
        _fullName = array[1];
    }
}
    
- (BOOL) isValidQrcode {
    BOOL res = [super isValidQrcode];
    if(res) {
        NSArray * array = [self getExtandArray];
        res = [[self getSubFunction] isEqualToString:FM_QRCODE_FUNCTION_PATROL_SUB_BUILDING] && [array count] >= 2;
    }
    return res;
}
    
- (NSNumber *) getBuildingId {
    return _buildingId;
}
    
- (NSString *) getFullName {
    return _fullName;
}
    
@end
