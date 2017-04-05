//
//  TestMainViewController.m
//  client_ios_fm_a
//
//  Created by flynn.yang on 2017/2/22.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import "TestMainViewController.h"
#import "FMNavigationViewController.h"
#import "TestFirstViewController.h"
#import "TestSecondViewController.h"
#import "UserViewController.h"
#import "BaseBundle.h"

@interface TestMainViewController ()

@end

@implementation TestMainViewController


- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}


- (void) viewDidLoad {
    [super viewDidLoad];
    //do what you want
}

- (void) initViews {
    CGFloat tabbarHeight = [FMSize getInstance].tabbarHeight;
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-tabbarHeight);
    FMNavigationViewController *firstViewController = nil;
    
    TestFirstViewController* test1VC = [[TestFirstViewController alloc] init];
    
    firstViewController = [[FMNavigationViewController alloc] initWithRootViewController:test1VC];
    
    TestSecondViewController * test2VC = [[TestSecondViewController alloc] init];
    FMNavigationViewController *secondViewController = [[FMNavigationViewController alloc] initWithRootViewController:test2VC];
    
    UserViewController * test3VC = [[UserViewController alloc] init];
    FMNavigationViewController *thirdController = [[FMNavigationViewController alloc] initWithRootViewController:test3VC];
    
    self.viewControllers = [NSArray arrayWithObjects:firstViewController, secondViewController, thirdController, nil];
    
    self.delegate = self;
    
    UITabBar *tabBar = self.tabBar;
    tabBar.tintColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    tabBar.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_TABBAR_BG];
    
    
    UIImage *img = [FMUtils buttonImageFromColor:[UIColor clearColor] width:CGRectGetWidth(self.view.frame) height:1];
    [tabBar setShadowImage:img];
    [tabBar setBackgroundImage:[[UIImage alloc] init]];
    tabBar.layer.borderWidth = [FMSize getInstance].seperatorHeight;
    tabBar.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
    
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    
    tabBarItem1.title = @"原生";
    [tabBarItem1 setSelectedImage:[[FMTheme getInstance] getImageByName:@"tabhost_task_selected"]];
    [tabBarItem1 setImage:[[FMTheme getInstance] getImageByName:@"tabhost_task_unselected"]];
    
    tabBarItem2.title = @"继承";
    [tabBarItem2 setSelectedImage:[[FMTheme getInstance] getImageByName:@"tabhost_function_selected"]];
    [tabBarItem2 setImage:[[FMTheme getInstance] getImageByName:@"tabhost_function_unselected"]];
    
    tabBarItem3.title = @"直接用";
    [tabBarItem3 setSelectedImage:[[FMTheme getInstance] getImageByName:@"tabhost_user_selected"]];
    [tabBarItem3 setImage:[[FMTheme getInstance] getImageByName:@"tabhost_user_unselected"]];
    
}


@end
