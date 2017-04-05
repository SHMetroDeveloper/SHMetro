//
//  PhoneListAlertContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/8.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PhoneListAlertContentView.h"
#import "PhoneItemView.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "SeperatorView.h"

@interface PhoneListAlertContentView () <OnItemClickListener>

@property (readwrite, nonatomic, strong) UITableView * phoneTableView;
@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, assign) CGFloat phoneItemHeight;

@property (readwrite, nonatomic, strong) NSMutableArray * phones;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) BaseViewController* baseVC;
@end


@implementation PhoneListAlertContentView

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
        
        _phoneItemHeight = 60;
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _phoneTableView = [[UITableView alloc] init];
        
        _phoneTableView.delegate = self;
        _phoneTableView.dataSource = self;
        _phoneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [self addSubview:_phoneTableView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat padding = 0;
    [_phoneTableView setFrame:CGRectMake(0, padding, width, height-padding)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_phoneTableView reloadData];
}

- (void) setPhones:(NSMutableArray *)phones {
    _phones = [phones copy];
    [self updateInfo];
}

//获取高度
- (CGFloat) getSuitableHeight {
    NSInteger count = [_phones count];
    CGFloat height = _phoneItemHeight*count;
    return height;
}

//
- (void) setOnPhoneDelegate:(BaseViewController *) baseVC {
    _baseVC = baseVC;
}

- (void) makeCallWith:(NSString *) phone {
    if(_baseVC) {
        if([FMUtils isMobile:phone]) {
            [FMUtils makeCallWith:phone container:_baseVC];
        } else {
            [_baseVC showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_call_fail_telno" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}

- (void) sendMessageTo:(NSString *) phone {
    NSLog(@"发送消息");
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [_phones count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return _phoneItemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
   
    NSString *cellIdentifier = nil;
    UITableViewCell* cell = nil;
    
    PhoneItemView *phoneItemView = nil;
    CGFloat width = self.frame.size.width;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding*4;
    SeperatorView * seperator;
    
    cellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subViews = [cell subviews];
        for(UIView * view in subViews) {
            if([view isKindOfClass:[PhoneItemView class]]) {
                phoneItemView = (PhoneItemView *)view;
            }
            if([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *)view;
            }
            if(phoneItemView && seperator) {
                break;
            }
        }
    }
    if(cell && !phoneItemView) {
        phoneItemView = [[PhoneItemView alloc] initWithFrame:CGRectMake(0, 0, width, _phoneItemHeight)];
        [phoneItemView setPaddingLeft:padding andPaddingRight:padding];
        [phoneItemView setOnItemClickListener:self];
        [cell addSubview:phoneItemView];
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, _phoneItemHeight-seperatorHeight, width-padding * 2, seperatorHeight)];
        [cell addSubview:seperator];
    }
    if(seperator) {
        [seperator setFrame:CGRectMake(padding, _phoneItemHeight-seperatorHeight, width-padding, seperatorHeight)];
        if(position < [_phones count] - 1) {
            [seperator setHidden:NO];
        } else {
            [seperator setHidden:YES];
        }
    }
    if(phoneItemView) {
        NSString * phone = _phones[position];
        [phoneItemView setFrame:CGRectMake(0, 0, width, _phoneItemHeight)];
        [phoneItemView setInfoWithPhoneNumber:phone];
        phoneItemView.tag = position;
    }
    
    return cell;
}



- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = nil;
    return headerView;
}



- (NSString*) tableView: (UITableView*) tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 滑动删除
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil];
}



#pragma mark - 点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[PhoneItemView class]]) {
        NSInteger position = view.tag;
        NSString * phone = _phones[position];
        [self makeCallWith:phone];
    }
}

@end
