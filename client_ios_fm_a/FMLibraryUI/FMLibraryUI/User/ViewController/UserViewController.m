//
//  UserViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/10.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  "我的" 界面

#import "UserViewController.h"
#import "BaseGroupView.h"
#import "UserInfoView.h"
#import "BaseBundle.h"
#import "ChangePasswordViewController.h"
#import "OutlineDownloadViewController.h"
#import "FeedbackViewController.h"
#import "PhoneBindViewController.h"
#import "UserNetRequest.h"
#import "SystemConfig.h"
#import "BaseDataDBHelper.h"
#import "BaseDataNetRequest.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MyReportViewController.h"
#import "CameraHelper.h"
#import "UserPhotoSetEntity.h"
#import "FileUploadService.h"
#import "UserBusiness.h"
#import "MyQrCodeViewController.h"
#import "AttendanceRecordViewController.h"
#import "CommonBusiness.h"

@interface UserViewController () <UIScrollViewDelegate, FileUploadListener>

//主滑动视图
@property (nonatomic, strong) UIScrollView *mainContentView;

//用户信息视图
@property (nonatomic, strong) UserInfoView *userView;

@property (nonatomic, strong) BaseGroupView *groupReport;
@property (nonatomic, strong) BaseItemView *reportView; //我的报障
@property (nonatomic, strong) BaseItemView *attendanceRecordView; //我的签到记录

@property (nonatomic, strong) BaseGroupView *groupPhone;
@property (nonatomic, strong) BaseItemView *phoneView; //绑定手机
@property (nonatomic, strong) BaseItemView *resetPasswordView; //重置密码

@property (nonatomic, strong) BaseGroupView *groupQrCode;
@property (nonatomic, strong) BaseItemView *myQrCodeView; //我的二维码

@property (nonatomic, strong) BaseGroupView *groupSetting;
@property (nonatomic, strong) BaseItemView *settingView; //设置

//照片选取
@property (nonatomic, strong) CameraHelper *helper;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSNumber *photoId;

//手机号
@property (nonatomic, strong) NSString *phone;

//状态图标
@property (nonatomic, strong) UpdateRecord *record;

@end

@implementation UserViewController


/**
 懒加载
 
 @return 照片选取
 */
- (CameraHelper *)helper {
    
    if (_helper == nil) {
        
        _helper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:NO];
        [_helper setAllowCrop:YES];
        [_helper setOnMessageHandleListener:self];
    }
    return _helper;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //从数据库获取用户信息
    [self getUserInfoFromDB];
    
    //从服务器请求用户信息
    [self requestUserInfo];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabBar];
}


#pragma mark - 初始化视图

- (void) initLayout {
    
    CGFloat groupItemHeight = [FMSize getInstance].userItemHeight; //单元格高度
    CGFloat groupSepHeight = [FMSize getInstance].userItemSepHeight; //段头高度
    
    //左右间隔
    CGFloat paddingLeft = [FMSize getInstance].userPaddingLeft;
    CGFloat paddingRight = [FMSize getInstance].userPaddingRight;
    
    CGRect frame = [self getContentFrame];
    frame.size.height -= [FMSize getInstance].tabbarHeight;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat iconHeight = [FMSize getInstance].userItemLogoWidth;
    CGFloat userInfoHeight = height / 3;
    CGFloat originY = 0;
    
    //主滑动视图
    _mainContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    _mainContentView.showsVerticalScrollIndicator = NO;
    _mainContentView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    _mainContentView.delegate = self;
    _mainContentView.delaysContentTouches = NO;
    
    //用户信息
    _userView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, width, userInfoHeight)];
    [_userView setShowBounds:NO];
    NSString *loginName = [SystemConfig getLoginName];
    [_userView setInfoWithName:loginName];
    _userView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_userView addTarget:self action:@selector(showPhotoMenus) forControlEvents:UIControlEventTouchUpInside];
    originY += userInfoHeight;
    
    NSInteger groupItemCount = 2;
    _groupReport = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, groupItemHeight *groupItemCount)];
    [_groupReport setItemHeight:groupItemHeight];
    [_groupReport setBoundsType:BOUNDS_TYPE_NONE];
    
    //我的报障
    _reportView = [[BaseItemView alloc] init];
    [_reportView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2]];
    [_reportView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_my_report" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"user_function_my_report"] andDesc:@""];
    [_reportView addTarget:self action:@selector(onMyReportClicked) forControlEvents:UIControlEventTouchUpInside];
    [_reportView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
    [_reportView setShowMore:YES];
    [_reportView setLogoImageWidth:iconHeight];
    
    //我的签到记录
    _attendanceRecordView = [[BaseItemView alloc] init];
    [_attendanceRecordView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2]];
    [_attendanceRecordView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"user_my_attendance_record" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"user_function_my_attendance_record"] andDesc:@""];
    [_attendanceRecordView addTarget:self action:@selector(onAttendanceRecordClicked) forControlEvents:UIControlEventTouchUpInside];
    [_attendanceRecordView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
    [_attendanceRecordView setShowMore:YES];
    [_attendanceRecordView setLogoImageWidth:iconHeight];
    
    [_groupReport addMember:_reportView];
    [_groupReport addMember:_attendanceRecordView];
    originY += groupItemHeight * groupItemCount + groupSepHeight;
    
    groupItemCount = 2;
    _groupPhone = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, groupItemHeight * groupItemCount)];
    [_groupPhone setItemHeight:groupItemHeight];
    [_groupPhone setBoundsType:BOUNDS_TYPE_NONE];
    
    //绑定手机
    _phoneView = [[BaseItemView alloc] init];
    [_phoneView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2]];
    [_phoneView setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3]];
    [_phoneView setDescFont:[FMFont getInstance].defaultFontLevel2];
    [_phoneView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"user_telno" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"user_function_bind_mobile"] andDesc:@""];
    [_phoneView addTarget:self action:@selector(onPhoneBindClicked) forControlEvents:UIControlEventTouchUpInside];
    [_phoneView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
    [_phoneView setLogoImageWidth:iconHeight];
    [_phoneView setShowMore:YES];
    
    //重置密码
    _resetPasswordView = [[BaseItemView alloc] init];
    [_resetPasswordView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2]];
    [_resetPasswordView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"user_reset_password" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"user_function_reset_password"]];
    [_resetPasswordView addTarget:self action:@selector(onResetPasswordClicked) forControlEvents:UIControlEventTouchUpInside];
    [_resetPasswordView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
    [_resetPasswordView setLogoImageWidth:iconHeight];
    [_resetPasswordView setShowMore:YES];
    
    [_groupPhone addMember:_phoneView];
    [_groupPhone addMember:_resetPasswordView];
    originY += groupItemHeight * groupItemCount + groupSepHeight;
    
    groupItemCount = 1;
    _groupQrCode = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, groupItemHeight * groupItemCount)];
    [_groupQrCode setBoundsType:BOUNDS_TYPE_NONE];
    [_groupQrCode setItemHeight:groupItemHeight];
    
    //我的二维码
    _myQrCodeView = [[BaseItemView alloc] init];
    [_myQrCodeView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2]];
    [_myQrCodeView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"user_my_qrcode" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"user_function_my_qrcode"]];
    [_myQrCodeView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
    [_myQrCodeView setLogoImageWidth:iconHeight];
    [_myQrCodeView addTarget:self action:@selector(onMyQrCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    [_myQrCodeView setShowMore:YES];
    
    [_groupQrCode addMember:_myQrCodeView];
    originY += groupItemHeight * groupItemCount + groupSepHeight;
    
    
    groupItemCount = 1;
    _groupSetting = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, groupItemHeight * groupItemCount)];
    [_groupSetting setBoundsType:BOUNDS_TYPE_NONE];
    [_groupSetting setItemHeight:groupItemHeight];
    
    //设置
    _settingView = [[BaseItemView alloc] init];
    [_settingView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2]];
    [_settingView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_setting" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"user_function_setting"]];
    [_settingView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
    [_settingView setLogoImageWidth:iconHeight];
    [_settingView setShowMore:YES];
    [_settingView addTarget:self action:@selector(onSettingClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_groupSetting addMember:_settingView];
    originY += groupItemHeight * groupItemCount + groupSepHeight;
    
    _mainContentView.contentSize = CGSizeMake(frame.size.width, originY);
    
    [_mainContentView addSubview:_userView];
    [_mainContentView addSubview:_groupReport];
    [_mainContentView addSubview:_groupPhone];
    [_mainContentView addSubview:_groupQrCode];
    [_mainContentView addSubview:_groupSetting];
    [self.view addSubview:_mainContentView];
}


/**
 从数据库获取用户信息
 */
- (void)getUserInfoFromDB {
    
    UserInfo *user = [[BaseDataDbHelper getInstance] queryUserById:[SystemConfig getUserId]];
    if(user) {
        
        //更新用户信息
        [self updateUserInfo:user];
    }
}


/**
 从服务器请求用户信息
 */
- (void)requestUserInfo {
    
    [[UserBusiness getInstance] getCurrentUserInfoSuccess:^(NSInteger key, id object) {
        
        if(object) {
            
            UserInfo *user = object;
            
            //更新用户信息
            [self updateUserInfo:user];
            
            //缓存到本地
            user.loginName = [SystemConfig getLoginName];
            if(user) {
                
                [[BaseDataDbHelper getInstance] saveUserInfo:user];
            }
        }
    } fail:^(NSInteger key, NSError *error) {
        
        DLog(@"ERROR: %@", error);
    }];
}


/**
 更新用户信息
 */
- (void)updateUserInfo:(UserInfo *)newInfo {
    
    [_userView setInfoWithName:newInfo.name andPhotoUrl:[FMUtils getUrlOfImageById:newInfo.pictureId] andDesc:newInfo.organizationName];
    _phone = newInfo.phone;
    [_phoneView updateDesc:[FMUtils getSecretFormatMobile:_phone]];
}


/**
 照片选择
 */
- (void)showPhotoMenus {
    
    [self.helper getPhotoWithWaterMark:nil];
}


/**
 照片选择完成
 */
- (void)handleMessage:(id)msg {
    
    if(msg) {
        
        NSString *strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if ([strOrigin isEqualToString:NSStringFromClass([CameraHelper class])]) {
            
            NSArray *imgPaths = [msg valueForKeyPath:@"result"];
            for (NSString *path in imgPaths) {
                
                _photo = [FMUtils getImageWithName:path];
                [_userView setInfoWithPhoto:_photo];
            }
            [self requestSaveUserPhoto];
        }
    }
}


/**
 保存照片并上传
 */
- (void)requestSaveUserPhoto {
    
    self.tabBarController.tabBar.hidden = NO;
    if(_photo) {
        
        NSMutableArray *files = [[NSMutableArray alloc] initWithObjects:_photo, nil];
        [[FileUploadService getInstance] uploadImageFiles:files listener:self];
    }
    else {
        
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"user_photo_set_notice_null" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}


/**
 设置用户头像
 */
- (void)requestBindUserPhoto {
    
    if(_photoId) {
        
        UserPhotoSetParam *param = [[UserPhotoSetParam alloc] init];
        param.photoId = _photoId;
        UserNetRequest *netRequest = [UserNetRequest getInstance];
        [netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            DLog(@"用户头像设置成功");
            
            //更新数据库头像
            UserInfo *user = [[BaseDataDbHelper getInstance] queryUserById:[SystemConfig getUserId]];
            if(user) {
                
                user.pictureId = _photoId;
                [[BaseDataDbHelper getInstance] saveUserInfo:user];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            DLog(@"用户头像设置失败");
        }];
    }
}


#pragma mark - 文件上传的代理方法

/**
 文件上传完成
 */
- (void)onUploadFileFinished:(NSURLResponse *)response object:(id)responseObject {
    
    DLog(@"文件上传成功");
    
    if(responseObject) {
        
        _photoId = responseObject[0];
        if(_photoId) {
            
            //设置用户头像
            [self requestBindUserPhoto];
        }
    }
}


/**
 文件上传失败
 */
- (void)onUploadFileError:(NSURLResponse *)response error:(NSError *)error {
    
    DLog(@"文件上传失败");
}


#pragma mark - 滑动事件监听

/**
 监听滑动事件
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat top = scrollView.contentOffset.y;
    
    DLog(@"------------------%.1f", top);
}


#pragma mark - 表格的跳转

/**
 我的报障
 */
- (void)onMyReportClicked {
    
    MyReportViewController *myreportVC = [[MyReportViewController alloc] init];
    [self gotoViewController:myreportVC];
}


/**
 我的签到记录
 */
- (void)onAttendanceRecordClicked {
    
    AttendanceRecordViewController *attendanceRecordViewController = [[AttendanceRecordViewController alloc] init];
    [self gotoViewController:attendanceRecordViewController];
}


/**
 绑定手机
 */
- (void)onPhoneBindClicked {
    
    PhoneBindViewController *viewController = [[PhoneBindViewController alloc] init];
    [viewController setPhone:_phone];
    [self gotoViewController:viewController];
}


/**
 重置密码
 */
- (void)onResetPasswordClicked {
    
    ChangePasswordViewController *viewController = [[ChangePasswordViewController alloc] init];
    [self gotoViewController:viewController];
}


/**
 我的二维码
 */
- (void)onMyQrCodeClicked {
    
    MyQrCodeViewController *myQrCodeViewController = [[MyQrCodeViewController alloc] init];
    [self gotoViewController:myQrCodeViewController];
}


/**
 设置
 */
- (void)onSettingClicked {
    
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self gotoViewController:settingVC];
}

@end
