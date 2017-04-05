//
//  QuickReportBaseInfoTableViewCell.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "QuickReportBaseInfoTableViewCell.h"
#import "FMUtilsPackages.h"
#import "MarkEditView2.h"
#import "SeperatorView.h"
#import "ReportServerConfig.h"

@interface QuickReportBaseInfoTableViewCell () <OnClickListener>

@property (nonatomic, strong) MarkEditView2 *applicantView;          //申请人
@property (nonatomic, strong) MarkEditView2 *phoneNumberView;        //联系电话
@property (nonatomic, strong) MarkEditView2 *serviceTypeView;        //服务类型
@property (nonatomic, strong) MarkEditView2 *locationView;           //站点

@property (nonatomic, strong) SeperatorView *applicantSeperator;
@property (nonatomic, strong) SeperatorView *phoneNumberSeperator;
@property (nonatomic, strong) SeperatorView *serviceTypeSeperator;
@property (nonatomic, strong) SeperatorView *locationSeperator;

@property (nonatomic, strong) NSString *applicant;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign) BOOL isInited;

@property (nonatomic, weak) id<OnItemClickListener> itemClickListener;

@end

@implementation QuickReportBaseInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _applicantView = [[MarkEditView2 alloc] init];
        [_applicantView setEditable:NO showMore:NO isMarked:YES];
        _applicantView.tag = QUICK_REPORT_BASE_ITEM_TYPE_APPLICANT;
        
        _phoneNumberView = [[MarkEditView2 alloc] init];
        [_phoneNumberView setEditable:YES showMore:NO isMarked:YES];
        _phoneNumberView.tag = QUICK_REPORT_BASE_ITEM_TYPE_PHONE;
        
        _serviceTypeView = [[MarkEditView2 alloc] init];
        [_serviceTypeView setEditable:NO showMore:YES isMarked:NO];
        [_serviceTypeView setOnClickListener:self];
        _serviceTypeView.tag = QUICK_REPORT_BASE_ITEM_TYPE_SERVICE;
        
        _locationView = [[MarkEditView2 alloc] init];
        [_locationView setEditable:NO showMore:YES isMarked:YES];
        [_locationView setOnClickListener:self];
        _locationView.tag = QUICK_REPORT_BASE_ITEM_TYPE_LOCATION;
        
        _applicantSeperator = [[SeperatorView alloc] init];
        _phoneNumberSeperator = [[SeperatorView alloc] init];
        _serviceTypeSeperator = [[SeperatorView alloc] init];
        _locationSeperator = [[SeperatorView alloc] init];
        

        [self.contentView addSubview:_applicantView];
        [self.contentView addSubview:_phoneNumberView];
        [self.contentView addSubview:_serviceTypeView];
        [self.contentView addSubview:_locationView];
        
        [self.contentView addSubview:_applicantSeperator];
        [self.contentView addSubview:_phoneNumberSeperator];
        [self.contentView addSubview:_serviceTypeSeperator];
        [self.contentView addSubview:_locationSeperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetWidth(self.frame);
    CGFloat itemHeight = 48;
    CGFloat padding = 15;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat originX = 0;
    CGFloat originY = 0;
    
    [_applicantView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    originY += itemHeight;
    [_applicantSeperator setFrame:CGRectMake(padding, originY-seperatorHeight, width-padding*2, seperatorHeight)];
    
    [_phoneNumberView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    originY += itemHeight;
    [_phoneNumberSeperator setFrame:CGRectMake(padding, originY-seperatorHeight, width-padding*2, seperatorHeight)];
    
    [_serviceTypeView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    originY += itemHeight;
    [_serviceTypeSeperator setFrame:CGRectMake(padding, originY-seperatorHeight, width-padding*2, seperatorHeight)];
    
    [_locationView setFrame:CGRectMake(originX, originY, width, itemHeight)];
    originY += itemHeight;
    [_locationSeperator setFrame:CGRectMake(0, originY-seperatorHeight, width, seperatorHeight)];
}

- (void)updateInfo {
    [_applicantView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_reporter" inTable:nil] andDescription:_applicant];
    
    NSString *phone = [_phoneNumberView getContent];
    if(![FMUtils isStringEmpty:phone] && ![phone isEqualToString:_phone]){
        _phone = phone;
    }
    [_phoneNumberView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_telno" inTable:nil] andDescription:_phone];
    
    [_serviceTypeView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_service_type" inTable:nil] andDescription:_serviceType];
    
    [_locationView setTitle:[[BaseBundle getInstance] getStringByKey:@"report_location" inTable:nil] andDescription:_location];
    
    [self setNeedsLayout];
}

- (void)setApplicant:(NSString *)applicant
         phoneNumber:(NSString *)phoneNumber
         serviceType:(NSString *)serviceType
            location:(NSString *)location {
    _applicant = applicant;
    _phone = phoneNumber;
    _serviceType = serviceType;
    _location = location;
    
    [self updateInfo];
}

- (NSString *)phoneNumber {
    NSString *res = @"";
    res = [_phoneNumberView getContent];
    return res;
}

#pragma mark - OnItemClickListener Delegate
- (void) setOnItemLickListener:(id<OnItemClickListener>) listener {
    _itemClickListener = listener;
}

#pragma mark - OnClickListener
- (void)onClick:(UIView *)view {
    if(view == _serviceTypeView) {
        [self onServiceTypeClick];
    } else if(view == _locationView) {
        [self onLocationClick];
    }
}

- (void)onServiceTypeClick {
    if(_itemClickListener) {
        [_itemClickListener onItemClick:self subView:_serviceTypeView];
    }
}

- (void)onLocationClick {
    if(_itemClickListener) {
        [_itemClickListener onItemClick:self subView:_locationView];
    }
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat itemHeight = 48;
    
    height = itemHeight*4;
    
    return height;
}


@end


