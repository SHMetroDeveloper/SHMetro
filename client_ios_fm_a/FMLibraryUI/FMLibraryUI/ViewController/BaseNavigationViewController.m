//
//  BaseNavigationViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate {
    return YES;
}

//- (NSUInteger)supportedInterfaceOrientations {
//    return [self.viewControllers.lastObject supportedInterfaceOrientations];
//}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAll;
//}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return [self.viewControllers.lastObject
            preferredInterfaceOrientationForPresentation];
}

@end

