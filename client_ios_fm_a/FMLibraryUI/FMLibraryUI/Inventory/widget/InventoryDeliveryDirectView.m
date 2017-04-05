//
//  InventoryDeliveryDirectView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/25/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryDeliveryDirectView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "InventoryDeliveryDirectTableHelper.h"
#import "UIButton+Bootstrap.h"

@interface InventoryDeliveryDirectView () <OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UITableView * tableView;

//@property (readwrite, nonatomic, strong) UIButton * addMaterialBtn; //添加物料

@property (readwrite, nonatomic, strong) UIView * controlView;
@property (readwrite, nonatomic, strong) UIButton * okBtn;  //出库


@property (readwrite, nonatomic, strong) InventoryDeliveryDirectTableHelper * helper;

@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, assign) CGFloat controlHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation InventoryDeliveryDirectView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _helper = [[InventoryDeliveryDirectTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        
        _btnWidth = [FMSize getInstance].filterWidth;
        _btnHeight = [FMSize getInstance].btnBottomControlHeight;
        _controlHeight = [FMSize getInstance].btnBottomControlHeight + [FMSize getInstance].padding20;

        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _tableView.dataSource = _helper;
        _tableView.delegate = _helper;
        
        
        _controlView = [[UIView alloc] init];
        _okBtn = [[UIButton alloc] init];
        
        [_okBtn setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_btn_stock_out" inTable:nil] forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [FMFont getInstance].font44;
        
        [_okBtn addTarget:self action:@selector(onOkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_controlView addSubview:_okBtn];
        
        [self addSubview:_tableView];
        [self addSubview:_controlView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat padding = [FMSize getInstance].padding20;
    
    [_tableView setFrame:CGRectMake(0, 0, width, height-_controlHeight)];
    
    [_controlView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    [_okBtn setFrame:CGRectMake(padding, 0, width-padding*2, _btnHeight)];
    
    [_okBtn successStyle];
}

- (void) updateList {
    [_tableView reloadData];
}

- (void) setInfoWithWarehouse:(NSString *) warehouse {
    [_helper setInfoWithWarehouseName:warehouse];
    [self updateList];
}

- (void) setInfoWithAdministrator:(NSString *) administrator {
    [_helper setInfoWithAdministrator:administrator];
    [self updateList];
}

- (void) setInfoWithSupervisor:(NSString *) supervisor {
    [_helper setInfoWithSupervisor:supervisor];
    [self updateList];
}

- (void) setInfoWithReceivingPerson:(NSString *) person {
    [_helper setInfoWithReceivingPerson:person];
    [self updateList];
}

//设置物料数组
- (void) setInfoWithMaterials:(NSMutableArray *) materials {
    [_helper setInfoWithMaterials:materials];
    [self updateList];
}

//添加物料
- (void) addMaterial:(MaterialEntity *) material {
    [_helper addMaterial:material];
    [self updateList];
}


//设置物料的出库量
- (void) setAmount:(NSNumber *) amount forMaterial:(NSNumber *) inventoryId {
    [_helper setAmount:amount forMaterial:inventoryId];
}

- (void) deleteMaterialAtPosition:(NSInteger) position {
    [_helper deleteMaterialAtPosition:position];
    [self updateList];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) onOkBtnClicked:(id) sender {
    NSLog(@"出库");
    [self notifyEvent:INVENTORY_DELIVERY_EVENT_DELIVERY data:nil];
}

#pragma mark - 处理事件
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            id data = [result valueForKeyPath:@"eventData"];
            InventoryDeliveryTableEventType eventType = [tmpNumber integerValue];
            switch(eventType) {
                case INVENTORY_DELIVERY_TABLE_EVENT_SELECT_WAREHOUSE:
                    [self notifyEvent:INVENTORY_DELIVERY_EVENT_SELECT_WAREHOUSE data:nil];
                    break;
                case INVENTORY_DELIVERY_TABLE_EVENT_SELECT_ADMINISTRATOR:
                    [self notifyEvent:INVENTORY_DELIVERY_EVENT_SELECT_ADMINISTRATOR data:nil];
                    break;
                case INVENTORY_DELIVERY_TABLE_EVENT_SELECT_SUPERVISOR:
                    [self notifyEvent:INVENTORY_DELIVERY_EVENT_SELECT_SUPERVISOR data:nil];
                    break;
                case INVENTORY_DELIVERY_TABLE_EVENT_SELECT_RECEIVING_PERSON:
                    [self notifyEvent:INVENTORY_DELIVERY_EVENT_SELECT_RECEIVING_PERSON data:nil];
                    break;
                    
                case INVENTORY_DELIVERY_TABLE_EVENT_SHOW_MATERIAL:
                    [self notifyEvent:INVENTORY_DELIVERY_EVENT_SHOW_MATERIAL data:data];
                    break;
                case INVENTORY_DELIVERY_TABLE_EVENT_DELETE_MATERIAL:
                    [self notifyEvent:INVENTORY_DELIVERY_EVENT_DELETE_MATERIAL data:data];
                    break;

                default:
                    break;
            }
        }
    }
}

#pragma mark - 发送事件通知
- (void) notifyEvent:(InventoryDeliveryDirectEventType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithInteger:type] forKeyPath:@"eventType"];
        [result setValue:data forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

@end
