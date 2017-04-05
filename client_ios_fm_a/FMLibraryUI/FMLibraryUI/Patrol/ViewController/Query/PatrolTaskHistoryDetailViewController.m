//
//  PatrolTaskHistoryDetailViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolTaskHistoryDetailViewController.h"
#import "PatrolTaskItemView.h"
#import "FMTheme.h"
#import "PatrolTaskSpotItemView.h"
#import "PatrolSpotViewController.h"
#import "BaseBundle.h"
 
#import "SpotContentItemView.h"
#import "PatrolTaskHistorySpotViewController.h"
#import "ReportEntity.h"
#import "SystemConfig.h"
#import "PatrolNetRequest.h"
#import "FMUtils.h"
#import "PatrolHistoryCountView.h"
#import "PatrolHistoryDetailBaseInfoView.h"
#import "PatrolHistoryDetailSpotItemView.h"
#import "PatrolHistoryDetailSpotContentItemView.h"
#import "SeperatorView.h"
#import "PatrolTaskHistoryEquipmentViewController.h"
#import "FMSize.h"
#import "FMFont.h"
#import "PatrolBusiness.h"

@interface PatrolTaskHistoryDetailViewController ()


@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) PatrolHistoryCountView * countView;
@property (readwrite, nonatomic, strong) PatrolHistoryDetailBaseInfoView * baseInfoView;

@property (readwrite, nonatomic, assign) CGFloat countItemHeight;       //计数高度
@property (readwrite, nonatomic, assign) CGFloat baseInfoItemHeight;    //基本信息高度
@property (readwrite, nonatomic, assign) CGFloat spotItemHeight;        //点位项高度
@property (readwrite, nonatomic, assign) CGFloat spotContentItemHeight; //点位内容高度

@property (readwrite, nonatomic, strong) NSNumber * taskId;
@property (readwrite, nonatomic, strong) NSString * taskName;
@property (readwrite, nonatomic, strong) PatrolTaskHistoryDetailItem * task;

@property (readwrite, nonatomic, strong) NSMutableArray * spotViewArray;
@property (readwrite, nonatomic, strong) NSMutableArray * spotContentViewArray;
@property (readwrite, nonatomic, strong) NSMutableArray * seperatorViewArray;
@property (readwrite, nonatomic, assign) NSInteger curSpotIndex;
@property (readwrite, nonatomic, assign) NSInteger seperatorIndex;
@property (readwrite, nonatomic, strong) NSMutableArray * stateArray;   //点位项内容是否展开

@property (readwrite, nonatomic, strong) PatrolBusiness * business;
@property (readwrite, nonatomic, assign) BOOL needUpdate;
@end

@implementation PatrolTaskHistoryDetailViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    if(![FMUtils isStringEmpty:_taskName]) {
        [self setTitleWith:_taskName];
    } else {
        [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"patrol_detail" inTable:nil]];
    }
    [self setBackAble:YES];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self initPatrolReportSuccessHandler];
    [self work];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        _needUpdate = NO;
        [self work];
    }
    [self updateLayout];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _business = [PatrolBusiness getInstance];
        
        _countItemHeight = [PatrolHistoryCountView getCountViewHeight];
        _baseInfoItemHeight = [PatrolHistoryDetailBaseInfoView getBaseInfoHeight];
        _spotItemHeight = 50;
        _spotContentItemHeight = 50;
        _curSpotIndex = -1;
        
        _spotViewArray = [[NSMutableArray alloc] init];
        _spotContentViewArray = [[NSMutableArray alloc] init];
        
        _seperatorViewArray = [[NSMutableArray alloc] init];
        
        CGRect frame = [self getContentFrame];
        CGFloat width = CGRectGetWidth(frame);
        
        CGFloat sepHeight = [FMSize getInstance].settingItemSepHeight;
        CGFloat originY = 0;
        CGFloat itemHeight = 0;
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L9];
        
        itemHeight = _countItemHeight;
        _countView = [[PatrolHistoryCountView alloc] initWithFrame:CGRectMake(0, originY, width, itemHeight)];
        originY += itemHeight + sepHeight;
        
        itemHeight = _baseInfoItemHeight;
        _baseInfoView = [[PatrolHistoryDetailBaseInfoView alloc] initWithFrame:CGRectMake(0, originY, width, itemHeight)];
        originY += itemHeight + sepHeight;
        
        
        _countView.backgroundColor = [UIColor whiteColor];
        _baseInfoView.backgroundColor = [UIColor whiteColor];
        
        
        [_mainContainerView addSubview:_countView];
        [_mainContainerView addSubview:_baseInfoView];
        
        _mainContainerView.contentSize = CGSizeMake(width, originY);
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateLayout {
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat sepHeight = [FMSize getInstance].settingItemSepHeight;
    CGFloat originY = 0;
    CGFloat itemHeight = 0;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight*2;
    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    CGFloat paddingRight = paddingLeft;
    _seperatorIndex = 0;
    
    itemHeight = _countItemHeight;
    [_countView setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = _baseInfoItemHeight;
    [_baseInfoView setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    NSInteger index = 0;
    
    SeperatorView * seperator;
//    if(_task.spots && [_task.spots count] > 0) {
//        seperator = [self getAnSeperator];   //漏检列表最上面一个分割线
//        [seperator setDotted:NO];
//        [seperator setFrame:CGRectMake(0, originY, width, seperatorHeight/2)];
//        originY += seperatorHeight;
//    }
    
    for(PatrolTaskHistorySpot * spot in _task.spots) {
        PatrolHistoryDetailSpotItemView * spotItemView;
        if(index < [_spotViewArray count]) {
            spotItemView = _spotViewArray[index];
            [spotItemView setFrame:CGRectMake(0, originY, width, _spotItemHeight)];
            [spotItemView setHidden:NO];
        } else {
            spotItemView = [[PatrolHistoryDetailSpotItemView alloc] initWithFrame:CGRectMake(0, originY, width, _spotItemHeight)];
            [spotItemView addTarget:self action:@selector(onSpotItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            spotItemView.backgroundColor = [UIColor whiteColor];
            
            [_spotViewArray addObject:spotItemView];
            [_mainContainerView addSubview:spotItemView];
        }
        
        originY += _spotItemHeight;
        
        seperator = [self getAnSeperator];
        [seperator setDotted:NO];
        [seperator setFrame:CGRectMake(0, originY, width, seperatorHeight/2)];
        originY += seperatorHeight;
        
        if(index == _curSpotIndex) {
            NSInteger i = 0;
            
            if(spot.synthesized && ([spot.synthesized.synthesizedOrders count] > 0 || [spot.synthesized.synthesizedContents count] > 0)) {
                PatrolHistoryDetailSpotContentItemView * spotContentItemView;
                
                if(i < [_spotContentViewArray count]) {
                    spotContentItemView = _spotContentViewArray[i];
                    [spotContentItemView setFrame:CGRectMake(0, originY, width, _spotContentItemHeight)];
                    [spotContentItemView setHidden:NO];
                } else {
                    spotContentItemView = [[PatrolHistoryDetailSpotContentItemView alloc] initWithFrame:CGRectMake(0, originY, width, _spotContentItemHeight)];
                    
                    [spotContentItemView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
                    spotContentItemView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L9];
                    [spotContentItemView addTarget:self action:@selector(onSpotEquipmentItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [_spotContentViewArray addObject:spotContentItemView];
                }
                spotContentItemView.tag = i;
                originY += _spotContentItemHeight;
                
                seperator = [self getAnSeperator];
                [seperator setDotted:YES];
                [seperator setFrame:CGRectMake(paddingLeft, originY, width-paddingLeft*2, seperatorHeight)];
                originY += seperatorHeight;
                
                
                NSString * desc = [[BaseBundle getInstance] getStringByKey:@"patrol_comprehensive" inTable:nil];  //综合巡检
                BOOL hasReport = [spot getSynthesizeReportCount] > 0;
                BOOL hasLeak = [spot getSynthesizeLeakCount] > 0;
                BOOL hasException = [spot getSynthesizeExceptionCount] > 0;
                
                [spotContentItemView setInfoWith:desc hasReport:hasReport hasLeak:hasLeak hasException:hasException];
                [_mainContainerView addSubview:spotContentItemView];
                i++;
            }
            
            for(PatrolTaskHistoryEquipment * equip in spot.equipments) {
                
                PatrolHistoryDetailSpotContentItemView * spotContentItemView;
         
                if(i < [_spotContentViewArray count]) {
                    spotContentItemView = _spotContentViewArray[i];
                    [spotContentItemView setFrame:CGRectMake(0, originY, width, _spotContentItemHeight)];
                    [spotContentItemView setHidden:NO];
                } else {
                    spotContentItemView = [[PatrolHistoryDetailSpotContentItemView alloc] initWithFrame:CGRectMake(0, originY, width, _spotContentItemHeight)];
                    
                    [spotContentItemView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
                    spotContentItemView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L9];
                    [spotContentItemView addTarget:self action:@selector(onSpotEquipmentItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [_spotContentViewArray addObject:spotContentItemView];
                }
                spotContentItemView.tag = i;
                originY += _spotContentItemHeight;
                
                seperator = [self getAnSeperator];
                [seperator setDotted:YES];
                [seperator setFrame:CGRectMake(paddingLeft, originY, width-paddingLeft*2, seperatorHeight)];
                originY += seperatorHeight;
                
                
                NSString * desc = equip.name;
                if(![equip.eqId isEqualToNumber:[NSNumber numberWithInteger:0]]) {
                    desc = [[NSString alloc] initWithFormat:@"%@(%@)", equip.name, equip.code];
                }
                
                if(equip.exceptionStatus && equip.exceptionStatus.integerValue == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {
                    [spotContentItemView setInfoWith:desc exceptionStatus:equip.exceptionStatus.integerValue];
                } else {
                    BOOL hasReport = [equip getReportCount] > 0;
                    BOOL hasLeak = [equip getLeakCount] > 0;
                    BOOL hasException = [equip getExceptionCount] > 0;
                    
                    [spotContentItemView setInfoWith:desc hasReport:hasReport hasLeak:hasLeak hasException:hasException];
                }
                [_mainContainerView addSubview:spotContentItemView];
                i++;
                
            }
            
            for(;i<[_spotContentViewArray count];i++) {
                PatrolHistoryDetailSpotContentItemView * spotContentItemView = _spotContentViewArray[i];
                [spotContentItemView setHidden:YES];
            }
        }
        BOOL isLeak = [spot getLeakCount] > 0;
        BOOL isException = [spot getExceptionCount] > 0;
        BOOL hasReport = [spot getReportCount] > 0;
        
        [spotItemView setInfoWithSpotName:spot.spot.name andShowIgnore:isLeak andShowException:isException andShowReport:hasReport];
        spotItemView.tag = index;
        if(_curSpotIndex == index) {
            [spotItemView setExpandState:YES];
        } else {
            [spotItemView setExpandState:NO];
        }
        index++;
        
    }
    for(;index < [_spotViewArray count];index++) {
        PatrolHistoryDetailSpotItemView * spotItemView = _spotViewArray[index];
        [spotItemView setHidden:YES];
    }

    if(_curSpotIndex < 0 || _curSpotIndex >= [_task.spots count]) {
        for(PatrolHistoryDetailSpotContentItemView * spotContentView in _spotContentViewArray) {
            [spotContentView setHidden:YES];
        }
    }

    [self hideUnUsedSeperators];
    originY += sepHeight;
    
    _mainContainerView.contentSize = CGSizeMake(width, originY);
    
    [self updateInfo];
}

- (SeperatorView *) getAnSeperator {
    SeperatorView * seperator;
    if(!_seperatorViewArray) {
        _seperatorViewArray = [[NSMutableArray alloc] init];
    }
    if(_seperatorIndex < [_seperatorViewArray count]) {
        seperator = _seperatorViewArray[_seperatorIndex];
    } else {
        seperator = [[SeperatorView alloc] init];
        [_mainContainerView addSubview:seperator];
        [_seperatorViewArray addObject:seperator];
    }
    _seperatorIndex++;
    [seperator setHidden:NO];
    return seperator;
}

- (void) hideUnUsedSeperators {
    if(_seperatorViewArray && _seperatorIndex < [_seperatorViewArray count]) {
        for(NSInteger index = _seperatorIndex;index < [_seperatorViewArray count];index++) {
            SeperatorView * seperaor = _seperatorViewArray[index];
            [seperaor setHidden:YES];
        }
    }
}

- (void) updateInfo {
    [_countView setInfoWithReportCount:[_task getReportCount] andIgnoreCount:[_task getLeakCount] andExceptionCount:[_task getExceptionCount]];
    [_baseInfoView setInfoWithName:_task.laborer andCycle:[_task getCycle] andEstimateTime:[_task getEstimateTimeString] andActualTime:[_task getActualTimeString]];
}

- (void) setPatrolTaskWithId: (NSNumber *) taskId andTaskName:(NSString *) taskName{
    _taskId = taskId;
    _taskName = taskName;
}


//请求巡检任务详情
- (void) work {
    [self showLoadingDialog];
    [self requestData];
}

//
- (void) requestData {
    [_business requestPatrolTaskDetailById:_taskId success:^(NSInteger key, id object) {
        _task = object;
        [self updateList];
        [self hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        _task = nil;
        [self hideLoadingDialog];
    }];
}

//更新列表
- (void) updateList {
    [self updateLayout];
}

- (void) onSpotItemClicked:(UIButton *) button {
    if(_curSpotIndex == button.tag) {
        _curSpotIndex = -1;
    } else {
        _curSpotIndex = button.tag;
    }
    [self updateList];
}
- (PatrolTaskHistoryEquipment *) getHistoryEquipmentByPosition:(NSInteger) position {
    PatrolTaskHistoryEquipment * equip;
    PatrolTaskHistorySpot * spot = _task.spots[_curSpotIndex];
    if(spot) {
        if(spot.synthesized && ([spot.synthesized.synthesizedOrders count] > 0 || [spot.synthesized.synthesizedContents count] > 0)) {
            if(position == 0) {
                equip = [[PatrolTaskHistoryEquipment alloc] init];
                equip.eqId = [NSNumber numberWithLongLong:0];
                equip.name = [[BaseBundle getInstance] getStringByKey:@"patrol_comprehensive" inTable:nil];
                equip.orders = spot.synthesized.synthesizedOrders;
                equip.patrolTaskItemDetails = spot.synthesized.synthesizedContents;
            } else {
                equip = spot.equipments[position-1];
            }
        } else {
            equip = spot.equipments[position];
        }
    }
    return equip;
}

- (Position *) getLocationOfCurSpot {
    Position * res;
    PatrolTaskHistorySpot * spot = _task.spots[_curSpotIndex];
    res = [spot.locationDetail  copy];
    return res;
}

- (void) onSpotEquipmentItemClicked:(UIButton *) button {
    NSInteger position = button.tag;
    PatrolTaskHistoryEquipmentViewController * viewController = [[PatrolTaskHistoryEquipmentViewController alloc] init];
    PatrolTaskHistoryEquipment * equip = [self getHistoryEquipmentByPosition:position];
    Position * location = [self getLocationOfCurSpot];
    [viewController setInfoWithEquipment:equip andLocation:location];
    [self gotoViewController:viewController];
}

#pragma mark --- 消息
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMPatrolReportSuccess" object:nil];
}

- (void) initPatrolReportSuccessHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMPatrolReportSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMPatrolReportSuccess"
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _needUpdate = YES;
}


@end

