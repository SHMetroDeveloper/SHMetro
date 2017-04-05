//
//  QuickReportTableView.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "QuickReportTableView.h"
#import "FMUtilsPackages.h"
#import "BaseDataEntity.h"
#import "BaseDataDbHelper.h"

#import "QuickReportBaseInfoTableViewCell.h"
#import "QuickReportEquipmentTabBarView.h"
#import "QuickReportEquipmentTableViewCell.h"
#import "QuickReportDescTableViewCell.h"
#import "CellForAudioRecordView.h"

#import "BasePhotoView.h"
#import "SeperatorView.h"


typedef NS_ENUM(NSInteger, QuickReportSectionType) {
    QUICK_REPORT_SECTION_TYPE_BASEINFO,  //基本信息
    QUICK_REPORT_SECTION_TYPE_EQUIPMENT,  //故障设备
    QUICK_REPORT_SECTION_TYPE_AUDIO,  //报障语音
    QUICK_REPORT_SECTION_TYPE_PHOTO,  //报障图片
    QUICK_REPORT_SECTION_TYPE_VIDEO,  //报障视频
    QUICK_REPORT_SECTION_TYPE_DESCRIPTION,  //报障描述
};

typedef NS_ENUM(NSInteger, BasePhotoViewMediaType) {
    MEDIA_BASE_PHOTO_VIEW_TYPE_PHOTO,
    MEDIA_BASE_PHOTO_VIEW_TYPE_VIDEO,
};

static NSString *cellBaseInfoIdentifier = @"cellBaseInfo";
static NSString *cellEquipmentIdentifier = @"cellEquipment";
static NSString *cellAudioIdentifier = @"cellAudio";
static NSString *cellPhotoIdentifier = @"cellPhoto";
static NSString *cellVideoIdentifier = @"cellVideo";
static NSString *cellDescriptionIdentifier = @"cellDescription";

static NSString *cellEquipmentFooterIdentifier = @"cellEquipmentFooter";

@interface QuickReportTableView () <UITableViewDelegate,UITableViewDataSource,OnItemClickListener,OnMessageHandleListener>
@property (nonatomic, strong) QuickReportBaseInfoTableViewCell *baseInfoCell;
@property (nonatomic, strong) QuickReportDescTableViewCell *descCell;
@property (nonatomic, strong) BasePhotoView *photoView;
@property (nonatomic, strong) BasePhotoView *videoView;

@property (nonatomic, strong) QuickReportBaseInfoModel *baseInfo;
@property (nonatomic, strong) NSMutableArray *equipmentArray;
@property (nonatomic, strong) NSMutableArray *audioArray;
@property (nonatomic, strong) NSMutableArray *audioTimeArray;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (readwrite, nonatomic, strong) BaseDataDbHelper *dbHelper;
@end

@implementation QuickReportTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _headerHeight = [FMSize getInstance].selectHeaderHeight;
        
        _dbHelper = [BaseDataDbHelper getInstance];
        
        _realHeight = CGRectGetHeight(frame);
        _realWidth = CGRectGetWidth(frame);
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        self.delaysContentTouches = NO;
        
        [self registerClass:[QuickReportBaseInfoTableViewCell class] forCellReuseIdentifier:cellBaseInfoIdentifier];
        [self registerClass:[QuickReportEquipmentTableViewCell class] forCellReuseIdentifier:cellEquipmentIdentifier];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellAudioIdentifier];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellPhotoIdentifier];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellVideoIdentifier];
        [self registerClass:[QuickReportDescTableViewCell class] forCellReuseIdentifier:cellDescriptionIdentifier];
        [self registerClass:[QuickReportEquipmentTabBarView class] forHeaderFooterViewReuseIdentifier:cellEquipmentFooterIdentifier];
        
    }
    return self;
}

- (void)setQuickReportBaseInfo:(QuickReportBaseInfoModel *)baseInfo {
    _baseInfo = baseInfo;
}

- (void)setQuickReportEquipment:(NSMutableArray *)equipmentArray {
    _equipmentArray = equipmentArray;
}

- (void)setQuickReportAudio:(NSMutableArray *)audioArray {
    _audioArray = audioArray;
}

- (void)setQuickReportAudioTimeInterval:(NSMutableArray *)audioTimeArray {
    _audioTimeArray = audioTimeArray;
}

- (void)setQuickReportPhoto:(NSMutableArray *)photoArray {
    _photoArray = photoArray;
}

- (void)setQuickReportVideo:(NSMutableArray *)videoArray {
    _videoArray = videoArray;
    [self reloadData];
}

- (QuickReportBaseInfoModel *)quickReportBaseInfo {
    QuickReportBaseInfoModel *model = [[QuickReportBaseInfoModel alloc] init];
    model.applicant = _baseInfo.applicant;
    model.phoneNumber = [_baseInfoCell phoneNumber];
    model.serviceType = _baseInfo.serviceType;
    model.location = _baseInfo.location;
    model.desc = [_descCell getContent];
    return model;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (BOOL)needShowAudio {
    BOOL res = YES;
    if (!_audioArray || _audioArray.count == 0) {
        res = NO;
    }
    return res;
}

- (BOOL)needShowPhoto {
    BOOL res = YES;
    if (!_photoArray || _photoArray.count == 0) {
        res = NO;
    }
    return res;
}

- (BOOL)needShowVideo {
    BOOL res = YES;
    if (!_videoArray || _videoArray.count == 0) {
        res = NO;
    }
    return res;
}

- (QuickReportSectionType)getSectionTypeBySection:(NSInteger)section {
    QuickReportSectionType sectionType = QUICK_REPORT_SECTION_TYPE_BASEINFO;
    if (section >= 2 && ![self needShowAudio]) {
        section += 1;
    }
    if (section >= 3 && ![self needShowPhoto]) {
        section += 1;
    }
    if (section >= 4 && ![self needShowVideo]) {
        section += 1;
    }
    switch (section) {
        case 0:
            sectionType = QUICK_REPORT_SECTION_TYPE_BASEINFO;
            break;
            
        case 1:
            sectionType = QUICK_REPORT_SECTION_TYPE_EQUIPMENT;
            break;
            
        case 2:
            sectionType = QUICK_REPORT_SECTION_TYPE_AUDIO;
            
            break;
            
        case 3:
            sectionType = QUICK_REPORT_SECTION_TYPE_PHOTO;
            break;
            
        case 4:
            sectionType = QUICK_REPORT_SECTION_TYPE_VIDEO;
            break;
            
        case 5:
            sectionType = QUICK_REPORT_SECTION_TYPE_DESCRIPTION;
            break;
    }
    
    return sectionType;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 3;
    if (_audioArray.count > 0) {
        count += 1;
    }
    if (_photoArray.count > 0) {
        count += 1;
    }
    if (_videoArray.count > 0) {
        count += 1;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    QuickReportSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case QUICK_REPORT_SECTION_TYPE_BASEINFO:
            count = 1;
            break;
            
        case QUICK_REPORT_SECTION_TYPE_EQUIPMENT:
            count = _equipmentArray.count;
            break;
            
        case QUICK_REPORT_SECTION_TYPE_AUDIO:
            count = _audioArray.count;
            break;
            
        case QUICK_REPORT_SECTION_TYPE_PHOTO:
            if (_photoArray.count > 0) {
                count = 1;
            }
            break;
            
        case QUICK_REPORT_SECTION_TYPE_VIDEO:
            if (_videoArray.count) {
                count = 1;
            }
            break;
            
        case QUICK_REPORT_SECTION_TYPE_DESCRIPTION:
            count = 1;
            break;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    
    QuickReportSectionType sectionType = [self getSectionTypeBySection:indexPath.section];
    switch (sectionType) {
        case QUICK_REPORT_SECTION_TYPE_BASEINFO:
            height = [QuickReportBaseInfoTableViewCell getItemHeight];
            break;
            
        case QUICK_REPORT_SECTION_TYPE_EQUIPMENT:
            height = [QuickReportEquipmentTableViewCell getItemHeightByShowLocation:YES];
            break;
            
        case QUICK_REPORT_SECTION_TYPE_AUDIO:
            height = [CellForAudioRecordView getItemHeight];
            break;
            
        case QUICK_REPORT_SECTION_TYPE_PHOTO:
            height = [BasePhotoView calculateHeightByCount:_photoArray.count width:_realWidth addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
            break;
            
        case QUICK_REPORT_SECTION_TYPE_VIDEO:
            height = [BasePhotoView calculateHeightByCount:_videoArray.count width:_realWidth addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
            break;
            
        case QUICK_REPORT_SECTION_TYPE_DESCRIPTION:
            height = [QuickReportDescTableViewCell getItemHeight];
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    UITableViewCell *cell = nil;
    CellForAudioRecordView *audioItemView = nil;
    SeperatorView *seperator = nil;
    
    QuickReportSectionType sectionType = [self getSectionTypeBySection:indexPath.section];
    switch (sectionType) {
        case QUICK_REPORT_SECTION_TYPE_BASEINFO:{
            _baseInfoCell = [tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier];
            _baseInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [_baseInfoCell setOnItemLickListener:self];
            cell = _baseInfoCell;
        }
            break;
            
        case QUICK_REPORT_SECTION_TYPE_EQUIPMENT:{
            cell = [tableView dequeueReusableCellWithIdentifier:cellEquipmentIdentifier];
        }
            break;
            
        case QUICK_REPORT_SECTION_TYPE_AUDIO:{
            cell = [tableView dequeueReusableCellWithIdentifier:cellAudioIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CGFloat audioHeight = [CellForAudioRecordView getItemHeight];
            if (cell) {
                NSArray *subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[CellForAudioRecordView class]]) {
                        audioItemView = (CellForAudioRecordView *)view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *)view;
                    }
                }
            }
            if (cell && !audioItemView) {
                audioItemView = [[CellForAudioRecordView alloc] init];
                [audioItemView setEditable:YES];
                [audioItemView setOnItemClickListener:self];
                audioItemView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
                audioItemView.tag = position;
                [cell addSubview:audioItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (audioItemView) {
                [audioItemView setFrame:CGRectMake(0, 0, _realWidth, audioHeight)];
                NSNumber *time = _audioTimeArray[position];
                [audioItemView setDuriationTime:time];
            }
            if (seperator) {
                [seperator setFrame:CGRectMake(0, audioHeight-seperatorHeight, _realWidth, seperatorHeight)];
            }
        }
            break;
            
        case QUICK_REPORT_SECTION_TYPE_PHOTO:{
            cell = [tableView dequeueReusableCellWithIdentifier:cellPhotoIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CGFloat photoHeight = [BasePhotoView calculateHeightByCount:_photoArray.count width:_realWidth addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
            if (cell) {
                NSArray *subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[BasePhotoView class]]) {
                        _photoView = (BasePhotoView *)view;
                    }
                }
            }
            if (cell && !_photoView) {
                _photoView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, photoHeight)];
                [_photoView setEditable:YES];
                [_photoView setEnableAdd:NO];
                [_photoView setOnMessageHandleListener:self];
                _photoView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
                _photoView.tag = MEDIA_BASE_PHOTO_VIEW_TYPE_PHOTO;
                [cell addSubview:_photoView];
            }
            if (_photoView) {
                [_photoView setFrame:CGRectMake(0, 0, _realWidth, photoHeight)];
                [_photoView setPhotosWithArray:_photoArray];
            }
        }
            break;
            
        case QUICK_REPORT_SECTION_TYPE_VIDEO:
            cell = [tableView dequeueReusableCellWithIdentifier:cellVideoIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CGFloat videoHeight = [BasePhotoView calculateHeightByCount:_videoArray.count width:_realWidth addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
            if (cell) {
                NSArray *subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[BasePhotoView class]]) {
                        _videoView = (BasePhotoView *)view;
                    }
                }
            }
            if (cell && !_videoView) {
                _videoView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, videoHeight)];
                [_videoView setEditable:YES];
                [_videoView setEnableAdd:NO];
                [_videoView setOnMessageHandleListener:self];
                _videoView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
                _videoView.tag = MEDIA_BASE_PHOTO_VIEW_TYPE_VIDEO;
                [cell addSubview:_videoView];
            }
            if (_videoView) {
                [_videoView setFrame:CGRectMake(0, 0, _realWidth, videoHeight)];
                [_videoView setPhotosWithArray:_videoArray];
            }
            break;
            
        case QUICK_REPORT_SECTION_TYPE_DESCRIPTION:{
            _descCell = [tableView dequeueReusableCellWithIdentifier:cellDescriptionIdentifier];
            _descCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [_descCell setMaxTextLength:300];
            [_descCell setTextPlaceHolder:[[BaseBundle getInstance] getStringByKey:@"report_question_desc" inTable:nil]];
            cell = _descCell;
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    QuickReportSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case QUICK_REPORT_SECTION_TYPE_BASEINFO:{
            [_baseInfoCell setApplicant:_baseInfo.applicant phoneNumber:_baseInfo.phoneNumber serviceType:_baseInfo.serviceType.fullName location:[_dbHelper getLocationBy:_baseInfo.location]];
        }
            break;
            
        case QUICK_REPORT_SECTION_TYPE_EQUIPMENT:{
            QuickReportEquipmentTableViewCell *cuseCell = (QuickReportEquipmentTableViewCell *)cell;
            if (position == _equipmentArray.count - 1) {
                [cuseCell setSeperatorGapped:NO];
            } else {
                [cuseCell setSeperatorGapped:YES];
            }
            [cuseCell setShowLocation:YES];
            Device *dev = _equipmentArray[position];
            [cuseCell setInfoWithCode:dev.code name:dev.name location:[_dbHelper getLocationBy:dev.position]];
        }
            break;
            
        case QUICK_REPORT_SECTION_TYPE_AUDIO:
            
            break;
            
        case QUICK_REPORT_SECTION_TYPE_PHOTO:
            
            break;
            
        case QUICK_REPORT_SECTION_TYPE_VIDEO:
            
            break;
            
        case QUICK_REPORT_SECTION_TYPE_DESCRIPTION:{
            if (![FMUtils isStringEmpty:_baseInfo.desc]) {
                [_descCell setContent:_baseInfo.desc];
            }
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
    headerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    UILabel * titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 320, 30)];//此处数据都是根据carrie的设计稿来的
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.text = @"";
    titleLbl.font = [FMFont getInstance].listCodeFont;
    titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    [headerView addSubview:titleLbl];
    
    QuickReportSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case QUICK_REPORT_SECTION_TYPE_BASEINFO:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"quick_report_section_title_baseinfo" inTable:nil];
            break;
        case QUICK_REPORT_SECTION_TYPE_EQUIPMENT:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"quick_report_section_title_equipment" inTable:nil];
            break;
        case QUICK_REPORT_SECTION_TYPE_AUDIO:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"quick_report_section_title_audio" inTable:nil];
            break;
        case QUICK_REPORT_SECTION_TYPE_PHOTO:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"quick_report_section_title_photo" inTable:nil];
            break;
            
        case QUICK_REPORT_SECTION_TYPE_VIDEO:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"quick_report_section_title_video" inTable:nil];
            break;
        case QUICK_REPORT_SECTION_TYPE_DESCRIPTION: {
            
            /* 利用富文本添加 * 标 */
            NSString *title = [[[BaseBundle getInstance] getStringByKey:@"quick_report_section_title_desc" inTable:nil] stringByAppendingString:@" *"];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
            NSRange range = [title rangeOfString:@"*"];
            [text addAttribute:NSForegroundColorAttributeName value:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] range:range];
            [text addAttribute:NSFontAttributeName value:[FMFont setFontByPX:60] range:range];
            [text addAttribute:NSBaselineOffsetAttributeName value:@(-6) range:range];
            titleLbl.attributedText = text;
        }
            break;
        default:
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01;
    QuickReportSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case QUICK_REPORT_SECTION_TYPE_EQUIPMENT:
            height = [QuickReportEquipmentTabBarView getItemHeight];
            break;
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = nil;
    QuickReportSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case QUICK_REPORT_SECTION_TYPE_EQUIPMENT:{
            QuickReportEquipmentTabBarView *custFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellEquipmentFooterIdentifier];
            __weak typeof(self) weakSelf = self;
            custFooter.actionBlock = ^(QuickReportEquipmentTabActionType type, id object){
                if (type == QUICK_REPORT_EQUIPMENT_TAB_ACTION_SELECT) {
                    weakSelf.actionBlock(QUICK_REPORT_ACTION_EQUIPMENT_ADD_DIRECT, nil);
                } else if (type == QUICK_REPORT_EQUIPMENT_TAB_ACTION_QR_SCAN) {
                    weakSelf.actionBlock(QUICK_REPORT_ACTION_EQUIPMENT_ADD_SCAN, nil);
                }
            };
            footer = custFooter;
        }
            break;
        default:
            break;
    }
    return footer;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canEditable = NO;
    QuickReportSectionType sectionType = [self getSectionTypeBySection:indexPath.section];
    if (sectionType == QUICK_REPORT_SECTION_TYPE_EQUIPMENT) {
        canEditable = YES;
    }
    return canEditable;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSArray *actionArray = nil;
    QuickReportSectionType sectionType = [self getSectionTypeBySection:section];
    if (sectionType == QUICK_REPORT_SECTION_TYPE_EQUIPMENT) {
        UITableViewRowAction * delectAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_delete" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            _actionBlock(QUICK_REPORT_ACTION_EQUIPMENT_DELETE, [NSNumber numberWithInteger:position]);
        }];
        delectAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
        actionArray = @[delectAction];
    }
    return actionArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    QuickReportSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case QUICK_REPORT_SECTION_TYPE_EQUIPMENT:{
            Device *dev = _equipmentArray[position];
            _actionBlock(QUICK_REPORT_ACTION_EQUIPMENT_DETAIL, dev);
        }
            break;
        default:
            break;
    }
}

#pragma mark - OnItemClickListener
- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    if ([view isKindOfClass:[QuickReportBaseInfoTableViewCell class]]) {
        QuickReportBaseItemType itemType = subView.tag;
        switch (itemType) {
            case QUICK_REPORT_BASE_ITEM_TYPE_SERVICE:
                _actionBlock(QUICK_REPORT_ACTION_BASE_INFO_SERVICETYPE, nil);
                break;
                
            case QUICK_REPORT_BASE_ITEM_TYPE_LOCATION:
                _actionBlock(QUICK_REPORT_ACTION_BASE_INFO_LOCATION, nil);
                break;
            default:
                break;
        }
    } else if ([view isKindOfClass:[CellForAudioRecordView class]]) {
        NSInteger position = view.tag;
        AudioDetailButtonType buttonType = subView.tag;
        switch (buttonType) {
            case AUDIO_PLAY_BUTTON_TYPE:
                _actionBlock(QUICK_REPORT_ACTION_MEDIA_AUDIO_SHOW, [NSNumber numberWithInteger:position]);
                break;
                
            case AUDIO_DELETE_BUTTON_TYPE:
                _actionBlock(QUICK_REPORT_ACTION_MEDIA_AUDIO_DELETE, [NSNumber numberWithInteger:position]);
                break;
        }
    }
}

- (void)handleMessage:(id)msg {
    NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
    if ([strOrigin isEqualToString:NSStringFromClass([BasePhotoView class])]) {
        NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
        PhotoActionType type = [tmpNumber integerValue];
        tmpNumber = [msg valueForKeyPath:@"tag"];
        NSInteger tag = tmpNumber.integerValue;
        if(tag == MEDIA_BASE_PHOTO_VIEW_TYPE_PHOTO) {
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    _actionBlock(QUICK_REPORT_ACTION_MEDIA_PHOTO_SHOW, tmpNumber);
                    break;
                case PHOTO_ACTION_DELETE:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    _actionBlock(QUICK_REPORT_ACTION_MEDIA_PHOTO_DELETE, tmpNumber);
                    break;
                default:
                    break;
            }
        } else if(tag == MEDIA_BASE_PHOTO_VIEW_TYPE_VIDEO) {
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    _actionBlock(QUICK_REPORT_ACTION_MEDIA_VIDEO_SHOW, tmpNumber);
                    break;
                case PHOTO_ACTION_DELETE:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    _actionBlock(QUICK_REPORT_ACTION_MEDIA_VIDEO_DELETE, tmpNumber);
                    break;
                default:
                    break;
            }
        }
    }
}

@end
